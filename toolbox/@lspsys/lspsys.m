classdef lspsys
	%LSPSYS Loudspeaker system object

	properties (Access = public)
		Frequency			(1,:)	double {mustBePositive}				= logspace(log10(2e1),log10(2e4),1e3);
		SourceVoltage			(1,1)	double {mustBePositive}				= 2.83;
		RadiationAngle			(1,1)	string {mustBeMember(RadiationAngle,"2pi")}		= "2pi";
		Enclosure	(1,1)	comp.Enclosure						= comp.ClosedBox
	end

	properties (Dependent, Hidden)
		AngularFrequency
		WaveNumber
		Wavelength
		NumFrequencies
	end

	properties (Constant, Hidden)
		SpeedOfSound		= 343;		% Speed of sound [m/s], at 20deg C. Source: Wikipedia
		AirDensity		= 1.225;	% Density of air [kg/m3] at sea level, at 20deg C. Source: Wikpedia
		ReferencePressure	= 20e-6		% Reference pressure [Pa] for sound pressure level calculations
	end

	methods
		function obj = lspsys
			%LSPSYS
		end
		
		function val = get.AngularFrequency(obj)
			%AngularFrequency Frequency in [rad/s]
			
			val = obj.Frequency * 2*pi;
		end
		function val = get.WaveNumber(obj)
			%WaveNumber Wave number

			val = lspsys.f2k(obj.Frequency);
		end
		function val = get.Wavelength(obj)
			%Wavelength Wave length

			val = lspsys.f2Lambda(obj.Frequency);
		end
		function val = get.NumFrequencies(obj)
			%NumFrequencies Number of frequencies

			val = numel(obj.Frequency);

		end

		function val = solve2PortNetwork(obj)
			%solve2PortNetwork

			% We need: Te, Tbl, Tm, Tsd, Taf, Tar
			Te		= obj.Enclosure.Driver.te(obj.Frequency);
			Tbl		= obj.Enclosure.Driver.tbl;
			Tm		= obj.Enclosure.Driver.tm(obj.Frequency);
			Tsd		= obj.Enclosure.Driver.tsd;
			Taf		= obj.Enclosure.taf(obj.Frequency,obj.RadiationAngle);
			Tar		= obj.Enclosure.tar(obj.Frequency,obj.RadiationAngle);

			% 
			Tbl		= repmat(Tbl,1,1,obj.NumFrequencies);
			Tsd		= repmat(Tsd,1,1,obj.NumFrequencies);

			% Allocate Qd and ig:
			Qd		= zeros(1,obj.NumFrequencies);
			ig		= zeros(1,obj.NumFrequencies);

			for i = 1:obj.NumFrequencies
				% Complete 2-port transmission matrix:
				T		= Te(:,:,i) * Tbl(:,:,i) * Tm(:,:,i) * ...
					Tsd(:,:,i) * Taf(:,:,i) * Tar(:,:,i);

				% Diaphragm volume velocity:
				Qd(i)	= obj.SourceVoltage / T(1,2);

				% Electric current:
				ig(i)	= T(2,2) * Qd(i);
			end

			val.DiaphragmVolumeVelocity	= Qd;
			val.SourceCurrent	= ig;
			
		end
		function val = createResult(obj)
			%createResult

			% Solve 2-port network:
			s2p		= obj.solve2PortNetwork;

			Qr		= obj.Enclosure.qd2Qr(obj.Frequency);

			% Initiate object for results collection:
			val		= result;

			% Assign results
			val.Frequency	= obj.Frequency;
			val.SourceVoltage	= ones(1,obj.NumFrequencies,1) * obj.SourceVoltage;
			val.DiaphragmVolumeVelocity	= s2p.DiaphragmVolumeVelocity;
			val.RadiatedVolumeVelocity	= s2p.DiaphragmVolumeVelocity .* Qr;
			val.SourceCurrent	= s2p.SourceCurrent;
		end
	end

	methods (Static)
		function val = f2Lambda(f)
			%f2Lambda

			val = lspsys.SpeedOfSound ./ f;
		end
		function val = f2k(f)
			%f2k Frequency to wave number

			val = 2*pi*f / lspsys.SpeedOfSound;
		end
	end
end