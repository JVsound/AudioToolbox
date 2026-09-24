classdef result
    %RESULT Results of a loudspeaker system calculation
    %   A result object holds the arrays that lspsys calculates over Frequency: the source voltage and
    %   current and the volume velocities of the diaphragm and the radiated sound. lspsys.createResult
    %   creates it. ElectricalImpedance, Pressure and SoundPressureLevel are derived from these arrays.

    properties (SetAccess = ?lspsys)
        Frequency (1,:) double = 0; % Frequencies of the calculation in [Hz]
        SourceVoltage (1,:) double = 0; % RMS voltage of the source in [V]
        SourceCurrent (1,:) double = 0; % Current of the source in [A]
        DiaphragmVolumeVelocity (1,:) double = 0; % Volume velocity of the diaphragm in [m3/s]
        RadiatedVolumeVelocity (1,:) double = 0; % Volume velocity of the radiated sound in [m3/s]
        RadiationAngle (1,1) string = "2pi"; % Radiation angle of the enclosure
    end

    properties
        MicRadius (1,1) double {mustBePositive} = 1; % Distance in [m] from the radiation surface to the microphone
    end

    properties (Dependent)
        ElectricalImpedance % Electrical impedance of the system in [Ohm]
        Pressure % Complex sound pressure at MicRadius in [Pa]
        SoundPressureLevel % Sound pressure level at MicRadius in [dB]
    end

    methods
        function obj = result
            %RESULT Create a result object
            %   obj = result creates a result object with all arrays set to zero.
        end

        function val = get.ElectricalImpedance(obj)
            %ELECTRICALIMPEDANCE Electrical impedance of the system in [Ohm]
            val = obj.SourceVoltage./obj.SourceCurrent;
        end

        function val = get.Pressure(obj)
            %PRESSURE Complex sound pressure at MicRadius in [Pa]

            % Pressure on the axis of a source with volume velocity Urad that radiates into the solid angle of
            % RadiationAngle, at distance rMic in the far field: p = j*w*rho*Urad*exp(-j*k*rMic)/(solidAngle*rMic).
            % Source: L. Beranek and T. Mellow, Acoustics: Sound Fields, Transducers and Vibration, 2nd ed.,
            % Academic Press, 2019 (sound sources: monopole and piston in an infinite baffle).

            % Solid angle in [sr]. Give every supported RadiationAngle its solid angle here:
            switch obj.RadiationAngle
                case "2pi"
                    solidAngle = 2*pi;
                otherwise
                    error("result:unsupportedRadiationAngle","Unsupported radiation angle ""%s"".",obj.RadiationAngle)
            end

            % Angular frequency in [rad/s]:
            w = 2*pi*obj.Frequency;

            % Wave number in [rad/m]:
            k = lspsys.f2k(obj.Frequency);

            % Density of air in [kg/m3], volume velocity in [m3/s] and distance in [m]:
            rho = lspsys.AirDensity;
            Urad = obj.RadiatedVolumeVelocity;
            rMic = obj.MicRadius;

            % Sound pressure:
            val = 1i*rho*w.*Urad.*exp(-1i*k*rMic)/(solidAngle*rMic);
        end

        function val = get.SoundPressureLevel(obj)
            %SOUNDPRESSURELEVEL Sound pressure level at MicRadius in [dB]

            % Level of the RMS pressure relative to the reference pressure of lspsys:
            val = 20*log10(abs(obj.Pressure)/lspsys.ReferencePressure);
        end
    end
end
