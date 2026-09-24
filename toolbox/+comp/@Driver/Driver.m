classdef Driver
    %DRIVER Class definition for a loudspeaker driver
    %   A driver is described by the parameters Re, Le, Qes, Qms, Fs, Sd and Vas. The other parameters
    %   (Bl, Cms, Mmd, ...) are derived from them. zeb, zm, te, tbl, tm and tsd return the impedances and
    %   two-port transmission matrices of the driver that lspsys uses to solve the system.

    properties
        Re (1,1) double {mustBeNonnegative} = 0; % Resistance of the voice coil in [Ohm]
        Le (1,1) double {mustBeNonnegative} = 0; % Inductance of the voice coil in [H]
        Qes (1,1) double {mustBeNonnegative} = 0; % Electrical Q [-]
        Qms (1,1) double {mustBeNonnegative} = 0; % Mechanical Q [-]
        Fs (1,1) double {mustBeNonnegative} = 0; % The suspension resonance frequency [Hz]
        Sd (1,1) double {mustBeNonnegative} = 0; % Effective area of the diaphragm [m2]
        Vas (1,1) double {mustBeNonnegative} = 0; % Equivalent suspension volume [m3]
    end

    properties (Dependent)
        Bl % Product of air-gap magnetic field times length of wire in the voice coil winding [Tm]
        Cms % Total mechanical compliance of suspension [m/N]
        Mmd % Mass of the diaphragm and the voice coil in [kg]
        Mms % Mass of the diaphragm and the voice coil, including air load [kg]
        Mmi % Mass contributed by the air load on one side of the piston [kg]
        Rms % Mechanical resistance of the suspension in [Ns/m]
        DiaphragmRadius % Radius of effective area of the diaphragm [m]
        Qts % Total Q of the driver
    end

    methods
        function obj = Driver
            %DRIVER Create a loudspeaker driver
            %   obj = Driver creates a driver with all parameters set to zero.
        end

        function val = get.Bl(obj)
            %BL Product of air-gap magnetic field times length of wire in the voice coil winding [Tm]
            val = sqrt(obj.Re/(2*pi*obj.Fs*obj.Qes*obj.Cms));
        end

        function val = get.Cms(obj)
            %CMS Total mechanical compliance of suspension [m/N]
            val = obj.Vas/(obj.Sd^2*lspsys.AirDensity*lspsys.SpeedOfSound^2);
        end

        function val = get.Mmd(obj)
            %MMD Mass of the diaphragm and the voice coil in [kg]
            val = obj.Mms - 2*obj.Mmi;
        end

        function val = get.Mms(obj)
            %MMS Mass of the diaphragm and the voice coil, including air load [kg]
            val = 1./((2*pi*obj.Fs)^2*obj.Cms);
        end

        function val = get.Mmi(obj)
            %MMI Mass contributed by the air load on one side of the piston [kg]
            val = 2.67*obj.DiaphragmRadius^3*lspsys.AirDensity;
        end

        function val = get.Rms(obj)
            %RMS Mechanical resistance of the suspension in [Ns/m]
            val = 1/obj.Qms*sqrt(obj.Mms/obj.Cms);
        end

        function val = get.DiaphragmRadius(obj)
            %DIAPHRAGMRADIUS Radius of effective area of the diaphragm [m]
            val = sqrt(obj.Sd/pi);
        end

        function val = get.Qts(obj)
            %QTS Total Q of the driver
            val = obj.Qes*obj.Qms/(obj.Qes+obj.Qms);
        end

        function val = zeb(obj,f)
            %ZEB Blocked electrical impedance
            %   val = zeb(obj,f) returns the electrical impedance of the voice coil with the diaphragm blocked,
            %   Re + j*w*Le, in [Ohm] at the frequencies f in [Hz].

            % Frequency in [rad/s]:
            w = 2*pi*f;

            % Blocked electrical impedance [Ohm]:
            val = obj.Re + 1i*w*obj.Le;
        end

        function val = zm(obj,f)
            %ZM Mechanical impedance
            %   val = zm(obj,f) returns the mechanical impedance in [Ns/m] at the frequencies f in [Hz].

            % Frequency in [rad/s]:
            w = 2*pi*f;

            val = 1i*w*obj.Mmd + obj.Rms + 1./(1i*w*obj.Cms);
        end

        function val = te(obj,f)
            %TE Electrical transmission matrices
            %   val = te(obj,f) returns the 2x2 transmission matrix of the electrical impedance for each
            %   frequency in f, as a 2x2xnumel(f) array.

            % Number of frequencies
            nf = numel(f);

            % Blocked electrical impedance:
            zebInt = obj.zeb(f);

            % Transmission matrices:
            val = repmat([1 0; 0 1],1,1,nf);

            % Add zebInt:
            val(1,2,:) = zebInt;
        end

        function val = tbl(obj)
            %TBL Transmission matrix BL
            %   val = tbl(obj) returns the 2x2 transmission matrix of the electromechanical transduction.
            val = [0 obj.Bl; obj.Bl^-1 0];
        end

        function val = tm(obj,f)
            %TM Transmission matrix for mechanical part
            %   val = tm(obj,f) returns the 2x2 transmission matrix of the mechanical impedance for each
            %   frequency in f, as a 2x2xnumel(f) array.

            % Number of frequencies:
            nf = numel(f);

            % Mechanical impedance:
            zmInt = obj.zm(f);

            % Transmission matrices:
            val = repmat([1 0; 0 1],1,1,nf);

            % Add zmInt:
            val(1,2,:) = zmInt;
        end

        function val = tsd(obj)
            %TSD Transmission matrix for diaphragm
            %   val = tsd(obj) returns the 2x2 transmission matrix of the effective diaphragm area.
            val = [obj.Sd 0; 0 obj.Sd^-1];
        end
    end
end
