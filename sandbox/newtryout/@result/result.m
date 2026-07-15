classdef result
	%RESULT Class containing result arrays for the lspsys class
	%calculations.

	properties (SetAccess = immutable)
		f	(1,:)	double
		eg	(1,:)	double
		ig	(1,:)	double
		Qd	(1,:)	double
		Qr	(1,:)	double
	end

	methods
		function obj = result(f,eg,ig,Qd,Qr)
			%RESULT Object constructor

			obj.f	= f;
			obj.eg	= eg;
			obj.ig	= ig;
			obj.Qd	= Qd;
			obj.Qr	= Qr;
		end
	end
end