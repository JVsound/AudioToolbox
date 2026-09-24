classdef ClosedBox < comp.Enclosure
	%ClosedBox

	properties
		RearVolume		(1,1) double {mustBePositive}	= 10e-3;	% Volume of rear chamber in [m3]
	end

	methods
		function obj = ClosedBox
			%ClosedBox
		end
		function val = zaradf(obj,f,ra)
			%ZARADF Radiation impedance Z_a,rad,f at the front of the diaphragm in [Pa.s/m3]

			% We only use radiation from a rigid piston in an infinite
			% baffle for now.

			if ra == "2pi"

				% Radius of driver:
				rd	= obj.Driver.DiaphragmRadius;

				% Frequency in [rad/s]:
				w	= 2*pi*f;

				% Radiation impedance:
				val = comp.Enclosure.zarad(rd,w);

			end
		end
		function val = zacbr(obj,f,~)
			%ZACBR Impedance Z_a,cb,r of the closed volume at the rear of the diaphragm in [Pa.s/m3]

			% Acoustic compliance C_a,cb,r in [m5/N]:
			Cacbr	= obj.RearVolume / (lspsys.AirDensity * lspsys.SpeedOfSound^2);

			% Acoustic impedance:
			val		= 1 ./ (1i*2*pi*f*Cacbr);

		end
		function val = tae(obj,f,~)
			%TAE Transmission matrix T_a,e of the enclosure, 4 x 4 for each frequency
			%   The closed volume at the rear, with the impedance zacbr, is a shunt between the rear conductor
			%   and the reference; the front conductor passes through. The rear flows count to the left.

			% Number of frequencies:
			nf			= numel(f);

			% Transmission matrices, with the shunt of the closed volume on the rear conductor:
			val			= repmat(eye(4),1,1,nf);
			val(4,3,:)	= -1./obj.zacbr(f);

		end
		function val = tarad(obj,f,ra)
			%TARAD Transmission matrix T_a,rad of the radiation, 4 x 4 for each frequency
			%   The radiation impedance zaradf of the front of the diaphragm is a shunt between the front
			%   conductor and the reference; the rear does not radiate and passes through.

			% Number of frequencies:
			nf			= numel(f);

			% Transmission matrices, with the shunt of the radiation impedance on the front conductor:
			val			= repmat(eye(4),1,1,nf);
			val(2,1,:)	= 1./obj.zaradf(f,ra);

		end
		function val = diaphragm2RadiatedVolumeVelocity(~,f,~)
			%DIAPHRAGM2RADIATEDVOLUMEVELOCITY Ratio of the radiated to the diaphragm volume velocity

			% For a closed box Ud = Ur:
			val = ones(size(f));

		end
	end
end