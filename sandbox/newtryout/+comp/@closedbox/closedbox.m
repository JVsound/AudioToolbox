classdef closedbox < comp.enclosure
	%CLOSEDBOX Summary of this class goes here
	%   Detailed explanation goes here

	properties
		vr		(1,1) double {mustBePositive}	= 10e-3;	% Volume of rear chamber in [m3]
	end

	methods
		function obj = closedbox
			%CLOSEDBOX
		end
		function val = buildtma(obj,f,ra)
			%BUILDTMA Build transmission matrices acoustical
			
			val = 1;
		end
		function val = zavr(obj,f)
			val = 1;
		end
		function val = zarad(obj,f,ra)
			val = 1;
		end
		function val = zaf(obj,f)

		end
		function val = zar(obj,f)

		end
	end
end