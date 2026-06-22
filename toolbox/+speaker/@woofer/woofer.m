classdef woofer
    %WOOFER Class of the speaker package.
    %   Cone loudspeaker, defined by its Thiele & Small parameters
    
    properties
        brand   (1,1) string {}                     = ""        % Brand or manufacturer of speaker
        model   (1,1) string {}                     = ""        % Model of speaker
        size    (1,1) double {}                     = ""        % Diameter of speaker in inches

        re      (1,1) double {}                     = 0         % Voice coil resistance [Ohm]
        qes     (1,1) double {}                     = 0         % Electrical Q [-]
        qms     (1,1) double {}                     = 0         % Mechanical Q [-]
        fs      (1,1) double {}                     = 0         % Resonant frequency [Hz]
        sd      (1,1) double {}                     = 0         % Diaphragm area [m2]
        vas     (1,1) double {}                     = 0         % Equivalent suspension volume [m3]

        le      (1,1) double {}                     = 0         % Voice coil inductance [H]
        xmax    (1,1) double {}                     = 0         % Maximum diaphragm excursion one way [m]
        pmax    (1,1) double {}                     = 0         % Maximum power handling [W]

		% Semi-inductance
		rea		(1,1) double {}						= 0			% Re', substitutes Re and includes additions due to eddy currents in "ac-shorting devices" outside the air gap.
		leb		(1,1) double {}						= 0			% Stray inductance due to flux around the coil out of touch with the iron ...
		rss		(1,1) double {}						= 0			% Impedance of copper inside the air gap
		ke		(1,1) double {}						= 0			% Semi-inductance due to the solid iron core.
		lea		(1,1) double {}						= 0			% Le', substitutes Le (so we can keep le equal to the one from a datasheet).
    end

    properties (Dependent)
        qts                                         % Total Q of speaker [-]
        cms                                         % Mechanical compliance of suspension [m/N]
        kms                                         % Mechanical stiffness of suspension [N/m]
        mms                                         % Combined diaphragm and air-load mass [kg]
        mmd                                         % Mass of the diaphragm and the voice coil [kg]
        rms                                         % Mechanical resistance of the suspension [Ns/m]
        bl                                          % Product of magnetic flux density in the voice coil gap and the length of wire in the magnetic field [Tm]
        a                                           % Diaphragm (piston) radius [m]
    end
    
    methods
        function obj = woofer
            %WOOFER Construct an instance of this class.
        end
        function val = get.qts(obj)
            %QTS

            val     = obj.qes * obj.qms / (obj.qes + obj.qms);
        end
        function val = get.cms(obj)
            %CMS

            val     = obj.vas / (obj.sd^2 * acoustics.misc.rho0 * ...
                acoustics.misc.c^2);
        end
        function val = get.kms(obj)
            %KMS

            val     = 1 / obj.cms;
        end
        function val = get.mms(obj)
            %MMS

            val     = 1 / ((2*pi * obj.fs)^2 * obj.cms);
        end
        function val = get.mmd(obj)
            %MMD

            % mm1:
            mm1     = 2.67 * obj.a^3 * acoustics.misc.rho0;

            val     = obj.mms - 2 * mm1;
        end
        function val = get.rms(obj)
            %RMS

            val     = 1 / obj.qms * sqrt(obj.mms/obj.cms);
        end
        function val = get.bl(obj)
            %BL

            val     = sqrt(obj.re / (2*pi * obj.fs * obj.qes * obj.cms));
        end
        function val = get.a(obj)
            %A

            val     = sqrt(obj.sd / pi);
        end
        function val = ze(obj,w)
            %ZE Electrical impedance

			% Semi-inductance or not:
			if any(obj.rea)
				% Semi-inductance calculation for ze:

				val		= obj.rea + 1i*w*obj.leb + ...
					( 1 ./ (1i*w*obj.lea) + 1 ./ obj.rss + ...
					1 ./ (obj.ke * sqrt(1i*w)) ).^-1;
			else
				% No semi-inductance:

				val     = obj.re + 1i*w*obj.le;
			end

        end
        function val = zm(obj,w)
            %ZM Mechanical impedance

            val     = 1i * w * obj.mmd + obj.rms + 1 ./ (1i * w * obj.cms);
        end
    end
end