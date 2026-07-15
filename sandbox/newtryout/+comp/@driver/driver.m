classdef driver
	%LSP Class definition for a loudspeaker driver.

	properties
		re		(1,1) double {mustBeNonnegative}	= 0;	% Resistance of the voice coil in [Ohm]
		le		(1,1) double {mustBeNonnegative}	= 0;	% Inductance of the voice coil in [H]
		qes		(1,1) double {mustBeNonnegative}	= 0;	% Electrical Q [-]
		qms		(1,1) double {mustBeNonnegative}	= 0;	% Mechanical Q [-]
		fs		(1,1) double {mustBeNonnegative}	= 0;	% The suspension resonance frequency [Hz]
		sd		(1,1) double {mustBeNonnegative}	= 0;	% Effective area of the diaphragm [m2]
		vas		(1,1) double {mustBeNonnegative}	= 0;	% Equivalent suspension volume [m3]
	end

	properties (Dependent)
		bl		(1,1) double								% Product of air-gap magnetic field times length of wire in the voice coil winding [Tm]
		cms		(1,1) double								% Total mechanical compliance of suspension [m/N]
		mmd		(1,1) double								% Mass of the diaphragm and the voice coil in [kg]
		mmi		(1,1) double								% Mass contributed by the air load on one side of the piston [kg]
		rms		(1,1) double								% Mechanical resistance of the suspension in [Ns/m]
		a		(1,1) double								% Radius of effective area of the diaphragm [m]
		qts		(1,1) double								% Total Q of the driver
	end

	methods
		function obj = driver
			%LSP Constructor method
		end
		
		function val = get.bl(obj)
			%BL

			val = sqrt(obj.re / (2*pi*obj.fs * obj.qes * obj.cms));

		end
		function val = get.cms(obj)
			%CMS

			val = obj.vas / (obj.sd^2 * lspsys.rho * lspsys.c^2);

		end
		function val = get.mmd(obj)
			%MMD

			val = obj.mms - 2*obj.mmi;

		end
		function val = get.mmi(obj)
			%MMI

			val = 2.67 * obj.a^3 * lspsys.rho;

		end
		function val = get.rms(obj)
			%RMS

			val = 1/obj.qms * sqrt(obj.mms/obj.cms);

		end
		function val = get.a(obj)
			%A

			val = sqrt(obj.sd / pi);

		end
		function val = get.qts(obj)
			%QTS

			val = obj.qes * obj.qms / (obj.qes + obj.qms);

		end

		function val = ze(obj,f)
			%ZE Electrical impedance

			% Frequency in [rad/s]:
			w		= 2*pi*f;

			% Electrical impedance [Ohm]:
			val		= obj.re + 1i * w * obj.le;
		end
		function val = zm(obj,f)
			%ZM Mechanical impedance

			% Frequency in [rad/s]:
			w		= 2*pi*f;

			val		= 1i*w*obj.mmd + obj.rms + 1./(1i*w*obj.cms);
		end
		function val = Te(obj,f)
			%TE Electrical transmission matrices

			% Number of frequencies
			nf			= numel(f);

			% Electric impedance:
			ze_int		= obj.ze(f);

			% Transmission matrices:
			val			= repmat([1 0; 0 1],1,1,nf);

			% Add ze_int:
			val(1,2,:)	= ze_int;
		end
		function val = Tbl(obj)
			%TBL Transmission matrix BL

			val			= [0 obj.bl; obj.bl^-1 0];
		end
		function val = Tm(obj,f)
			%TM Transmission matrix for mechanical part

			% Number of frequencies:
			nf			= numel(f);

			% Mechanical impedance:
			zm_int		= obj.zm(f);

			% Transmission matrices:
			val			= repmat([1 0; 0 1],1,1,nf);

			% Add zm_int:
			val(1,2,:)	= zm_int;
		end
		function val = Tsd(obj)
			%TSD Transmission matrix for diaphragm
			
			val = [obj.sd 0; 0 obj.sd^-1];

		end
	end
end