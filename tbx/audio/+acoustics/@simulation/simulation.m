classdef simulation
    %SIMULATION
    %   
    %   2024-03-24, J.G. Vermond
    
    properties (Access = public)
        f       (:,1) double    {mustBeNonnegative}             = 0                     % Frequency array [Hz]
        encl    (1,1)           {mustBeA(encl,["enclosure.closedbox", ...
            "enclosure.bassreflex","enclosure.tappedhorn"])}    = enclosure.closedbox;  % Enclosure for this simulation.
    end
    
    properties (Dependent)
        w                                                                               % Frequency array [rad/s]
    end

    properties (Access=private,Hidden)
        fint
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
        function val = get.f(obj)
            val = obj.fint;
        end
        function obj = set.f(obj,val)
            %F
            %
            %   If the frequency property of the simulation object is
            %   changed, it must also be entered for all underlying object
            %   like the enclosures. This is done by the seperate "setf"
            %   method.

            obj     = setfint(obj,val);
        end
        function obj = set.encl(obj,val)
            %ENCL Set function for encl property
            %   If an enclosure property is loaded, it has to take over the
            %   frequency vector of the simulation object.

            obj.encl    = val;
        end
        function val = get.encl(obj)
            obj.encl.f      = obj.f;
            val             = obj.encl;
        end
        function val = get.w(obj)
            %W Frequency in [rad/s]
            val         = obj.f * 2*pi;
        end
    end

    methods (Access=protected,Hidden)
        function obj = setfint(obj,val)
            obj.fint        = val;
            obj.encl.f      = val;
        end
    end

end