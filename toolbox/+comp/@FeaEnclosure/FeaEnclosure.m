classdef FeaEnclosure < comp.Enclosure
	%FeaEnclosure

	properties
		DiaphragmVelocity					(1,:)	double			= 0				% Complex velocity applied at FEA diaphragm [m/s]
		PressureFrontFileName		(1,1)	string			= ""			% File name for front-side pressure results
		PressureRearFileName		(1,1)	string			= ""			% File name for rear-side pressure results
		PressureFarFieldFileName	(1,1)	string			= ""			% File name for pressure results at far-field
	end

	properties (Dependent)
		VolumeVelocity															% Volume velocity [m3/s]
	end

	methods
		function obj = FeaEnclosure
			%FeaEnclosure
		end
		function val = get.VolumeVelocity(obj)
			%VolumeVelocity Volume velocity [m3/s]

			val = obj.DiaphragmVelocity * obj.Driver.Sd;

		end
		function val = tae(obj,f,ra)
		end
		function val = tarad(obj,f,ra)
		end
		function val = diaphragm2RadiatedVolumeVelocity(obj,f,ra)
		end
	end

	methods (Static)
		function val = importAnsysPressureResults(filename)
			%importAnsysPressureResults

			
		end
	end
end