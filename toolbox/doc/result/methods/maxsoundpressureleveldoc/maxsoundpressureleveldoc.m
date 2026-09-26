%[text] # maxSoundPressureLevel
%[text] Highest sound pressure level that the power and the excursion limits allow
%[text] Class: result
%%
%[text] ## Syntax
%[text] ```matlabCodeExample
%[text] val = maxSoundPressureLevel(obj)
%[text] val = maxSoundPressureLevel(obj,Excursion=X,Power=P)
%[text] [val,powerLevel,excursionLevel] = maxSoundPressureLevel(___)
%[text] ```
%%
%[text] ## Description
%[text] `val = maxSoundPressureLevel(obj)` returns the maximum sound pressure level $ \\mathrm{SPL}\_{max} $ in dB at each frequency, with the limits that the driver chooses in `Driver.ExcursionLimit` and `Driver.PowerLimit`. `Excursion=X` and `Power=P` use other limits without changing the driver: `X` is `"Xmax"`, `"Xvar"`, `"Xlim"`, `"Xmech"` or a peak excursion in m, one way; `P` is `"Pnom"`, `"Pcont"`, `"Paes1984"`, `"Paes2012"` or a power in W. `powerLevel` and `excursionLevel` are the levels that each limit allows alone; `val` is the lower of both.
%%
%[text] ## Input Arguments
%[text] ### Name-Value Arguments
%[text] `Excursion` — Excursion limit, specified as `"Xmax"`, `"Xvar"`, `"Xlim"` or `"Xmech"` (a limit of `Driver`), or as a peak excursion in m, one way. Default: `Driver.ExcursionLimit`.
%[text] `Power` — Power limit, specified as `"Pnom"`, `"Pcont"`, `"Paes1984"` or `"Paes2012"` (a limit of `Driver`), or as a power in W. Default: `Driver.PowerLimit`.
%%
%[text] ## Output Arguments
%[text] `val` — Maximum sound pressure level $ \\mathrm{SPL}\_{max} $ in dB, returned as a row vector over `Frequency`.
%[text] `powerLevel` — Level in dB that the power limit alone allows, returned as a row vector over `Frequency`.
%[text] `excursionLevel` — Level in dB that the excursion limit alone allows, returned as a row vector over `Frequency`. `val` is the lower of `powerLevel` and `excursionLevel`.
%%
%[text] ## Algorithms
%[text] The model is linear, so the level scales with the source voltage $ e\_g $. The excursion limit $ X $ allows the RMS voltage at which the peak excursion $ \\hat{x} $ of the diaphragm (from `DiaphragmExcursion`) reaches it; a power limit of the driver allows the RMS voltage $ \\sqrt{P Z} $ with the impedance of its definition, and a power given as a number is the real power into the electrical impedance $ Z\_e $:
%[text]{"align":"center"} $ \\hat{x} = \\sqrt{2} \\, |x\_d|, \\quad V\_x = e\_g \\frac{X}{\\hat{x}}, \\quad V\_P = \\sqrt{P Z} \\;\\; \\textrm{or} \\;\\; V\_P = |Z\_e| \\sqrt{\\frac{P}{\\mathrm{Re}\\{Z\_e\\}}} $
%[text]{"align":"center"} $ \\mathrm{SPL}\_{max} = \\mathrm{SPL} + 20 \\log\_{10} \\frac{\\min(V\_x, V\_P)}{e\_g} $
%[text] $ Z = Z\_{min} $ for `Pnom`, `Pcont` and `Paes1984` (AES2-1984), and $ Z = Z\_{nom} $ for `Paes2012` (AES2-2012). A chosen limit of 0 (not given) or an unknown name gives an error.
%%
%[text] ## See Also
%[text] [`result`](matlab:open(fullfile(fileparts(fileparts(which('lspsys'))),'doc','result','resultdoc.m'))) | [`comp.Driver`](matlab:open(fullfile(fileparts(fileparts(which('lspsys'))),'doc','comp','driver','driverdoc.m')))

%[appendix]{"version":"1.0"}
%---
%[metadata:view]
%   data: {"layout":"inline"}
%---
