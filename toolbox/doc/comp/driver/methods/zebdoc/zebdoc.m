clearvars; close all; clc;
%[text] # Method: `zeb`
%[text] JVsound, J.G. Vermond
%[text] ## Description
%[text] The method `zeb` resides in the class `comp.Driver`. It returns the blocked electrical impedance $ Z\_{eb} = R\_e + j\\omega L\_e $ as a function of frequency: the impedance of the voice coil with the diaphragm blocked. It is not the impedance of the whole system, which is `result.ElectricalImpedance` ($ Z\_e $).

%[appendix]{"version":"1.0"}
%---
%[metadata:view]
%   data: {"layout":"inline"}
%---
