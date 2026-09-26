# TODO

Cross-cutting tasks for the Loudspeaker System Toolbox. Tasks that belong to one specific file go in
that file as `% TODO: ...` (see the TODO/FIXME Report in the MATLAB Current Folder panel).

## Open

- [ ] Closed-box loudspeaker system (`comp.ClosedBox`): tests against the standard closed-box formulas
  - [x] Sound pressure level at 1 m against the response of Small (`tests\ClosedBoxTest.m`, 2026-09-24)
  - [ ] Electrical impedance against the standard formulas
  - [ ] Excursion of the diaphragm against the standard formulas (`result.DiaphragmExcursion`, added 2026-09-26)
- [ ] FEA-enclosure loudspeaker system (`comp.FeaEnclosure`): the same tests, against FEA simulation results
  - [ ] Simulation results from FEA (by the user)
  - [ ] Sound pressure level at 1 m
  - [ ] Electrical impedance
  - [ ] Excursion of the diaphragm

## Other

- [ ] Support radiation angles other than `"2pi"` (postponed on 2026-09-24: only `"2pi"` for now)
  - [ ] Extend the `RadiationAngle` validation in `lspsys` and the `ra == "2pi"` branches in the enclosures
  - [ ] Add the solid angle to the `switch` in `result.get.Pressure`
