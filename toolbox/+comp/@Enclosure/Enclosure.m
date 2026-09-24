classdef (Abstract) Enclosure
    %ENCLOSURE Base class for the enclosure of a loudspeaker driver
    %   An enclosure holds a driver (Driver) and describes the acoustical side of the loudspeaker system with
    %   two 4-ports on the front, reference and rear conductor: tae for the enclosure and tarad for the
    %   radiation. lspsys.solve2PortNetwork reduces them to the 2-port of the acoustical side. zarad and
    %   struve are helper functions for radiation impedances.

    properties
        Driver (1,1) comp.Driver = comp.Driver; % Driver that is mounted in the enclosure
    end

    methods
        function obj = Enclosure
            %ENCLOSURE Create an enclosure
            %   obj = Enclosure is called by the constructor of a subclass; the enclosure gets a default driver.
        end
    end

    methods (Abstract)
        val = tae(obj,f,ra)
        val = tarad(obj,f,ra)
    end

    methods (Static)
        function val = zarad(rd,w)
            %ZARAD Radiation impedance of a rigid circular piston in an infinite baffle
            %   val = zarad(rd,w) returns the radiation impedance in [Pa.s/m3] of a rigid circular piston with
            %   the radius rd in [m] in an infinite baffle, at the angular frequencies w in [rad/s].

            % Density of air and speed of sound:
            rho = lspsys.AirDensity;
            c = lspsys.SpeedOfSound;

            % Wave number:
            k = w/c;

            % Bessel function of the first kind:
            besselJ1 = besselj(1,2*k*rd);

            % Struve function of the first kind:
            struveH1 = comp.Enclosure.struve(2*k*rd);

            % Specific radiation resistance and reactance:
            rs = rho*c*(1-besselJ1./(k*rd));
            xs = rho*c*struveH1./(k*rd);

            % Specific impedance:
            zs = rs + 1i*xs;

            % Radiation impedance:
            val = zs/(pi*rd^2);
        end

        function val = struve(x)
            %STRUVE Struve function of the first kind
            %   val = struve(x) returns an approximation of the Struve function H1 of the first kind at x.
            %   Source: R. M. Aarts and A. J. E. M. Janssen, "Approximation of the Struve function H1 occurring in
            %   impedance calculations".
            val = 2/pi - besselj(0,x) + (16/pi-5)*sin(x)./x + (12-36/pi)*(1-cos(x))./x.^2;
        end
    end
end
