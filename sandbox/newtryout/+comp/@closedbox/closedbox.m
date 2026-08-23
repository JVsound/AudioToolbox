classdef closedbox < comp.enclosure
	%CLOSEDBOX

	properties
		vr		(1,1) double {mustBePositive}	= 10e-3;	% Volume of rear chamber in [m3]
	end

	methods
		function obj = closedbox
			%CLOSEDBOX
		end
		function val = zaf(obj,f,ra)
			%ZAF Acoustic impedance - front of diaphragm

			% We only use radiation from a rigid piston in an infinite
			% baffle for now.

			% Radius of driver:
			a	= obj.driver.a;

			% Frequency in [rad/s]:
			w	= 2*pi*f;

			% Radiation impedance:
			val = comp.enclosure.zarad(a,w);

		end
		function val = zar(obj,f,ra)
			%ZAR Acoustic impedance - rear of diaphragm

			% Acoustic compliance [m5/N]:
			Ca		= obj.vr / (lspsys.rho * lspsys.c^2);

			% Acoustic impedance:
			val		= 1 ./ (1i*2*pi*f*Ca);

		end
		function val = Taf(obj,f,ra)
			%TAF Transmission matrix - acoustic. Front side of diaphragm.

			% Number of frequencies:
			nf			= numel(f);

			% Impedance:
			zaf_int		= obj.zaf(f,ra);

			% Transmission matrices:
			val			= repmat([1 0; 0 1],1,1,nf);

			% Insert zaf:
			val(1,2,:)	= zaf_int;

		end
		function val = Tar(obj,f,ra)
			%TAR Transmission matrix - acoustic. Rear of diaphragm.

			% Number of frequencies:
			nf			= numel(f);

			% Impedance:
			zar_int		= obj.zar(f,ra);

			% Transmission matrices:
			val			= repmat([1 0; 0 1],1,1,nf);

			% Insert zar:
			val(2,1,:)	= zar_int.^-1;

		end
		function val = Qd2Qr(obj,f,ra)
			%QD2QR

			% For a closed box Qd = Qr:
			val = ones(size(f));

		end
	end
end