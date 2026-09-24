classdef ClosedBox < comp.Enclosure
    %CLOSEDBOX Closed-box enclosure of a loudspeaker driver
    %   The rear of the diaphragm works on the air in a closed volume (RearVolume); the front radiates as a
    %   rigid piston in an infinite baffle. tae and tarad return the 4-ports of the enclosure and the radiation.

    properties
        RearVolume (1,1) double {mustBePositive} = 10e-3; % Volume of the closed chamber behind the diaphragm in [m3]
    end

    methods
        function obj = ClosedBox
            %CLOSEDBOX Create a closed-box enclosure
            %   obj = ClosedBox creates a closed box with a rear volume of 10 L and a default driver.
        end

        function val = tae(obj,f,~)
            %TAE Transmission matrix T_a,e of the enclosure, 4 x 4 for each frequency
            %   On the rear conductor, the acoustic mass Ma of the air that moves with the diaphragm is in
            %   series, followed by the compliance Ca of the closed volume as a shunt to the reference; the
            %   front conductor passes through. The rear flows count to the left.

            % Angular frequency in [rad/s]:
            w = 2*pi*f;

            % Acoustic mass Ma of the air load on the rear of the diaphragm in [kg/m4]:
            Ma = obj.Driver.Mmi/obj.Driver.Sd^2;

            % Acoustic compliance Ca of the closed volume in [m5/N]:
            Ca = obj.RearVolume/(lspsys.AirDensity*lspsys.SpeedOfSound^2);

            % Transmission matrices: the series mass (element (3,4) -j*w*Ma) times the shunt compliance
            % (element (4,3) -j*w*Ca) on the rear conductor:
            val = repmat(eye(4),1,1,numel(f));
            val(3,3,:) = 1 - w.^2*Ma*Ca;
            val(3,4,:) = -1i*w*Ma;
            val(4,3,:) = -1i*w*Ca;
        end

        function val = tarad(obj,f,ra)
            %TARAD Transmission matrix T_a,rad of the radiation, 4 x 4 for each frequency
            %   The radiation impedance Zrad of the front of the diaphragm is a shunt between the front
            %   conductor and the reference; the rear does not radiate and passes through.

            % Only radiation from a rigid piston in an infinite baffle is supported:
            if ra ~= "2pi"
                error("ClosedBox:unsupportedRadiationAngle","Unsupported radiation angle ""%s"".",ra)
            end

            % Radiation impedance Zrad of the diaphragm in [Pa.s/m3]:
            Zrad = comp.Enclosure.zarad(obj.Driver.DiaphragmRadius,2*pi*f);

            % Transmission matrices, with the shunt admittance 1/Zrad on the front conductor:
            val = repmat(eye(4),1,1,numel(f));
            val(2,1,:) = 1./Zrad;
        end
    end
end
