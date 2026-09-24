classdef (Abstract) Enclosure
	%Enclosure

	properties
		Driver	(1,1) comp.Driver			= comp.Driver;
	end

	methods
		function obj = Enclosure
			%Enclosure
		end

        function val = ta(obj,f,ra)
            %TA Transmission matrix T_a of the acoustical side, 2 x 2 for each frequency
            %   val = ta(obj,f,ra) reduces the 4-ports tae (enclosure) and tarad (radiation) on the front,
            %   reference and rear conductor to the 2-port T_a. Port 1 is the front and rear conductor at the
            %   diaphragm, port 2 the front and rear conductor at the output. Flows count to the right on the
            %   front and to the left on the rear conductor.
            Tae = obj.tae(f,ra);
            Tarad = obj.tarad(f,ra);
            nf = numel(f);
            val = zeros(2,2,nf);

            % Port 2: p_2 = p_f - p_r and U_f = U_r = U_2, with the free pressure p_r: x = P*[p_2; U_2] + q*p_r
            P = [1 0; 0 1; 0 0; 0 1];
            q = [1; 0; 1; 0];
            for i = 1:nf
                M = Tae(:,:,i)*Tarad(:,:,i);

                % Rows 2 and 4 both give U_d, which fixes p_r:
                d = M(2,:) - M(4,:);
                K = P - q*(d*P)/(d*q);

                % Port 1: p_1 = p_f - p_r (rows 1 and 3) and U_d (row 2):
                val(:,:,i) = [M(1,:) - M(3,:); M(2,:)]*K;
            end
        end
	end

	methods (Abstract)
		val = tae(obj,f,ra)
		val = tarad(obj,f,ra)
		val = diaphragm2RadiatedVolumeVelocity(obj,f,ra)
	end

	methods (Static)
		function val	= zarad(rd,w)
            %zarad Radiation impedance
            %
            %   Radiation impedance of a rigid circular piston in an
            %   infinite baffle.

            arguments
                rd  (1,1) double
                w   (1,:) double
            end
            
            % Extract parameters from acoustics package:
            rho     = lspsys.AirDensity;
            c       = lspsys.SpeedOfSound;
            
            % Calculating wave number:
            k       = w/c;
            
            % Calculating Bessel function of the first kind:
            besselJ1  = besselj(1,2*k*rd);
            
            % Calculating Struve function of the first kind:
            struveH1  = comp.Enclosure.struve(2*k*rd);
            
            % Specific radiation resistance:
            rs      = rho * c * (1 - besselJ1 ./ (k*rd));
            
            % Specific radiation reactance:
            xs      = rho * c * (struveH1) ./ (k*rd);
            
            % Specific impedance:
            zs      = rs + 1i * xs;
            
            % Radiation impedance:
            val     = zs / (pi*rd^2);
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