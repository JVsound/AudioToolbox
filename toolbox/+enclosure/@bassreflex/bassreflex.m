classdef bassreflex
    %BASSREFLEX
    
    properties
        vol     (1,1)   double      {mustBeNonnegative}     = 0;    % Net volume of enclosure, excluding port [m3]
        hport   (1,1)   double      {mustBePositive}        = 0.05; % Height of port [m]
        wport   (1,1)   double      {mustBePositive}        = 0.25; % Width of port [m]
		lport	(1,1)	double		{mustBePositive}		= 0.1;	% Length of port [m]
    end

    properties (SetAccess = protected)
        nport   (1,1)   double      {mustBePositive}        = 1;    % Number of bass reflex ports.
    end

    properties (Dependent)
        sdport                                                      % Area of port [m2]
        rport                                                       % Radius of port [m]
    end
    
    methods
        function obj = bassreflex(vol)
            %BASSREFLEX Construct an instance of this class
            %   Detailed explanation goes here
            
            if nargin >= 1
                obj.vol     = vol;
            end

		end
        function obj = set.rport(obj,val)
            %RPORT 

            obj.hport   = pi * val^2 / obj.wport;
        end
        function val = get.rport(obj)
            %RPORT

            val         = sqrt(obj.sdport / pi);
        end
        function val = get.sdport(obj)
            %SDPORT
            
            val     = obj.hport * obj.wport;
        end
		function val = zarear(obj,w)
			%ZAREAR 

			val = obj.vol * w;
		end

    end
end

