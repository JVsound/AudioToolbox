classdef closedbox
    %CLOSEDBOX
    
    properties
        vol     (1,1)   double      {mustBeNonnegative}     = 0;    % Net volume of closed box [m3]
    end
    
    methods
        function obj = closedbox(vol)
            %CLOSEDBOX Construct an instance of this class
            %   Detailed explanation goes here
            
            if nargin >= 1
                obj.vol     = vol;
            end

        end
        function val = zarear(obj,w)
            %ZAREAR Acoustic impedance of closed box [Ns/m5]

            % Acoustic compliance:
            ca              = obj.vol / (acoustics.misc.rho0 * ...
                acoustics.misc.c^2);

            % Acoustic impedance:
            val             = -1i* 1./(w*ca);
        end
    end
end

