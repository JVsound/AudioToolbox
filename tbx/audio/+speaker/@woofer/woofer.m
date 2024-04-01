classdef woofer
    %WOOFER Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        brand   (1,1) string {}         = ""        % Brand or manufacturer of speaker
        model   (1,1) string {}         = ""        % Model of speaker
        size    (1,1) double {}         = ""        % Diameter of speaker in inches

        re      (1,1) double {}         = 0         % 
        qes     (1,1) double {}         = 0         % 
        qms     (1,1) double {}         = 0         %
        fs      (1,1) double {}         = 0         % 
        sd      (1,1) double {}         = 0         %
        vas     (1,1) double {}         = 0         % 

        le      (1,1) double {}         = 0         % Voice coil inductance [H]
        xmax    (1,1) double {}         = 0         % Maximum diaphragm excursion one way [m]
        paes    (1,1) double {}         = 0         % AES Power handling
    end
    
    methods
        function obj = woofer
            %WOOFER Construct an instance of this class.
        end
        
        function outputArg = method1(obj,inputArg)
            %METHOD1 Summary of this method goes here
            %   Detailed explanation goes here
            outputArg = obj.Property1 + inputArg;
        end
    end
end

   % properties (Access = public)
   %      brand       (1,1) string {} = ""            % Brand or manufacturer of speaker
   %      model       (1,1) string {} = ""            % Model of speaker
   %      size        (1,1) double {} = NaN           % Diameter [inch], not used for calculation purposes.
   %      re          (1,1) double {} = NaN           % Impedance [Ohm]
   %      qes         (1,1) double {} = NaN           % Electrical factor [-]
   %      qms         (1,1) double {} = NaN           % Mechanical factor [-]
   %      fs          (1,1) double {} = NaN           % Resonance frequency [Hz]
   %      sd          (1,1) double {} = NaN           % Effective piston area [m2]
   %      vas         (1,1) double {} = NaN           % Equivalent air load [m3]
   %      xmax        (1,1) double {} = NaN           % Max linear excursion [m]
   %      le1k        (1,1) double {} = NaN           % Voice coil inductance [H]
   %      pcon        (1,1) double {} = NaN           % Continuous power handling [W]
   %      ppeak       (1,1) double {} = NaN           % Peak power handling [W]
   %  end
   % 
   %  properties (Dependent, SetAccess = private)
   %      qts                                         % Total q factor [-]
   %      cms                                         % Mechanical compliance [m/N]
   %      mms                                         % Mechanical mass including air load [kg]
   %      rms                                         % Mechanical resistance [Ns/m]
   %      bl                                          % BL factor [Tm]
   %      a                                           % piston radius [m]
   %      mmd                                         % Mechanical moving mass [kg]
   %  end
   % 
   %  methods
   %      function obj = speaker(brand,model,size)
   %          %SPEAKER Construct an instance of this class
   %          %   Detailed explanation goes here
   %          if nargin ~= 0
   %              obj.brand   = brand;
   %              obj.model   = model;
   %              obj.size    = size;
   %          else
   %              % Create default speaker object:
   %              obj.brand   = "RCF";
   %              obj.model   = "CX10N251";
   %              obj.size    = 10;
   %              obj.re      = 5.2;
   %              obj.qes     = 0.25;
   %              obj.qms     = 4.5;
   %              obj.fs      = 72;
   %              obj.sd      = 0.0346;
   %              obj.vas     = 0.025;
   %              obj.xmax    = 0.005;
   %              obj.le1k    = 1.2e-3;
   %              obj.pcon    = 600;
   %              obj.ppeak   = 0;
   %          end
   %      end
   %      function value = get.qts(obj)
   %          value = obj.qes*obj.qms/(obj.qes+obj.qms);
   %      end
   %      function value = get.cms(obj)
   %          value = obj.vas / (obj.sd^2 * acoustics.simulation.rho0 * acoustics.simulation.c^2);
   %      end
   %      function value = get.mms(obj)
   %          value = 1 / ((2*pi*obj.fs)^2*obj.cms);
   %      end
   %      function value = get.rms(obj)
   %          value = 1/obj.qms * sqrt(obj.mms/obj.cms);
   %      end
   %      function value = get.bl(obj)
   %          value = sqrt(obj.re/(2*pi*obj.fs*obj.qes*obj.cms));
   %      end
   %      function value = get.a(obj)
   %          value = sqrt(obj.sd/pi);
   %      end
   %      function value = get.mmd(obj)
   %          %MMD  Mechanical moving mass in [kg].
   % 
   %          % Air load on one side of diaphragm:
   %          mm1     = 8/3 * obj.a^3 * acoustics.simulation.rho0;
   % 
   %          % mmd:
   %          value   = obj.mms - 2 * mm1;
   %      end
   %      function value = ze(obj,w)
   %          %ZE Electric impedance of speaker, for input array w [rad/s].
   %          value = obj.re + 1i*w*obj.le1k;
   %      end
   %      function value = zm(obj,w)
   %          %ZM Mechanical impedance of speaker
   %          value = 1i*w*obj.mmd + obj.rms + 1./(1i*w*obj.cms);
   %      end
   %      function obj = eraseprop(obj)
   %          %ERASEPROP
   %          % Erase properties of object.
   % 
   %          obj.brand   = "";
   %      end
   %  end

%        properties (Access = public)
%         description     % Brief description of speaker
%         re               
%         qes             
%         qms             
%         fs              
%         sd              
%         vas
% 
%         le
%         xmax
%         paes
%     end
% 
%     properties (Access = public, Dependent)
%         qts
%         bl
%         rms
%         mms
%         mmd
%         cms
%         r
%     end
% 
%     methods
%         function obj = speaker
%         end
%         function val = get.qts(obj)
%             val = obj.qes * obj.qms / (obj.qes + obj.qms);
%         end
%         function val = get.bl(obj)
%             %BL
%             val = sqrt(obj.re / (2*pi * obj.fs * obj.qes * obj.cms));
%         end
%         function val = get.rms(obj)
%             %RMS
%             val = 1 / obj.qms * sqrt(obj.mms/obj.cms);
%         end
%         function val = get.mms(obj)
%             %MMS
%             val = 1 / ((2*pi*obj.fs)^2 * obj.cms);
%         end
%         function val = get.mmd(obj)
%             %MMD
%             val = obj.mms - 2.67*obj.r^3*acoustics.misc.rho0;
%         end
%         function val = get.cms(obj)
%             %CMS
%             val = obj.vas / (obj.sd^2 * acoustics.misc.rho0 * ...
%                 acoustics.misc.c^2);
%         end
%         function val = get.r(obj)
%             %R
%             val = sqrt(obj.sd/pi);
%         end
%         function val = ze(obj,w)
%             %ZE
%             val = obj.re + 1i*w*obj.le;
%         end
%         function val = zm(obj,w)
%             %ZM Mechanical impedance
%             val = obj.rms + 1i*w*obj.mmd + 1 ./ (1i*w*obj.cms);
%         end
%     end
% end
