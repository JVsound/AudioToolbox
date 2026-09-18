clearvars; close all; clc;
%[text] # Getting Started with the JVsound Toolbox
%[text] JVsound, J.G. Vermond
%[text] ## Introduction
%[text] This toolbox models loudspeaker systems: a driver (electromechanical transducer) mounted in an enclosure, combined into a loudspeaker system (`lspsys`) that solves for the system's frequency-domain response (`result`).
%[text] ## Build a driver
%[text] Create a `comp.Driver` and set its Thiele/Small parameters:
d			= comp.Driver;
d.Re		= 5.3;
d.Le		= 1.9e-3;
d.Qes		= 0.32;
d.Qms		= 5.6;
d.Fs		= 32;
d.Sd		= 1210e-4;
d.Vas		= 187e-3;
%[text] ## Build an enclosure
%[text] Create a `comp.ClosedBox` enclosure and mount the driver in it:
e				= comp.ClosedBox;
e.RearVolume	= 200e-3;
e.Driver		= d;
%[text] ## Build the loudspeaker system
%[text] Combine the enclosure into an `lspsys` object:
sys				= lspsys;
sys.Enclosure	= e;
%[text] ## Solve and plot
%[text] `createResult` solves the system and returns the frequency-domain response as a `result` object. Plot the electrical impedance:
res					= sys.createResult;
fig1				= figure;
ax1					= axes; hold on; grid on;
ax1.XScale			= "log";
ax1.Title.String	= "Electric impedance of loudspeaker system";
ax1.XLabel.String	= "[Hz]";
ax1.YLabel.String	= "[\Omega]";
plot(ax1,res.Frequency,abs(res.ElectricalImpedance),LineWidth=1.5)
%[text] ## Next steps
%[text] - [Class documentation overview](matlab:open(fullfile(fileparts(fileparts(which('lspsys'))),'doc','overview.m'))) — links to full documentation for every class.
%[text] - [`lspsys` documentation](matlab:open(fullfile(fileparts(fileparts(which('lspsys'))),'doc','lspsys','lspsysdoc.m')))
%[text] - [`comp.Driver` documentation](matlab:open(fullfile(fileparts(fileparts(which('lspsys'))),'doc','comp','driver','driverdoc.m')))
%[text] - [`result` documentation](matlab:open(fullfile(fileparts(fileparts(which('lspsys'))),'doc','result','resultdoc.m'))) \

%[appendix]{"version":"1.0"}
%---
%[metadata:view]
%   data: {"layout":"inline"}
%---
