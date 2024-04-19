classdef simulation
    %SIMULATION
    %   
    %   2024-03-24, J.G. Vermond
    
    properties (Access = public)
        f       (:,1) double    {mustBeNonnegative}             = 0                     % Frequency array [Hz]
        encl    (1,1)           {mustBeA(encl,["enclosure.closedbox", ...
            "enclosure.bassreflex","enclosure.tappedhorn"])}    = enclosure.closedbox   % Enclosure for this simulation.
        sp      (1,1)           {mustBeA(sp,"speaker.woofer")}  = speaker.woofer        % Speaker for this simulation.
        nsp     (1,1) double    {mustBeInteger,mustBePositive}  = 1;                    % Number of speakers
    end
    
    properties (Dependent)
        w                                                                               % Frequency array [rad/s]
        za                                                                              % Equivalent acoustic impedance [Ns/m5]
        sim2port                                                                        % Simulation of 2-port network 
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
        function val = get.encl(obj)
            obj.encl.f      = obj.f;
            val             = obj.encl;
        end
        function val = get.w(obj)
            %W Frequency in [rad/s]
            val         = obj.f * 2*pi;
        end
        function val = get.za(obj)
            %ZA

            val = obj.nsp;
        end
        function val = get.sim2port(obj)
            %SIM2PORT Simulation of 2-port network

            val = 1;
        end
    end

end