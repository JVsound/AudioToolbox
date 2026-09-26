%[text] # tm
%[text] Transmission matrix of the mechanical side of the driver
%[text] Class: comp.Driver
%%
%[text] ## Syntax
%[text] ```matlabCodeExample
%[text] val = tm(obj,f)
%[text] ```
%%
%[text] ## Description
%[text] `val = tm(obj,f)` returns the 2 × 2 transmission matrix of the mechanical side of the driver `obj` for each frequency in `f`: the mechanical impedance `zm` of the moving system as a series element.
%%
%[text] ## Input Arguments
%[text] `f` — Frequencies in Hz, specified as a row vector.
%%
%[text] ## Output Arguments
%[text] `val` — Transmission matrices $ \\mathbf{T}\_m $, returned as a 2 × 2 × `numel(f)` array.
%%
%[text] ## Algorithms
%[text] A series impedance between the force $ f\_1 $ and velocity $ u\_1 $ of the gyrator and the force $ f\_2 $ and velocity $ u\_2 $ on the diaphragm:
%[text]{"align":"center"} $ \\left\[ \\matrix{f\_1 \\cr u\_1} \\right\] = \\mathbf{T}\_m \\left\[ \\matrix{f\_2 \\cr u\_2} \\right\], \\quad \\mathbf{T}\_m = \\left\[ \\matrix{1 & Z\_m \\cr 0 & 1} \\right\] $
%%
%[text] ## See Also
%[text] [`zm`](matlab:open(fullfile(fileparts(fileparts(which('lspsys'))),'doc','comp','driver','methods','zmdoc','zmdoc.m'))) | [`solve2PortNetwork`](matlab:open(fullfile(fileparts(fileparts(which('lspsys'))),'doc','lspsys','methods','solve2portnetworkdoc','solve2portnetworkdoc.m'))) | [`comp.Driver`](matlab:open(fullfile(fileparts(fileparts(which('lspsys'))),'doc','comp','driver','driverdoc.m')))

%[appendix]{"version":"1.0"}
%---
%[metadata:view]
%   data: {"layout":"inline"}
%---
