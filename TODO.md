# TODO

Cross-cutting tasks for the Loudspeaker System Toolbox. Tasks that belong to one specific file go in
that file as `% TODO: ...` (see the TODO/FIXME Report in the MATLAB Current Folder panel).

## Open

- [ ] Closed-box loudspeaker system (`comp.ClosedBox`)
  - [ ] Code
    - [ ] Review `zaradf`, `zacbr`, `tae` and `tarad` against closed-box theory (Beranek and Mellow, Small); decide
      whether the radiation mass in `zaradf` must be left out because `Mms` already contains it (`fc` is now
      64 Hz where the closed-form value is 69 Hz)
    - [ ] Replace `diaphragm2RadiatedVolumeVelocity` by the radiated volume velocity from inside `ta` (port 2 open)
    - [ ] Convert `comp.Enclosure` and `comp.ClosedBox` to `conventions\classdefconventions.m`
  - [ ] Tests
    - [ ] Resolve the failing tests `lowerCutoffFrequency` and `levelFollowsClosedBoxResponse` in `resultTest.m`
    - [ ] Make `resultTest.m` sensitive to the box: use a smaller box (for example 20 L) for the closed-box
      formulas and test that `RearVolume` changes the level
    - [ ] Validate `fc` and `Qtc` against the closed-form values
  - [ ] Documentation
    - [ ] Complete `closedboxdoc.m` (first draft 2026-09-24) and add `enclosuredoc.m` for `comp.Enclosure`
    - [ ] Re-embed the outputs of `lspsysdoc.m` and `GettingStarted.m`, now that `RearVolume` has effect
    - [ ] Update `resultdoc.m` (`Pressure`, `SoundPressureLevel`, `MicRadius`)
  - [ ] Examples
    - [ ] Review `toolbox\examples\closedBoxExample.m` (first version 2026-09-24)
    - [ ] Add a test that runs every example in `toolbox\examples`
- [ ] FEA-enclosure loudspeaker system (`comp.FeaEnclosure`)
  - [ ] Code
    - [ ] Implement `importAnsysPressureResults`, `tae`, `tarad` and `diaphragm2RadiatedVolumeVelocity` from the FEA
      results
    - [ ] Convert `comp.FeaEnclosure` to `conventions\classdefconventions.m`
  - [ ] Tests
    - [ ] Test `comp.FeaEnclosure` and compare it with `comp.ClosedBox` at low frequency
  - [ ] Documentation
    - [ ] Add `feaenclosuredoc.m` with the diagram of its 4-ports
  - [ ] Examples
    - [ ] Add `toolbox\examples\feaEnclosureExample.m`

## Other

- [ ] Decide whether to rename the electrical impedance of the driver to the blocked electrical impedance
  - `comp.Driver.ze` returns `Re + 1i*w*Le`, the impedance of the voice coil with the diaphragm blocked, while
    `result.ElectricalImpedance` is the impedance of the whole system (motional part included)
  - [ ] Decide on the new name for `ze` (and check the name of `te`, which uses it)
  - [ ] If renamed: update the code, the tests and the documentation (`zedoc.m`, `tedoc.m`, `driverdoc.m`)
- [ ] Support radiation angles other than `"2pi"`
  - [ ] Extend the `RadiationAngle` validation in `lspsys` and the `ra == "2pi"` branches in the enclosures
  - [ ] Add the solid angle to the `switch` in `result.get.Pressure` and the angle to the test parameter
    `RadiationAngle` of `resultTest.m`
  - [ ] Test the error `result:unsupportedRadiationAngle` for an unsupported angle
- [ ] Find out when and how the tests run
  - Current state (2026-09-21): nothing runs automatically. There is no `buildfile.m`, no `.github` folder and no
    Project shortcuts.
  - [ ] Decide how the tests are started: by hand (`runtests`, Test Browser), from the MATLAB Project, with a
    `buildtool` task, or automatically (Git hook, GitHub Actions)
  - [ ] Decide whether the tests must run before the toolbox is packaged (`tests` is outside `toolbox`, so it is
    not packaged with it)
  - [ ] Decide what documentation the tests need: an overview of the tests, what each one covers and how to run
    them (for example a live script in `tests\validation`, see `conventions\documentationhierarchy.m`)
- [ ] Record the test class naming in `conventions\documentationhierarchy.m` (`resultTest` for a class in the global
  namespace, for example `ClosedBoxTest` for a class in a namespace)
- [ ] Replace the old toolbox name "JVsound Toolbox" with "Loudspeaker System Toolbox" (renamed 2026-09-23) in
  `GettingStarted.m`, `overview.m`, `symbols.m`, the diagram generators and the SVG diagrams; keep the byline
  "J.G. Vermond, JVsound"
