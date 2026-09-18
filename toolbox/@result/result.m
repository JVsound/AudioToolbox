classdef result
	%RESULT Class containing result arrays for the lspsys class
	%calculations.

	properties (SetAccess = ?lspsys)
		Frequency	(1,:)	double			= 0;
		SourceVoltage	(1,:)	double			= 0;
		SourceCurrent	(1,:)	double			= 0;
		DiaphragmVolumeVelocity	(1,:)	double			= 0;
		RadiatedVolumeVelocity	(1,:)	double			= 0;
		RadiationAngle	(1,1)	string			= "2pi";
	end

	properties
		ObservationRadius	(1,1)	double		{mustBePositive}		= 1;	% Radius [m] relative to radiation surface where sound pressure level is calculated.
	end

	properties (Dependent)
		ElectricalImpedance	(1,:)	double
		Pressure	(1,:)	double
		SoundPressureLevel (1,:)	double
	end

	methods
		function obj = result
			%RESULT Object constructor

		end
		function val = get.ElectricalImpedance(obj)
			%ElectricalImpedance Electric impedance of system

			val = obj.SourceVoltage ./ obj.SourceCurrent;

		end
		function val = get.Pressure(obj)
			%Pressure Sound pressure [Pa] at ObservationRadius

			if obj.RadiationAngle == "2pi"

			end



			val = 1;
		end
		function val = get.SoundPressureLevel(obj)
			%SoundPressureLevel Sound pressure level

			val = 1;
		end
	end
end