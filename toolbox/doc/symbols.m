%[text] # Symbols
%[text] **J.G. Vermond, JVsound**
%[text] Every symbol used in the Loudspeaker System Toolbox, alphabetically, with its unit. The first table lists the quantities with the property or method that holds them; the second table lists the elements and port quantities of the equivalent circuits. New here? Start with [Getting Started](matlab:open(fullfile(fileparts(fileparts(which('lspsys'))),'doc','GettingStarted.m'))); for links to the class documentation, see the [documentation overview](matlab:open(fullfile(fileparts(fileparts(which('lspsys'))),'doc','overview.m'))).
%%
%[text] ## Quantities
%[text:table]{"columnWidths":[80,80,-1]}
%[text] | Symbol | Unit | Property |
%[text] | --- | --- | --- |
%[text] | $ Bl $ | Tm | `Bl` |
%[text] | $ c $ | m/s | `SpeedOfSound` |
%[text] | $ C_{ms} $ | m/N | `Cms` |
%[text] | $ e_g $ | V (RMS) | `SourceVoltage` |
%[text] | $ f $ | Hz | `Frequency` |
%[text] | $ f_s $ | Hz | `Fs` |
%[text] | $ i_g $ | A | `SourceCurrent` |
%[text] | $ k $ | rad/m | `WaveNumber` |
%[text] | $ \\lambda $ | m | `Wavelength` |
%[text] | $ L_e $ | H | `Le` |
%[text] | $ M_{md} $ | kg | `Mmd` |
%[text] | $ M_{mi} $ | kg | `Mmi` |
%[text] | $ M_{ms} $ | kg | `Mms` |
%[text] | $ \\omega $ | rad/s | `AngularFrequency` |
%[text] | $ \\Omega $ | sr | `RadiationAngle` |
%[text] | $ p $ | Pa | `Pressure` |
%[text] | $ p_0 $ | Pa | `ReferencePressure` |
%[text] | $ Q_{es} $ | - | `Qes` |
%[text] | $ Q_{ms} $ | - | `Qms` |
%[text] | $ Q_{ts} $ | - | `Qts` |
%[text] | $ r_d $ | m | `DiaphragmRadius` |
%[text] | $ R_e $ | Ohm | `Re` |
%[text] | $ \\rho $ | kg/m3 | `AirDensity` |
%[text] | $ r_{mic} $ | m | `MicRadius` |
%[text] | $ R_{ms} $ | Ns/m | `Rms` |
%[text] | $ S_d $ | m2 | `Sd` |
%[text] | $ \\mathrm{SPL} $ | dB | `SoundPressureLevel` |
%[text] | $ U_d $ | m3/s | `DiaphragmVolumeVelocity` |
%[text] | $ U_{rad} $ | m3/s | `RadiatedVolumeVelocity` |
%[text] | $ V_{as} $ | m3 | `Vas` |
%[text] | $ V_b $ | m3 | `RearVolume` |
%[text] | $ Z_e $ | Ohm | `ElectricalImpedance` |
%[text] | $ Z_{eb} $ | Ohm | `zeb` |
%[text] | $ Z_m $ | Ns/m | `zm` |
%[text:table]
%%
%[text] ## Circuit elements
%[text] Symbols of the elements and the port quantities in the equivalent circuits. They are not held by one property: the diagram on the page in the last column shows where they sit. When a circuit holds more elements of the same kind, they are numbered, for example $ C_{a1} $ and $ C_{a2} $.
%[text:table]{"columnWidths":[80,80,-1,-1]}
%[text] | Symbol | Unit | Meaning | Diagram |
%[text] | --- | --- | --- | --- |
%[text] | $ C_a $ | m5/N | Acoustic compliance of a closed volume | [`comp.ClosedBox`](matlab:open(fullfile(fileparts(fileparts(which('lspsys'))),'doc','comp','closedbox','closedboxdoc.m'))) |
%[text] | $ M_a $ | kg/m4 | Acoustic mass of the air that moves with the diaphragm | [`comp.ClosedBox`](matlab:open(fullfile(fileparts(fileparts(which('lspsys'))),'doc','comp','closedbox','closedboxdoc.m'))) |
%[text] | $ p_f $ | Pa | Pressure of the front conductor relative to the ambient pressure | [`solve2PortNetwork`](matlab:open(fullfile(fileparts(fileparts(which('lspsys'))),'doc','lspsys','methods','solve2portnetworkdoc','solve2portnetworkdoc.m'))) |
%[text] | $ p_r $ | Pa | Pressure of the rear conductor relative to the ambient pressure | [`solve2PortNetwork`](matlab:open(fullfile(fileparts(fileparts(which('lspsys'))),'doc','lspsys','methods','solve2portnetworkdoc','solve2portnetworkdoc.m'))) |
%[text] | $ T_a $ | - | Transmission matrix of the acoustical side, 2 × 2, reduced from $ T_{a,e} $ and $ T_{a,rad} $ | [`solve2PortNetwork`](matlab:open(fullfile(fileparts(fileparts(which('lspsys'))),'doc','lspsys','methods','solve2portnetworkdoc','solve2portnetworkdoc.m'))) |
%[text] | $ T_{a,e} $ | - | Transmission matrix of the enclosure, 4 × 4 (`tae`) | [`solve2PortNetwork`](matlab:open(fullfile(fileparts(fileparts(which('lspsys'))),'doc','lspsys','methods','solve2portnetworkdoc','solve2portnetworkdoc.m'))) |
%[text] | $ T_{a,rad} $ | - | Transmission matrix of the radiation, 4 × 4 (`tarad`) | [`solve2PortNetwork`](matlab:open(fullfile(fileparts(fileparts(which('lspsys'))),'doc','lspsys','methods','solve2portnetworkdoc','solve2portnetworkdoc.m'))) |
%[text] | $ U_f $ | m3/s | Volume velocity in the front conductor | [`solve2PortNetwork`](matlab:open(fullfile(fileparts(fileparts(which('lspsys'))),'doc','lspsys','methods','solve2portnetworkdoc','solve2portnetworkdoc.m'))) |
%[text] | $ U_r $ | m3/s | Volume velocity in the rear conductor | [`solve2PortNetwork`](matlab:open(fullfile(fileparts(fileparts(which('lspsys'))),'doc','lspsys','methods','solve2portnetworkdoc','solve2portnetworkdoc.m'))) |
%[text] | $ Z_{rad} $ | Pa.s/m3 | Radiation impedance | [`comp.ClosedBox`](matlab:open(fullfile(fileparts(fileparts(which('lspsys'))),'doc','comp','closedbox','closedboxdoc.m'))) |
%[text:table]

%[appendix]{"version":"1.0"}
%---
%[metadata:view]
%   data: {"layout":"inline"}
%---
