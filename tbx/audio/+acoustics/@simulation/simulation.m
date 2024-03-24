classdef simulation
    %SIMULATION
    %   
    %   2024-03-24, J.G. Vermond
    
    properties (Access = public)
        f   (1,:) mustBeNonnegative {}                  = logspace(1,3,1e2)     % Frequency array [Hz]
    end
    
    properties (Dependent)
        w                                                                       % Frequency array [rad/s]
    end

    methods
        function obj = simulation(vargin)
            %SIMULATION

            if nargin >= 1
                obj.f       = vargin;
            end
        end
        function val = get.w(obj)
            %W Frequency in [rad/s]
            val         = obj.f * 2*pi;
        end
    end
end

