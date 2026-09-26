classdef (Abstract) Enclosure
    %ENCLOSURE Base class for the enclosure of a loudspeaker driver
    %   An enclosure holds a driver (Driver) and describes the acoustical side of the loudspeaker system with
    %   two 4-ports on the front, reference and rear conductor: tae for the enclosure and tarad for the
    %   radiation. lspsys.solve2PortNetwork reduces them to the 2-port of the acoustical side. zaFront and
    %   zaRear return the loads on the front and the rear of the diaphragm, for every enclosure. micTransfer can
    %   give the transfer from the diaphragm volume velocity to the pressure at the microphone; by default it
    %   is empty and result calculates the pressure from the radiated volume velocity. zarad and struve are
    %   helper functions for radiation impedances.

    properties
        Driver (1,1) comp.Driver = comp.Driver; % Driver that is mounted in the enclosure
    end

    methods
        function obj = Enclosure
            %ENCLOSURE Create an enclosure
            %   obj = Enclosure is called by the constructor of a subclass; the enclosure gets a default driver.
        end

        function val = micTransfer(~,~,~)
            %MICTRANSFER Transfer from the diaphragm volume velocity to the pressure at the microphone
            %   val = micTransfer(obj,f,ra) returns the transfer H_mic = p_mic/U_d in [Pa.s/m3] for the
            %   frequencies f in [Hz] and the radiation angle ra. The base class returns an empty array: result
            %   then calculates the pressure from the radiated volume velocity. A subclass that knows the
            %   pressure at the microphone, such as comp.FeaEnclosure, overrides it.
            val = zeros(1,0);
        end

        function val = zaFront(obj,f,ra)
            %ZAFRONT Load on the front of the diaphragm
            %   val = zaFront(obj,f,ra) returns the acoustic impedance Z_a,f = p_f1/U_d in [Pa.s/m3] that the front
            %   of the diaphragm works on, for the frequencies f in [Hz] and the radiation angle ra. It follows
            %   from tae and tarad with port 2 of the acoustical side open, so it holds for every enclosure.
            [val,~] = obj.diaphragmLoads(f,ra);
        end

        function val = zaRear(obj,f,ra)
            %ZAREAR Load on the rear of the diaphragm
            %   val = zaRear(obj,f,ra) returns the acoustic impedance Z_a,r = -p_r1/U_d in [Pa.s/m3] that the rear
            %   of the diaphragm works on, for the frequencies f in [Hz] and the radiation angle ra. The minus sign
            %   follows from the rear flows, which count to the left. zaFront + zaRear is the total acoustic load.
            [~,val] = obj.diaphragmLoads(f,ra);
        end
    end

    methods (Access = private)
        function [front,rear] = diaphragmLoads(obj,f,ra)
            %DIAPHRAGMLOADS Loads on the front and the rear of the diaphragm, from tae and tarad
            %   Reduces the 4-ports as lspsys.solve2PortNetwork does, with port 2 open: x3 = K*[p2; 0] gives the
            %   pressures p_f1 and p_r1 and the volume velocity U_d at port 1, for any p2.
            Tae = obj.tae(f,ra);
            Tarad = obj.tarad(f,ra);
            P = [1 0; 0 1; 0 0; 0 1];
            q = [1; 0; 1; 0];
            front = zeros(1,numel(f));
            rear = zeros(1,numel(f));
            for i = 1:numel(f)
                M = Tae(:,:,i)*Tarad(:,:,i);
                d = M(2,:) - M(4,:);
                K = P - q*(d*P)/(d*q);
                x1 = M*K*[1; 0];
                front(i) = x1(1)/x1(2);
                rear(i) = -x1(3)/x1(2);
            end
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
