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
		val = buildtma(obj,f,ra)
		val = rQdQr(obj,f,ra)
	end
end