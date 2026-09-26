%[text] # tbl
%[text] Transmission matrix of the electromechanical transduction
%[text] Class: comp.Driver
%%
%[text] ## Syntax
%[text] ```matlabCodeExample
%[text] val = tbl(obj)
%[text] ```
%%
%[text] ## Description
%[text] `val = tbl(obj)` returns the 2 × 2 transmission matrix of the transduction of the driver `obj` from the electrical to the mechanical side: a gyrator with the force factor `Bl`. It does not depend on frequency; `lspsys.solve2PortNetwork` repeats it for each frequency.
%%
%[text] ## Output Arguments
%[text] `val` — Transmission matrix $ \\mathbf{T}\_{bl} $, returned as a 2 × 2 matrix.
%%
%[text] ## Algorithms
%[text] A gyrator turns the current into a force and the velocity into a voltage, $ f = Bl \\, i $ and $ e = Bl \\, u $:
%[text]{"align":"center"} $ \\left\[ \\matrix{e\_2 \\cr i\_2} \\right\] = \\mathbf{T}\_{bl} \\left\[ \\matrix{f\_1 \\cr u\_1} \\right\], \\quad \\mathbf{T}\_{bl} = \\left\[ \\matrix{0 & Bl \\cr \\frac{1}{Bl} & 0} \\right\] $
%%
%[text] ## See Also
%[text] [`solve2PortNetwork`](matlab:open(fullfile(fileparts(fileparts(which('lspsys'))),'doc','lspsys','methods','solve2portnetworkdoc','solve2portnetworkdoc.m'))) | [`comp.Driver`](matlab:open(fullfile(fileparts(fileparts(which('lspsys'))),'doc','comp','driver','driverdoc.m')))

%[appendix]{"version":"1.0"}
%---
%[metadata:view]
%   data: {"layout":"inline"}
%---
