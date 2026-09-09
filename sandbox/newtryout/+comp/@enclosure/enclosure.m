classdef (Abstract) enclosure
	%ENCLOSURE

	properties
		driver	(1,1) comp.driver			= comp.driver;
	end

	methods
		function obj = enclosure
			%ENCLOSURE
		end
	end

	methods (Abstract)
		val = Zaf(obj,f,ra)
		val = Zar(obj,f,ra)
		val = Taf(obj,f,ra)
		val = Tar(obj,f,ra)
		val = Qd2Qr(obj,f,ra)
	end

	methods (Static)
		function val	= Zarad(a,w)
            %ZARAD Radiation impedance
            %
            %   Radiation impedance of a rigid circular piston in an
            %   infinite baffle.

            arguments
                a   (1,1) double
                w   (1,:) double
            end
            
            % Extract parameters from acoustics package:
            rho     = lspsys.rho;
            c       = lspsys.c;
            
            % Calculating wave number:
            k       = w/c;
            
            % Calculating Bessel function of the first kind:
            J1_2ka  = besselj(1,2*k*a);
            
            % Calculating Struve function of the first kind:
            H1_2ka  = comp.enclosure.struve(2*k*a);
            
            % Specific radiation resistance:
            rs      = rho * c * (1 - J1_2ka ./ (k*a));
            
            % Specific radiation reactance:
            xs      = rho * c * (H1_2ka) ./ (k*a);
            
            % Specific impedance:
            zs      = rs + 1i * xs;
            
            % Radiation impedance:
            val     = zs / (pi*a^2);
		end
		function val    = struve(x)
            %STRUVE Struve function of the first kind.
            %
            %   Source: "Approximation of the Struve function H1 occurring
            %   in impedance calculations", by "Ronald M. Aarts and
            %   Augustus J.E.M. Janssen.

            H1      = 2/pi - besselj(0,x) + ...
                (16/pi - 5) * sin(x) ./ x + ...
                (12 - 36/pi) * (1 - cos(x)) ./ x.^2;

            val     = H1;
		end
	end
end