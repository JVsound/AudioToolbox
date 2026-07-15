classdef lspsys
	%LSPSYS Loudspeaker system object

	properties
		f			(1,:)	double {mustBePositive}									= logspace(log10(2e1),log10(2e4),1e3);
		eg			(1,1)	double {mustBePositive}									= 2.83;
		ra			(1,1)	string {mustBeMember(ra,["4pi","2pi","pi","pi/2"])}		= "2pi";
		enclosure	(1,1)	comp.enclosure											= comp.closedbox
	end

	properties (Dependent, Hidden)
		w
		k
		lambda
	end

	properties (Dependent, Access = private)
		Te
		Tbl
		Tm
		Tsd
		Taf
		Tar
	end

	properties (Constant)
		c		= 343;		% Speed of sound [m/s], at 20deg C. Source: Wikipedia
		rho		= 1.225;	% Density of air [kg/m3] at sea level, at 20deg C. Source: Wikpedia
		pref	= 20e-6		% Reference pressure [Pa] for sound pressure level calculations
	end

	methods
		function obj = lspsys
			%LSPSYS
		end
		
		function val = get.w(obj)
			%W Frequency in [rad/s]
			
			val = obj.f * 2*pi;
		end
		function val = get.k(obj)
			%K Wave number

			val = lspsys.f2k(obj.f);
		end
		function val = get.lambda(obj)
			%LAMBDA Wave length

			val = lspsys.f2lambda(obj.f);
		end
		
		function val = get.Te(obj)

		end
		function val = get.Tbl(obj)

		end
		function val = get.Tm(obj)

		end
		function val = get.Tsd(obj)

		end
		function val = get.Taf(obj)

		end
		function val = get.Tar(obj)

		end

		function val = buildtmem(obj)
			%TMEM
			val = 1;
		end
		function val = buildtma(obj)
			%TMA Vraag transmission matrices op, met behulp van radang:

			tmaint = obj.enclosure.tma(obj.ra);

			val = 1;
		end
		function val = solve2portnetwork(obj)
			%SOLVE2PORTNETWORK

			% We need: Te, Tbl, Tm, Tsd, Taf, Tar
			Te		= obj.enclosure.driver.Te(obj.f);
			Tbl		= obj.enclosure.driver.Tbl(obj.f);
			Tm		= obj.enclosure.driver.Tm(obj.f);
			Tsd		= obj.enclosure.driver.Tsd(obj.f);
			Taf		= obj.enclosure.Taf(obj.f,obj.ra);
			Tar		= obj.enclosure.Tar(obj.f,obj.ra);


			val		= 1;
		end
		function val = result(obj)
			%RESULT

			% Solve 2-port network:
			s2p		= obj.solve2portnetwork;


			% object containing all the results:
			val		= result(obj.f,obj.eg,ig,Qd,Qr);
		end
	end

	methods (Static)
		function val = f2lambda(f)
			%F2LAMBDA

			val = lspsys.c ./ f;
		end
		function val = f2k(f)
			%F2K Frequency to wave number

			val = 2*pi*f / lspsys.c;
		end
	end
end