classdef simulation
    %SIMULATION
    %   
    %   2024-03-24, J.G. Vermond
    
    properties (Access = public)
        f       (1,:) double    {mustBeNonnegative}             = 0                     % Frequency array [Hz]
        encl    (1,1)           {mustBeA(encl,["enclosure.closedbox", ...
            "enclosure.bassreflex","enclosure.tappedhorn"])}    = enclosure.closedbox   % Enclosure for this simulation.
        sp      (1,1)           {mustBeA(sp,"speaker.woofer")}  = speaker.woofer        % Speaker for this simulation.
        nsp     (1,1) double    {mustBeInteger,mustBePositive}  = 1;                    % Number of speakers [-]
        eg      (1,1) double                                    = 2.83;                 % Voltage RMS over speaker terminals [V]
        r       (1,1) double    {mustBePositive}                = 1;                    % Microphone distance for SPL calculations [m]
		feai	(1,1) fea.feaimport														% FEA import object.
		plim	(1,1) double	{mustBeNonnegative}				= 0						% Power limit [W] for calculation of maximum SPL [dB]
		xlim	(1,1) double	{mustBeNonnegative}				= 0						% Cone excursion limit [m] for calculation of maximum SPL [dB]
	end
    
    properties (Dependent)
        w				                                                                % Frequency array [rad/s]
        k                                                                               % Wave number [Rad/m]
        ze                                                                              % Electrical impedance [Ohm]
        zm                                                                              % Mechanical impedance [Ns/m]
        za                                                                              % Equivalent acoustic impedance [Ns/m5]
        sim2port                                                                        % Simulation of 2-port network
        spl                                                                             % Sound pressure level at distance r
		splff																			% Sound pressure at the farfield for feai export files
        swl																				% Sound power level of radiating source [dB]
		mspl																			% Maximum sound pressure level [dB] at distance r, limited by plim and xlim.
		pres	
	end

    methods
        function obj = simulation(f)
            %SIMULATION Create an object of this class.
            %   Optional input: frequency vector in [Hz].

            if nargin >= 1
                obj.f       = f;
            else
                obj.f       = logspace(log10(2e1),log10(2e4),1e3);
            end
        end
        function val = get.w(obj)
            %W Frequency in [rad/s]
            val         = obj.f * 2*pi;
        end
        function val = get.k(obj)
            %K Wave number

            val     = obj.w / acoustics.misc.c;
        end
        function val = get.ze(obj)
            %ZE Electrical impedance

            val     = obj.sp.ze(obj.w);
        end
        function val = get.zm(obj)
            %ZM Mechanical impedance

            val     = obj.sp.zm(obj.w);
        end
        function val = get.za(obj)
            %ZA Acoustical impedance

            % Check type of enclosure:
            if isa(obj.encl,"enclosure.closedbox")
                % The enclosure is a closed box.

                % The acoustic impedance is a combination of the front and
                % rear side of the speaker:
                %
                % zafront
                % zarear

                % Acoustic impedance front radiation:
                zafront     = acoustics.impedance.zarad(obj.sp.a,obj.w);

                % Acoustic impedance rear:
                zarear      = obj.encl.zarear(obj.w);

                % Combine:
                val.front	= zafront;
				val.rear	= zarear;

            elseif isa(obj.encl,"enclosure.bassreflex")
                % The enclosure is a bass reflex.

			end

        end
        function val = get.sim2port(obj)
            %SIM2PORT Simulation of 2-port network

            % Frequency properties:
            nf      = numel(obj.w);

            % Check type of enclosure:
            if isa(obj.encl,"enclosure.closedbox")
                % The enclosure is a closed box.

                % T     = T1 * T2 * T3 * T4 * T5
                %
                % T1:   Electrical - Function of w
                % T2:   Gyrator
                % T3:   Mechanical - Function of w
                % T4:   Transformer
                % T5:   Acoustical - Function of w
				% T6:	Acoustical - Function of w

				% Acoustic impedance
				%
				% If there are file locations available in the fea import
				% object, this data is used.
				%
				
				% Check if acoustic impedance from FEA is available:

				% Front of diaphragm:
				if obj.feai.fnamediaphragmf == ""
					% The acoustic impedance calculated by the toolbox is
					% used.

					zafront		= obj.za.front;

				else
					% Acoustic impedance FEA results available.

					zafront		= obj.feai.zafront;

				end

				% Rear of diaphragm:
				if obj.feai.fnamediaphragmr == ""
					% The acoustic impedance calculated by the toolbox is
					% used.

					zarear		= obj.za.rear;

				else
					% Acoustic impedance FEA results available.

					zarear		= obj.feai.zarear;

				end

                % Allocate T:
                T       = zeros(2,2,nf);
     
                % Matrices which are not a function of frequency:
                T2      = [ 0               obj.sp.bl; ...
                            obj.sp.bl^-1    0];
                T4      = [ obj.sp.sd       0; ...
                            0               obj.sp.sd^-1];

                % Matrices which are a function of frequency:
                T1          = zeros(2,2,nf);

                T1(1,1,:)   = ones(1,nf);
                T1(2,2,:)   = ones(1,nf);
                T1(1,2,:)   = obj.ze;

                T3          = zeros(2,2,nf);

                T3(1,1,:)   = ones(1,nf);
                T3(2,2,:)   = ones(1,nf);
                T3(1,2,:)   = obj.zm;

                T5          = zeros(2,2,nf);

                T5(1,1,:)   = ones(1,nf);
                T5(2,2,:)   = ones(1,nf);
				T5(1,2,:)	= zafront;
                
                T6          = zeros(2,2,nf);

                T6(1,1,:)   = ones(1,nf);
                T6(2,2,:)   = ones(1,nf);
				T6(2,1,:)	= zarear.^-1;


                for i = 1:nf
                    T(:,:,i)    = T1(:,:,i) * T2 * T3(:,:,i) * T4 * ...
                        T5(:,:,i) * T6(:,:,i);
                end

                % Pressure over diaphragm:
                p6          = obj.eg ./ squeeze(T(1,1,:)).';

                % Volume velocity through radiation impedance:
                q           = p6 ./ ...
                    zarear;

				% Complex acoustic power:
				pa			= p6 .* conj(q);

				% Diaphragm velocity:
				xdot		= q / obj.sp.sd;

				% Diaphragm position:
				x			= xdot ./ (1i * obj.w);

				% input impedance
				zetot		= squeeze(T(1,1,:)).' ./ squeeze(T(2,1,:)).';

            elseif isa(obj.encl,"enclosure.bassreflex")
                % The enclosure is a bass reflex box

                % T     = T1 * T2 * T3 * T4 * T5
                %
                % T1:   Electrical - Function of w
                % T2:   Gyrator
                % T3:   Mechanical - Function of w
                % T4:   Transformer
                % T5:   Acoustical - Function of w
				% T6:	Acoustical - Function of w

                % Allocate T:
                T       = zeros(2,2,nf);
     
                % Matrices which are not a function of frequency:
                T2      = [ 0               obj.sp.bl; ...
                            obj.sp.bl^-1    0];
                T4      = [ obj.sp.sd       0; ...
                            0               obj.sp.sd^-1];

                % Matrices which are a function of frequency:
                T1          = zeros(2,2,nf);

                T1(1,1,:)   = ones(1,nf);
                T1(2,2,:)   = ones(1,nf);
                T1(1,2,:)   = obj.ze;

                T3          = zeros(2,2,nf);

                T3(1,1,:)   = ones(1,nf);
                T3(2,2,:)   = ones(1,nf);
                T3(1,2,:)   = obj.zm;

                T5          = zeros(2,2,nf);

                T5(1,1,:)   = ones(1,nf);
                T5(2,2,:)   = ones(1,nf);
                T5(1,2,:)   = obj.feai.zafront;
                
                T6          = zeros(2,2,nf);

                T6(1,1,:)   = ones(1,nf);
                T6(2,2,:)   = ones(1,nf);
                T6(2,1,:)   = obj.feai.zarear.^-1;

                for i = 1:nf
                    T(:,:,i)    = T1(:,:,i) * T2 * T3(:,:,i) * T4 * ...
                        T5(:,:,i) * T6(:,:,i);
                end

                % Pressure over diaphragm:
                p6          = obj.eg ./ squeeze(T(1,1,:))';

                % Volume velocity through rear acoustic impedance:
                q           = p6 ./ ...
                    obj.feai.zarear;

				% Diaphragm velocity:
				xdot		= q / obj.sp.sd;

				% Diaphragm position:
				x			= xdot ./ (1i * obj.w);

				% input impedance
				zetot		= squeeze(T(1,1,:)).' ./ squeeze(T(2,1,:)).';

            end

            val.pg		= p6;
            val.q		= q;
			val.pa		= pa;
			val.xdot	= xdot;
			val.x		= x;
			val.zetot	= zetot;

			% Calculate complex current [A]:
			val.ig		= obj.eg ./ val.zetot;

			% Calculate complex power [W]:
			val.Sg		= obj.eg .* conj(val.ig);

     
		end
        function val = get.spl(obj)
            %SPL Sound Pressure Level in [dB]

            % sim2port method:
            s2p     = obj.sim2port;

			% Check type of enclosure:
            if isa(obj.encl,"enclosure.closedbox")
                % The enclosure is a closed box.

				% Cone velocity to sound pressure relation
				%
				% If there is a FEA result file present in the feai object,
				% this file is used to calculate the sound pressure as
				% function of the cone velocity.

				if obj.feai.fnamexdottopres == ""
					% No result file present. Calculate sound pressure
					% according to toolbox equations:

					% Sound pressure in [Pa] at distance r [m]:
					pr      = 1i * obj.f .* acoustics.misc.rho0 .* ...
						s2p.q .* exp(-1i * obj.k * obj.r) / obj.r;

				else 
					% A result file is present, and the sound pressure is
					% calculated using the cone velocity xdot.

					% Sound pressure:
					pr		= obj.feai.xdot2pres .* s2p.xdot;
				end

            elseif isa(obj.encl,"enclosure.bassreflex")
                % The enclosure is a bass reflex box

				% Convert diaphragm velocity to pressure at microphone
				% position:

				pr		= obj.feai.xdot2pres .* s2p.xdot';

		    end

			val     = 20 * log10(abs(pr) / acoustics.misc.pref);

        end
		function val = get.splff(obj)
			%SPLFF Sound Pressure Level at the Far-field

			% sim2port method:
            s2p     = obj.sim2port;

			% Check if there is file present for pressure at the Far-field:

			if obj.feai.fnamexdottopres == ""
					% No result file present. 

					disp("No result file present for Far field pressure calculation");

				else 
					% A result file is present, and the sound pressure is
					% calculated using the cone velocity xdot.

					% Sound pressure [Pa]:
					pr		= obj.feai.xdot2presff .* s2p.xdot;

					% Sound pressure [dB]:
					val     = 20 * log10(abs(pr) / acoustics.misc.pref);
			end
		end
		function val = get.swl(obj)
			%SWL Sound Power Level

			% Wref = 2pi r^2 pref^2 / (rho*c) with (r = 1)

			wref	= 2*pi*obj.r^2 * acoustics.misc.pref^2 / (acoustics.misc.rho0 * acoustics.misc.c);

			% Get complex acoustic power:
			pa		= obj.sim2port.pa;

			% Acoustic power in [dB]:
			val		= 10*log10(real(pa)/wref);
		end
		function val = get.mspl(obj)
			%MSPL Maximum sound pressure level [dB]
			%Limited by plim and xlim.

			% sim2port method:
            s2p     = obj.sim2port;

			% Check type of enclosure:
            if isa(obj.encl,"enclosure.closedbox")
                % The enclosure is a closed box.

				% Cone velocity to sound pressure relation
				%
				% If there is a FEA result file present in the feai object,
				% this file is used to calculate the sound pressure as
				% function of the cone velocity.

				if obj.feai.fnamexdottopres == ""
					% No result file present. Calculate sound pressure
					% according to toolbox equations:

					% Sound pressure in [Pa] at distance r [m]:
					pr      = 1i * obj.f .* acoustics.misc.rho0 .* ...
						s2p.q .* exp(-1i * obj.k * obj.r) / obj.r;
				else 
					% A result file is present, and the sound pressure is
					% calculated using the cone velocity xdot.

					% Sound pressure:
					pr		= obj.feai.xdot2pres .* s2p.xdot;
				end

            elseif isa(obj.encl,"enclosure.bassreflex")
                % The enclosure is a bass reflex box

				% Convert diaphragm velocity to pressure at microphone
				% position:

				pr		= obj.feai.xdot2pres .* s2p.xdot';

		    end

			prxlim	= pr .* s2p.vmxlim;
			prplim	= pr .* s2p.vmplim;

			[pr,idx]	= min([prxlim; prplim],[],1);

			val.spl     = 20 * log10(abs(pr) / acoustics.misc.pref);
			val.idx		= idx;

		end
		function val = get.pres(obj)
			%PRES Pressure at microphone position in [Pa]

			            % sim2port method:
            s2p     = obj.sim2port;

			% Check type of enclosure:
            if isa(obj.encl,"enclosure.closedbox")
                % The enclosure is a closed box.

				% Cone velocity to sound pressure relation
				%
				% If there is a FEA result file present in the feai object,
				% this file is used to calculate the sound pressure as
				% function of the cone velocity.

				if obj.feai.fnamexdottopres == ""
					% No result file present. Calculate sound pressure
					% according to toolbox equations:

					% Sound pressure in [Pa] at distance r [m]:
					pr      = 1i * obj.f .* acoustics.misc.rho0 .* ...
						s2p.q .* exp(-1i * obj.k * obj.r) / obj.r;

				else 
					% A result file is present, and the sound pressure is
					% calculated using the cone velocity xdot.

					% Sound pressure:
					pr		= obj.feai.xdot2pres .* s2p.xdot;
				end

            elseif isa(obj.encl,"enclosure.bassreflex")
                % The enclosure is a bass reflex box

				% Convert diaphragm velocity to pressure at microphone
				% position:

				pr		= obj.feai.xdot2pres .* s2p.xdot';

			end

			val = pr;
		end
	end
end