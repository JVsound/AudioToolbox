%[text] # zm
%[text] Mechanical impedance of the moving system of the driver
%[text] Class: comp.Driver
%%
%[text] ## Syntax
%[text] ```matlabCodeExample
%[text] val = zm(obj,f)
%[text] ```
%%
%[text] ## Description
%[text] `val = zm(obj,f)` returns the mechanical impedance of the moving system of the driver `obj`, at the frequencies `f`: the mass of the diaphragm and the voice coil, the resistance and the compliance of the suspension. The air load is not in it: the enclosure adds it on the acoustical side.
%%
%[text] ## Input Arguments
%[text] `f` — Frequencies in Hz, specified as a row vector.
%%
%[text] ## Output Arguments
%[text] `val` — Mechanical impedance $ Z\_m $ in Ns/m, returned as a complex row vector of the same size as `f`.
%%
%[text] ## Algorithms
%[text] The mass $ M\_{md} $, the resistance $ R\_{ms} $ and the compliance $ C\_{ms} $ in series, with $ \\omega = 2 \\pi f $:
%[text]{"align":"center"} $ Z\_m = j \\omega M\_{md} + R\_{ms} + \\frac{1}{j \\omega C\_{ms}} $
%[text] $ M\_{md} = M\_{ms} - 2 M\_{mi} $ is the moving mass without the air load on both sides.
%%
%[text] ## See Also
%[text] [`tm`](matlab:open(fullfile(fileparts(fileparts(which('lspsys'))),'doc','comp','driver','methods','tmdoc','tmdoc.m'))) | [`comp.Driver`](matlab:open(fullfile(fileparts(fileparts(which('lspsys'))),'doc','comp','driver','driverdoc.m')))

%[appendix]{"version":"1.0"}
%---
%[metadata:view]
%   data: {"layout":"inline"}
%---
