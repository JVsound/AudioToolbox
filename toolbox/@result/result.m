classdef result
    %RESULT Results of a loudspeaker system calculation
    %   A result object holds the arrays that lspsys calculates over Frequency: the source voltage and
    %   current and the volume velocities of the diaphragm and the radiated sound. lspsys.createResult
    %   creates it. ElectricalImpedance, Pressure, SoundPressureLevel and DiaphragmExcursion are derived from these
    %   arrays.
    %   Pressure comes from the transfer to the microphone (MicTransfer) when the enclosure gives one, and
    %   otherwise from the radiated volume velocity at the distance MicRadius. maxSoundPressureLevel gives the
    %   highest level that the power handling and the excursion of the driver (Driver) allow.

    properties (SetAccess = ?lspsys)
        Frequency (1,:) double = 0; % Frequencies of the calculation in [Hz]
        SourceVoltage (1,:) double = 0; % RMS voltage of the source in [V]
        SourceCurrent (1,:) double = 0; % Current of the source in [A]
        DiaphragmVolumeVelocity (1,:) double = 0; % Volume velocity of the diaphragm in [m3/s]
        RadiatedVolumeVelocity (1,:) double = 0; % Volume velocity of the radiated sound in [m3/s]
        RadiationAngle (1,1) string = "2pi"; % Radiation angle of the enclosure
        MicTransfer (1,:) double = zeros(1,0); % Transfer p_mic/U_d in [Pa.s/m3] from the enclosure, or empty
        Driver (1,1) comp.Driver = comp.Driver; % Driver of the system, with its limits for maxSoundPressureLevel
    end

    properties
        MicRadius (1,1) double {mustBePositive} = 1; % Distance in [m] from the radiation surface to the microphone
    end

    properties (Dependent)
        ElectricalImpedance % Electrical impedance of the system in [Ohm]
        Pressure % Complex sound pressure at MicRadius in [Pa]
        SoundPressureLevel % Sound pressure level at MicRadius in [dB]
        DiaphragmExcursion % Complex excursion of the diaphragm in [m], RMS like SourceVoltage
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

            % When the enclosure gives the transfer to the microphone (for example from an FEA model), the
            % pressure is that transfer times the diaphragm volume velocity; MicRadius is then fixed by the model:
            if ~isempty(obj.MicTransfer)
                val = obj.MicTransfer.*obj.DiaphragmVolumeVelocity;
                return
            end

            % Otherwise, pressure on the axis of a source with volume velocity Urad that radiates into the solid
            % angle of RadiationAngle, at distance rMic in the far field:
            % p = j*w*rho*Urad*exp(-j*k*rMic)/(solidAngle*rMic).
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

        function val = get.DiaphragmExcursion(obj)
            %DIAPHRAGMEXCURSION Complex excursion of the diaphragm in [m], RMS like SourceVoltage

            % The excursion is the volume velocity divided by j*w and the effective area of the diaphragm; the
            % peak excursion of a sine signal is sqrt(2) times its magnitude:
            w = 2*pi*obj.Frequency;
            val = obj.DiaphragmVolumeVelocity./(1i*w*obj.Driver.Sd);
        end

        function [val,powerLevel,excursionLevel] = maxSoundPressureLevel(obj,limits)
            %MAXSOUNDPRESSURELEVEL Highest sound pressure level that the power and the excursion limits allow
            %   val = maxSoundPressureLevel(obj) returns the maximum sound pressure level in [dB] at each frequency,
            %   for a sine signal, with the limits that the driver chooses in ExcursionLimit and PowerLimit.
            %
            %   [val,powerLevel,excursionLevel] = maxSoundPressureLevel(obj) also returns the level that the power
            %   limit alone allows and the level that the excursion limit alone allows; val is the lower of both.
            %
            %   val = maxSoundPressureLevel(obj,Excursion=X,Power=P) uses other limits without changing the
            %   driver. X is the name of an excursion limit of the driver ("Xmax", "Xvar", "Xlim" or "Xmech") or
            %   a peak excursion in [m], one way. P is the name of a power limit of the driver ("Pnom", "Pcont",
            %   "Paes1984" or "Paes2012") or a power in [W].
            %
            %   The model is linear, so the level scales with the source voltage. The excursion limits the voltage
            %   at which the peak excursion sqrt(2)*|DiaphragmExcursion| reaches the limit. A power limit of the driver
            %   limits the RMS voltage to sqrt(P*Z), with the impedance of its definition: Zmin for Pnom, Pcont
            %   and Paes1984 (AES2-1984), Znom for Paes2012 (AES2-2012). A power in [W] is the real power into the
            %   actual electrical impedance Z_e: the RMS voltage is |Z_e|*sqrt(P/Re(Z_e)). The lower voltage sets
            %   the maximum level at each frequency.
            arguments
                obj
                limits.Excursion (1,1) {mustBeA(limits.Excursion,["string","char","double"])} = ...
                    obj.Driver.ExcursionLimit % Name of an excursion limit, or a peak excursion in [m]
                limits.Power (1,1) {mustBeA(limits.Power,["string","char","double"])} = ...
                    obj.Driver.PowerLimit % Name of a power limit, or a power in [W]
            end

            % Peak excursion of the diaphragm at the source voltage of the calculation, in [m]:
            excursion = sqrt(2)*abs(obj.DiaphragmExcursion);

            % Highest RMS source voltage by the excursion limit, in [V]:
            excursionLimit = obj.driverLimit(limits.Excursion,["Xmax","Xvar","Xlim","Xmech"]);
            excursionVoltage = obj.SourceVoltage.*excursionLimit./excursion;

            % Highest RMS source voltage by the power limit, in [V]:
            powerLimit = obj.driverLimit(limits.Power,["Pnom","Pcont","Paes1984","Paes2012"]);
            if isnumeric(limits.Power)
                % Real power into the actual electrical impedance:
                Ze = obj.ElectricalImpedance;
                thermalVoltage = abs(Ze).*sqrt(powerLimit./real(Ze));
            else
                % Impedance of the definition of the power limit:
                if string(limits.Power) == "Paes2012"
                    impedanceName = "Znom";
                else
                    impedanceName = "Zmin";
                end
                impedance = obj.driverLimit(impedanceName,impedanceName);
                thermalVoltage = sqrt(powerLimit*impedance);
            end

            % The level scales with the source voltage; the lower level sets the maximum:
            powerLevel = obj.SoundPressureLevel + 20*log10(thermalVoltage./obj.SourceVoltage);
            excursionLevel = obj.SoundPressureLevel + 20*log10(excursionVoltage./obj.SourceVoltage);
            val = min(powerLevel,excursionLevel);
        end
    end

    methods (Access = private)
        function val = driverLimit(obj,limit,names)
            %DRIVERLIMIT Value of a limit, given as a number or as the name of a property of the driver
            %   A name must be one of names, and the property of the driver must not be 0 (not given).
            if isnumeric(limit)
                val = limit;
                return
            end
            limit = string(limit);
            if ~ismember(limit,names)
                error("result:unknownLimit","Unknown limit ""%s"": use one of %s.",limit,strjoin(names,", "))
            end
            val = obj.Driver.(limit);
            if val == 0
                error("result:missingLimit","Driver.%s is not given.",limit)
            end
        end
    end
end
