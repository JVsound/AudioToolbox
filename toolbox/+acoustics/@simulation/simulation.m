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
        eg      (1,1) double                                    = 2.83;                 % Voltage over speaker terminals [V]
        r       (1,1) double    {mustBePositive}                = 1;                    % Microphone distance for SPL calculations [m]
		feai	(1,1) fea.feaimport														% FEA import object.
    end
    
    properties (Dependent)
        w				                                                                % Frequency array [rad/s]
        k                                                                               % Wave number [Rad/m]
        ze                                                                              % Electrical impedance [Ohm]
        zm                                                                              % Mechanical impedance [Ns/m]
        za                                                                              % Equivalent acoustic impedance [Ns/m5]
        sim2port                                                                        % Simulation of 2-port network
        spl                                                                             % Sound pressure level at distance r
        inpimp                                                                          % Input impedance of system [Ohm]
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

				if obj.feai.fnamediaphragmf == "" || ...
						obj.feai.fnamediaphragmr == ""
					% No acoustic impedance FEA results files available.
					% The acoustic impedance calculated by the toolbox is
					% used.
					
					zarear		= obj.za.rear;
					zafront		= obj.za.front;

				else
					% Acoustic impedance FEA results available.

					zarear		= obj.feai.zarear;
					% zarear		= real(obj.feai.zarear) - 1i * imag(obj.feai.zarear);
					% zafront		= obj.feai.zafront;
					zafront		= real(obj.feai.zafront) - 1i * imag(obj.feai.zafront);

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
                % T5(1,2,:)   = acoustics.impedance.zarad(obj.sp.a,obj.w);
                
                T6          = zeros(2,2,nf);

                T6(1,1,:)   = ones(1,nf);
                T6(2,2,:)   = ones(1,nf);
				T6(2,1,:)	= zarear.^-1;
                % T6(2,1,:)   = obj.encl.zarear(obj.w).^-1;

                for i = 1:nf
                    T(:,:,i)    = T1(:,:,i) * T2 * T3(:,:,i) * T4 * ...
                        T5(:,:,i) * T6(:,:,i);
                end

                % Pressure over diaphragm:
                p6          = obj.eg ./ squeeze(T(1,1,:))';

                % Volume velocity through radiation impedance:
                q           = p6 ./ ...
                    zarear;

				% Diaphragm velocity:
				xdot		= q / obj.sp.sd;

				% Diaphragm position:
				x			= xdot ./ (1i * obj.w);

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

            end

            val.pg		= p6;
            val.q		= q;
			val.xdot	= xdot;
			val.x		= x;

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
    end
end