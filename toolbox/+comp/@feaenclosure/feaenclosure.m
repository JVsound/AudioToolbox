classdef feaenclosure < comp.enclosure
	%FEAENCLOSURE

	properties
		driver				(1,1)	comp.driver		= comp.driver	% Driver in enclosure
		v					(1,:)	double			= 0				% Complex velocity applied at FEA diaphragm [m/s]
		pfrontfilename		(1,1)	string			= ""			% File name for front-side pressure results
		prearfilename		(1,1)	string			= ""			% File name for rear-side pressure results
		pfarfieldfilename	(1,1)	string			= ""			% File name for pressure results at far-field
	end

	properties (Dependent)
		Q															% Volume velocity [m3/s]
	end

	methods
		function obj = feaenclosure
			%FEAENCLOSURE
		end
		function val = get.Q(obj)
			%Q Volume velocity [m3/s]

			val = obj.v * obj.driver.sd;

		end
		function val = Zaf(obj,f,ra)
		end
		function val = Zar(obj,f,ra)
		end
		function val = Taf(obj,f,ra)
		end
		function val = Tar(obj,f,ra)
		end
		function val = Qd2Qr(obj,f,ra)
		end
	end

	methods (Static)
		function val = importansyspressureresults(filename)
			%IMPORTANSYSPRESSURERESULTS

			
		end
	end
end