classdef FeaEnclosure < comp.Enclosure
    %FEAENCLOSURE Enclosure described by the results of an FEA model in Ansys
    %   The FEA model imposes the velocity DiaphragmVelocity on the diaphragm, positive towards the front, and
    %   gives three pressures over frequency: averaged over the front and the rear surface of the diaphragm, and
    %   at the microphone. With the volume velocity U_d of the FEA (VolumeVelocity), they give the loads
    %   Z_a,f = p_f/U_d on the front (tarad) and Z_a,r = -p_r/U_d on the rear of the diaphragm (tae), and the
    %   transfer H_mic = p_mic/U_d to the microphone (micTransfer). The frequencies of the system must lie within the
    %   frequencies of the files (Frequency).

    properties
        DiaphragmVelocity (1,:) double = 1; % Velocity imposed on the diaphragm in the FEA model in [m/s]
        PressureFrontFileName (1,1) string = ""; % Ansys file with the pressure averaged over the front of the diaphragm
        PressureRearFileName (1,1) string = ""; % Ansys file with the pressure averaged over the rear of the diaphragm
        PressureFarFieldFileName (1,1) string = ""; % Ansys file with the pressure at the microphone
    end

    properties (Dependent)
        VolumeVelocity % Volume velocity of the diaphragm in the FEA model in [m3/s]
        Frequency % Frequencies of the Ansys file with the front pressure in [Hz]
    end

    methods
        function obj = FeaEnclosure
            %FEAENCLOSURE Create an FEA enclosure
            %   obj = FeaEnclosure creates an FEA enclosure with a diaphragm velocity of 1 m/s, no result files
            %   and a default driver.
        end

        function val = get.VolumeVelocity(obj)
            %VOLUMEVELOCITY Volume velocity of the diaphragm in the FEA model in [m3/s]
            val = obj.DiaphragmVelocity*obj.Driver.Sd;
        end

        function val = get.Frequency(obj)
            %FREQUENCY Frequencies of the Ansys file with the front pressure in [Hz]
            data = comp.FeaEnclosure.importAnsysPressureResults(obj.PressureFrontFileName);
            val = data.Frequency;
        end

        function val = tae(obj,f,~)
            %TAE Transmission matrix T_a,e of the enclosure, 4 x 4 for each frequency
            %   The load Z_a,r = -p_r/U_d of the rear of the diaphragm is a shunt between the rear conductor and
            %   the reference; the front conductor passes through. The minus sign follows from the rear flows,
            %   which count to the left: a positive diaphragm velocity lowers the pressure at the rear.
            Zr = -obj.fileTransfer(obj.PressureRearFileName,f);
            val = repmat(eye(4),1,1,numel(f));
            val(4,3,:) = -1./Zr;
        end

        function val = tarad(obj,f,~)
            %TARAD Transmission matrix T_a,rad of the radiation, 4 x 4 for each frequency
            %   The load Z_a,f = p_f/U_d of the front of the diaphragm is a shunt between the front conductor and
            %   the reference; the rear conductor passes through.
            Zf = obj.fileTransfer(obj.PressureFrontFileName,f);
            val = repmat(eye(4),1,1,numel(f));
            val(2,1,:) = 1./Zf;
        end

        function val = micTransfer(obj,f,~)
            %MICTRANSFER Transfer from the diaphragm volume velocity to the pressure at the microphone
            %   val = micTransfer(obj,f,ra) returns H_mic = p_mic/U_d in [Pa.s/m3] from the FEA model, for the
            %   frequencies f in [Hz].
            val = obj.fileTransfer(obj.PressureFarFieldFileName,f);
        end
    end

    methods (Access = private)
        function val = fileTransfer(obj,fileName,f)
            %FILETRANSFER Pressure of an Ansys file divided by the FEA volume velocity, at the frequencies f
            %   Interpolates the complex transfer linearly; the frequencies f must lie within those of the file.
            data = comp.FeaEnclosure.importAnsysPressureResults(fileName);
            if min(f) < data.Frequency(1) || max(f) > data.Frequency(end)
                error("FeaEnclosure:frequencyOutOfRange", ...
                    "Frequencies must lie between %g Hz and %g Hz, the range of ""%s"".", ...
                    data.Frequency(1),data.Frequency(end),fileName)
            end
            transfer = data.Pressure./obj.VolumeVelocity;
            val = interp1(data.Frequency,transfer,f);
        end
    end

    methods (Static)
        function val = importAnsysPressureResults(fileName)
            %IMPORTANSYSPRESSURERESULTS Read a pressure result file of Ansys
            %   val = comp.FeaEnclosure.importAnsysPressureResults(fileName) reads a tab-separated file with the
            %   columns Frequency (Hz), Amplitude (MPa), Phase Angle (deg), Real (MPa) and Imaginary (MPa). val
            %   is a structure with the fields Frequency in [Hz] and Pressure, the complex pressure in [Pa], both
            %   row vectors.
            data = readmatrix(fileName,FileType="text",Delimiter="\t",NumHeaderLines=1);
            val.Frequency = data(:,1).';
            val.Pressure = (data(:,4) + 1i*data(:,5)).'*1e6;
        end
    end
end
