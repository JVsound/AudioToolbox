clearvars; close all; clc;

% Frequency [Hz]:
f	= 39.87;
T	= 1/f;

% Voltage RMS [V]:
eg	= 2.83;

% Voltage peak [V]:
egp	= eg * sqrt(2);
% Phase shift [deg]:
ps	= 90;

% Electrical:
re		= 6;
le		= 2.2e-3;

bl		= 39.4295;

% Mechanical:
rms		= 15.3849;
cms		= 5.0512e-5;
mmd		= 0.4118;

sd		= 1680e-4;

% Acoustic:
% 39.87Hz
rf		= -1;
xf		= -1e2i;
rr		= 2;
xr		= 1i;

if imag(xf) == 0
	Laf = 0;
	Caf = 0;
	laf = 1;
	caf = 1;
elseif imag(xf) > 0
	Laf = 1;
	Caf = 0;
	laf = imag(xf);
	caf = 1;
else
	Laf = 0;
	Caf = 1;
	laf = 1;
	caf = -imag(xf);
end

rar		= rr;
if imag(xr) == 0
	Lar = 0;
	Car = 0;
	lar = 1;
	car = 1;
elseif imag(xr) > 0
	Lar = 1;
	Car = 0;
	lar = imag(xr);
	car = 1;
else
	Laf = 0;
	Car = 1;
	lar = 1;
	car = imag(xr);
end

% caf		= 3.8559e-6 * 1e6;
% laf		= 0;
% 
% rar		= -1.5412e-7 * 1e6;
% car		= 3.6097e-6 * 1e6;
% lar		= 0;

%44.888Hz
% caf		= 3.3808e-6 * 1e6;
% rar		= -6.584e-6 * 1e6;
% lar		= 3.0605e-5 * 1e6;

tstop	= 10*T;

out = sim("equivalentcircuit.slx");

fig1	= figure;
ax1		= axes(fig1); hold on; grid on;

ax1.XLim	= [tstop/2 tstop];
yyaxis left
plot(ax1,out.tout,out.eg.Data,LineWidth=1.5)

yyaxis right
plot(ax1,out.tout,out.x.Data*1e3,LineWidth=1.5)

% Gyrator:
% 
% i1 = g * e2
% i2 = g * e1
%
% e2 = BL * i1
% e1 = BL * i2

% Transformer:
%
% e1 = n * e2
% i2 = n * i1
%
% p (v2) = F (v1) / Sd (N)
% Q = xdot * Sd