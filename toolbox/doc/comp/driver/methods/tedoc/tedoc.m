%[text] # te
%[text] Transmission matrix of the electrical side of the driver
%[text] Class: comp.Driver
%%
%[text] ## Syntax
%[text] ```matlabCodeExample
%[text] val = te(obj,f)
%[text] ```
%%
%[text] ## Description
%[text] `val = te(obj,f)` returns the 2 × 2 transmission matrix of the electrical side of the driver `obj` for each frequency in `f`: the blocked electrical impedance `zeb` as a series element. `lspsys.solve2PortNetwork` uses it as the first block of the chain.
%%
%[text] ## Input Arguments
%[text] `f` — Frequencies in Hz, specified as a row vector.
%%
%[text] ## Output Arguments
%[text] `val` — Transmission matrices $ \\mathbf{T}\_e $, returned as a 2 × 2 × `numel(f)` array.
%%
%[text] ## Algorithms
%[text] A series impedance between port 1 (the source, $ e\_g $ and $ i\_g $) and port 2 (the electrical side of the gyrator):
%[text]{"align":"center"} $ \\mathbf{T}\_e = \\left\[ \\matrix{1 & Z\_{eb} \\cr 0 & 1} \\right\], \\quad Z\_{eb} = R\_e + j \\omega L\_e $
%%
%[text] ## See Also
%[text] [`zeb`](matlab:open(fullfile(fileparts(fileparts(which('lspsys'))),'doc','comp','driver','methods','zebdoc','zebdoc.m'))) | [`solve2PortNetwork`](matlab:open(fullfile(fileparts(fileparts(which('lspsys'))),'doc','lspsys','methods','solve2portnetworkdoc','solve2portnetworkdoc.m'))) | [`comp.Driver`](matlab:open(fullfile(fileparts(fileparts(which('lspsys'))),'doc','comp','driver','driverdoc.m')))

%[appendix]{"version":"1.0"}
%---
%[metadata:view]
%   data: {"layout":"inline"}
%---
