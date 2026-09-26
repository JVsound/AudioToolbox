%[text] # tsd
%[text] Transmission matrix of the effective area of the diaphragm
%[text] Class: comp.Driver
%%
%[text] ## Syntax
%[text] ```matlabCodeExample
%[text] val = tsd(obj)
%[text] ```
%%
%[text] ## Description
%[text] `val = tsd(obj)` returns the 2 × 2 transmission matrix of the diaphragm of the driver `obj`: an ideal transformer from force and velocity to pressure and volume velocity, with the effective area `Sd`. It does not depend on frequency; `lspsys.solve2PortNetwork` repeats it for each frequency.
%%
%[text] ## Output Arguments
%[text] `val` — Transmission matrix $ \\mathbf{T}\_{sd} $, returned as a 2 × 2 matrix.
%%
%[text] ## Algorithms
%[text] The force is the pressure times the area and the volume velocity is the velocity times the area, $ f = S\_d \\, p $ and $ U = S\_d \\, u $:
%[text]{"align":"center"} $ \\left\[ \\matrix{f\_2 \\cr u\_2} \\right\] = \\mathbf{T}\_{sd} \\left\[ \\matrix{p\_1 \\cr U\_d} \\right\], \\quad \\mathbf{T}\_{sd} = \\left\[ \\matrix{S\_d & 0 \\cr 0 & \\frac{1}{S\_d}} \\right\] $
%%
%[text] ## See Also
%[text] [`solve2PortNetwork`](matlab:open(fullfile(fileparts(fileparts(which('lspsys'))),'doc','lspsys','methods','solve2portnetworkdoc','solve2portnetworkdoc.m'))) | [`comp.Driver`](matlab:open(fullfile(fileparts(fileparts(which('lspsys'))),'doc','comp','driver','driverdoc.m')))

%[appendix]{"version":"1.0"}
%---
%[metadata:view]
%   data: {"layout":"inline"}
%---
