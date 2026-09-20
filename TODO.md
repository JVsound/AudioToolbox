# TODO

Cross-cutting tasks for the JVsound Toolbox. Tasks that belong to one specific file go in
that file as `% TODO: ...` (see the TODO/FIXME Report in the MATLAB Current Folder panel).

## Open

- [ ] Calculate and validate sound pressure level for a closed box (`comp.ClosedBox`)
  - [ ] Implement `result.Pressure` and `result.SoundPressureLevel` (now placeholders); decide: phasors are RMS
  - [ ] Test `result` against the analytical half-space formula (`resultTest.m`)
  - [x] Add a fixture driver with real parameters for the tests (`tests\createTestDriver.m`, B&C 21SW152-8)
  - [x] Add the B&C 21SW152-8 datasheet PDF to `tests\helperfiles` and check the fixture values against it
  - [x] Digitize the datasheet impedance curve (`tests\helperfiles\digitizeImpedance.m` -> `bc21sw152impedance.csv`)
  - [ ] Decide what to do with the older 21SW152-8 values in `GettingStarted.m`, `lspsysdoc.m` and `driverdoc.m` (they differ from the datasheet)
  - [ ] Validate the `lspsys` engine with `ClosedBox` against closed-form `fc` and `Qtc` (`lspsysTest.m`)
  - [ ] Test `ClosedBox` compliance and `zarad` against theory (`ClosedBoxTest.m`)
  - [ ] Complete the enclosure contract test `EnclosureTest.m` (parameterized over radiation angle)
- [ ] Calculate and validate sound pressure level for an FEA enclosure (`comp.FeaEnclosure`)
  - [ ] Implement `importAnsysPressureResults` and the impedance from the FEA
  - [ ] Add `FeaEnclosureTest.m` (inherits `EnclosureTest`)
  - [ ] Compare with `comp.ClosedBox` at low frequency

## In progress

## Done

- [x] Set up SSH authentication between MATLAB and GitHub (2026-09-20)
