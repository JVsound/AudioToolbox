classdef resultTest < matlab.unittest.TestCase
    %RESULTTEST Tests for result
    %   Tests Pressure and SoundPressureLevel of the result that lspsys creates for the fixture driver in a
    %   closed box of 200 L (the Vas of the driver). The level is compared with the closed-box formulas of
    %   R. H. Small, also given at DIY Loudspeaker Design, page "Sealed Boxes"
    %   (sites.google.com/site/diyloudspeakerdesign). The tests run for every value of RadiationAngle.

    properties (TestParameter)
        RadiationAngle = {"2pi"}; % Add further radiation angles here when lspsys supports them
    end

    properties (Constant,Access = private)
        BoxVolume = 200e-3; % Volume of the closed box in [m3]
    end

    methods (Test)
        function pressureMagnitude(testCase,RadiationAngle)
            %PRESSUREMAGNITUDE Pressure magnitude follows from the density of air, frequency and volume velocity
            testResult = testCase.createTestResult(RadiationAngle);
            rho = lspsys.AirDensity;
            f = testResult.Frequency;
            Ur = testResult.RadiatedVolumeVelocity;
            rMic = testResult.MicRadius;

            % Radiation angle "2pi": the factor 2*pi of the angular frequency cancels the 2*pi of the radiation:
            expected = rho*f.*abs(Ur)/rMic;
            testCase.verifyEqual(abs(testResult.Pressure),expected,RelTol=1e-12);
        end

        function pressurePhase(testCase,RadiationAngle)
            %PRESSUREPHASE Pressure leads the volume velocity by 90 degrees minus the phase of the travel time
            testResult = testCase.createTestResult(RadiationAngle);
            k = 2*pi*testResult.Frequency/lspsys.SpeedOfSound;
            ratio = testResult.Pressure./testResult.RadiatedVolumeVelocity;
            expected = 1i*exp(-1i*k*testResult.MicRadius);
            testCase.verifyEqual(ratio./abs(ratio),expected,AbsTol=1e-10);
        end

        function levelDefinition(testCase,RadiationAngle)
            %LEVELDEFINITION Level is the pressure magnitude in dB relative to 20 uPa
            testResult = testCase.createTestResult(RadiationAngle);
            expected = 20*log10(abs(testResult.Pressure)/20e-6);
            testCase.verifyEqual(testResult.SoundPressureLevel,expected,AbsTol=1e-10);
        end

        function levelDropsWithDistance(testCase,RadiationAngle)
            %LEVELDROPSWITHDISTANCE Level drops by 6.02 dB when the distance to the microphone doubles
            testResult = testCase.createTestResult(RadiationAngle);
            nearLevel = testResult.SoundPressureLevel;
            testResult.MicRadius = 2*testResult.MicRadius;
            testCase.verifyEqual(nearLevel-testResult.SoundPressureLevel,repmat(20*log10(2),size(nearLevel)), ...
                AbsTol=1e-10);
        end

        function levelAtResonance(testCase,RadiationAngle)
            %LEVELATRESONANCE Level at the resonance frequency is 20*log10(Qtc) relative to the passband level
            testResult = testCase.createTestResult(RadiationAngle);
            [fc,Qtc] = testCase.closedBoxSystem;
            expected = testCase.passbandLevel(testResult) + 20*log10(Qtc);
            actual = interp1(testResult.Frequency,testResult.SoundPressureLevel,fc);
            testCase.verifyEqual(actual,expected,AbsTol=0.5);
        end

        function lowerCutoffFrequency(testCase,RadiationAngle)
            %LOWERCUTOFFFREQUENCY Frequency where the level is 3 dB below the passband level
            testResult = testCase.createTestResult(RadiationAngle);
            [fc,Qtc] = testCase.closedBoxSystem;
            a1 = 1/Qtc^2 - 2;
            expected = fc*sqrt((a1+sqrt(a1^2+4))/2);
            below = testResult.Frequency <= 2*fc;
            level = testResult.SoundPressureLevel(below);
            cutoffLevel = testCase.passbandLevel(testResult) - 3;
            actual = interp1(level,testResult.Frequency(below),cutoffLevel);
            testCase.verifyEqual(actual,expected,RelTol=0.05);
        end

        function levelFollowsClosedBoxResponse(testCase,RadiationAngle)
            %LEVELFOLLOWSCLOSEDBOXRESPONSE Level follows the second-order high-pass response of a closed box
            %   Above about 400 Hz the voice coil inductance lowers the level, which this response does not include.
            testResult = testCase.createTestResult(RadiationAngle);
            [fc,Qtc] = testCase.closedBoxSystem;
            band = testResult.Frequency >= 30 & testResult.Frequency <= 400;
            x = testResult.Frequency(band)/fc;
            response = x.^2./sqrt(x.^4+(1/Qtc^2-2)*x.^2+1);
            expected = testCase.passbandLevel(testResult) + 20*log10(response);
            testCase.verifyEqual(testResult.SoundPressureLevel(band),expected,AbsTol=1.5);
        end
    end

    methods (Access = private)
        function testResult = createTestResult(testCase,angle)
            %CREATETESTRESULT Result of the fixture driver in the closed box
            enclosure = comp.ClosedBox;
            enclosure.Driver = createTestDriver;
            enclosure.RearVolume = testCase.BoxVolume;
            loudspeaker = lspsys;
            loudspeaker.Enclosure = enclosure;
            loudspeaker.RadiationAngle = angle;
            testResult = loudspeaker.createResult;
        end

        function [fc,Qtc] = closedBoxSystem(testCase)
            %CLOSEDBOXSYSTEM Resonance frequency and total Q of the fixture driver in the closed box
            driver = createTestDriver;
            Qts = driver.Qes*driver.Qms/(driver.Qes+driver.Qms);
            compliance = sqrt(1+driver.Vas/testCase.BoxVolume);
            fc = driver.Fs*compliance;
            Qtc = Qts*compliance;
        end

        function level = passbandLevel(~,testResult)
            %PASSBANDLEVEL Level from the reference efficiency of a direct radiator, 4*pi^2*Fs^3*Vas/(c^3*Qes)
            driver = createTestDriver;
            c = lspsys.SpeedOfSound;
            efficiency = 4*pi^2*driver.Fs^3*driver.Vas/(c^3*driver.Qes);
            inputPower = testResult.SourceVoltage(1)^2/driver.Re;

            % Radiation angle "2pi": the acoustic power spreads over a half sphere of 2*pi*r^2:
            intensity = efficiency*inputPower/(2*pi*testResult.MicRadius^2);
            level = 10*log10(lspsys.AirDensity*c*intensity/lspsys.ReferencePressure^2);
        end
    end
end
