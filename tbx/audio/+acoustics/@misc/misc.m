classdef misc
    %MISC Class containing miscellanous properties.
    %
    %   2024-03-24, J.G. Vermond
    
    properties (Access = public, Constant)
        rho0    = 1.18                              % Density of air [kg/m3]
        c       = 344.8                             % Speed of sound in air [m/s]
        pref    = 20e-6                             % Reference sound pressure [Pa]
        mu      = 1.825e-5                          % Viscosity coefficient of air [kg/(m.s)]
        nu      = 1.516e-5                          % Kinematic viscosity of air [m2/s]
    end
    
    methods
        function obj = misc
            %MISC Construct an instance of this class
        end
    end
end

