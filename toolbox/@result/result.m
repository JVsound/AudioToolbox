classdef result
	%RESULT Class containing result arrays for the lspsys class
	%calculations.

	properties (SetAccess = ?lspsys)
		f	(1,:)	double			= 0;
		eg	(1,:)	double			= 0;
		ig	(1,:)	double			= 0;
		Qd	(1,:)	double			= 0;
		Qr	(1,:)	double			= 0;
		ra	(1,1)	string			= "2pi";
	end

	properties
		r	(1,1)	double		{mustBePositive}		= 1;	% Radius [m] relative to radiation surface where sound pressure level is calculated.
	end

	properties (Dependent)
		Ze	(1,:)	double
		pr	(1,:)	double
		spl (1,:)	double
	end

	methods
		function obj = result
			%RESULT Object constructor

		end
		function val = get.Ze(obj)
			%ZE Electric impedance of system

			val = obj.eg ./ obj.ig;

		end
		function val = get.pr(obj)
			%PR Pressure [Pa] at r

			if obj.ra == "2pi"

			end



			val = 1;
		end
		function val = get.spl(obj)
			%SPL Sound pressure level

			val = 1;
		end
	end
end