classdef closedbox
    %CLOSEDBOX Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        f       (:,1)   double      {mustBeNonnegative}     = 0;    % Frequency [Hz] vector for calculation purposes.
        vol     (1,1)   double      {mustBeNonnegative}     = 0;    % Net volume of closed box [m3]
    end

    properties (Dependent)
        w                                                           % Frequency vector [rad/s]
        zarear                                                      % Acoustic impedance of closed box [Ns/m5]
    end
    
    methods
        function obj = closedbox(vol)
            %CLOSEDBOX Construct an instance of this class
            %   Detailed explanation goes here
            
            if nargin >= 1
                obj.vol     = vol;
            end

        end
        function val = get.w(obj)
            %W Frequency in [rad/s]

            val     = obj.f * 2 * pi;
        end
        function val = get.zarear(obj)
            % Acoustic impedance of closed box [Ns/m5]
            %   
            %   

            % Extract constants:
            rho0            = acoustics.misc.rho0;
            c               = acoustics.misc.c;

            % Acoustic compliance:
            ca              = obj.vol / (rho0*c^2);

            % Acoustic impedance:
            val             = -1i* 1./(obj.w*ca);
        end
    end
end

