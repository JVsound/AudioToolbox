classdef lspsys
	%LSPSYS Loudspeaker system object

	properties
		f			(1,:)	double {mustBePositive}									= logspace(log10(2e1),log10(2e4),1e3);
		eg			(1,1)	double {mustBePositive}									= 2.83;
		ra			(1,1)	string {mustBeMember(ra,"2pi")}							= "2pi";
		enclosure	(1,1)	comp.enclosure											= comp.closedbox
	end

	properties (Dependent, Hidden)
		w
		k
		lambda
		nf
	end

	properties (Constant, Hidden)
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
		function val = get.nf(obj)
			%NF Number of frequencies

			val = numel(obj.f);

		end

		function val = solve2portnetwork(obj)
			%SOLVE2PORTNETWORK

			% We need: Te, Tbl, Tm, Tsd, Taf, Tar
			Te		= obj.enclosure.driver.Te(obj.f);
			Tbl		= obj.enclosure.driver.Tbl;
			Tm		= obj.enclosure.driver.Tm(obj.f);
			Tsd		= obj.enclosure.driver.Tsd;
			Taf		= obj.enclosure.Taf(obj.f,obj.ra);
			Tar		= obj.enclosure.Tar(obj.f,obj.ra);

			% 
			Tbl		= repmat(Tbl,1,1,obj.nf);
			Tsd		= repmat(Tsd,1,1,obj.nf);

			% Allocate Qd and ig:
			Qd		= zeros(1,obj.nf);
			ig		= zeros(1,obj.nf);

			for i = 1:obj.nf
				% Complete 2-port transmission matrix:
				T		= Te(:,:,i) * Tbl(:,:,i) * Tm(:,:,i) * ...
					Tsd(:,:,i) * Taf(:,:,i) * Tar(:,:,i);

				% Diaphragm volume velocity:
				Qd(i)	= obj.eg / T(1,2);

				% Electric current:
				ig(i)	= T(2,2) * Qd(i);
			end

			val.Qd	= Qd;
			val.ig	= ig;
			
		end
		function val = result(obj)
			%RESULT

			% Solve 2-port network:
			s2p		= obj.solve2portnetwork;

			Qr		= obj.enclosure.Qd2Qr(obj.f);

			% Initiate object for results collection:
			val		= result;

			% Assign results
			val.f	= obj.f;
			val.eg	= ones(1,obj.nf,1) * obj.eg;
			val.Qd	= s2p.Qd;
			val.Qr	= s2p.Qd .* Qr;
			val.ig	= s2p.ig;
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