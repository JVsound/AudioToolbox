%[text] # zeb
%[text] Blocked electrical impedance of the voice coil
%[text] Class: comp.Driver
%%
%[text] ## Syntax
%[text] ```matlabCodeExample
%[text] val = zeb(obj,f)
%[text] ```
%%
%[text] ## Description
%[text] `val = zeb(obj,f)` returns the electrical impedance of the voice coil of the driver `obj` with the diaphragm blocked, at the frequencies `f`. It is not the impedance of the whole system, which is `result.ElectricalImpedance` ($ Z\_e $): that one also holds the motional part of the driver and the load of the enclosure.
%%
%[text] ## Input Arguments
%[text] `f` — Frequencies in Hz, specified as a row vector.
%%
%[text] ## Output Arguments
%[text] `val` — Blocked electrical impedance $ Z\_{eb} $ in Ohm, returned as a complex row vector of the same size as `f`.
%%
%[text] ## Algorithms
%[text] The resistance and the inductance of the voice coil in series, with $ \\omega = 2 \\pi f $:
%[text]{"align":"center"} $ Z\_{eb} = R\_e + j \\omega L\_e $
%%
%[text] ## See Also
%[text] [`te`](matlab:open(fullfile(fileparts(fileparts(which('lspsys'))),'doc','comp','driver','methods','tedoc','tedoc.m'))) | [`comp.Driver`](matlab:open(fullfile(fileparts(fileparts(which('lspsys'))),'doc','comp','driver','driverdoc.m')))

%[appendix]{"version":"1.0"}
%---
%[metadata:view]
%   data: {"layout":"inline"}
%---
