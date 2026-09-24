# TODO

Cross-cutting tasks for the Loudspeaker System Toolbox. Tasks that belong to one specific file go in
that file as `% TODO: ...` (see the TODO/FIXME Report in the MATLAB Current Folder panel).

## Open

- [x] Closed-box loudspeaker system (`comp.ClosedBox`)
  - [x] Code
    - [x] Review `tae` and `tarad` against closed-box theory (Beranek and Mellow, Small): the air load on the rear
      was missing, because `comp.Driver` takes the air load on both sides out of `Mmd`; added the acoustic mass
      `Ma = Mmi/Sd^2` in series on the rear conductor of `tae`, so `fc` is now 45.2 Hz, as in Small (45.3 Hz)
      (2026-09-24)
    - [x] Replace `diaphragm2RadiatedVolumeVelocity` by the radiated volume velocity from the network: an enclosure
      provides only `tae` and `tarad`, and `lspsys.solve2PortNetwork` reduces them and returns
      `RadiatedVolumeVelocity` (2026-09-24)
    - [x] Convert `comp.Enclosure` and `comp.ClosedBox` to `conventions\classdefconventions.m` (2026-09-24)
  - [x] Tests
    - [x] Test the sound pressure level of a closed box of 20 L against the theory of Small (`Le = 0`,
      10 Hz to 400 Hz, `AbsTol = 0.3` dB): `tests\ClosedBoxTest.m`, the only test, explained in its help
      (2026-09-24); the earlier, larger test setup is in the git history
  - [x] Documentation
    - [x] Complete `closedboxdoc.m` and add `enclosuredoc.m` for `comp.Enclosure` (2026-09-24)
    - [x] Re-embed the outputs of `lspsysdoc.m` and `GettingStarted.m`, now that `RearVolume` has effect
      (2026-09-24)
    - [x] Rewrite `resultdoc.m` as a class page after `conventions\documentationdefault.m`: all properties,
      including `Pressure`, `SoundPressureLevel` and `MicRadius`, with examples (2026-09-24)
  - [x] Examples
    - [x] Review `toolbox\examples\closedBoxExample.m` (2026-09-24)
- [ ] FEA-enclosure loudspeaker system (`comp.FeaEnclosure`)
  - [ ] Code
    - [ ] Implement `importAnsysPressureResults`, `tae` and `tarad` from the FEA results
    - [ ] Convert `comp.FeaEnclosure` to `conventions\classdefconventions.m`
  - [ ] Tests
    - [ ] Decide whether and how to test `comp.FeaEnclosure`, for example against `comp.ClosedBox` at low frequency
  - [ ] Documentation
    - [ ] Add `feaenclosuredoc.m` with the diagram of its 4-ports
  - [ ] Examples
    - [ ] Add `toolbox\examples\feaEnclosureExample.m`

## Other

- [x] Decide whether to rename the electrical impedance of the driver to the blocked electrical impedance
  - `comp.Driver.ze` returns `Re + 1i*w*Le`, the impedance of the voice coil with the diaphragm blocked, while
    `result.ElectricalImpedance` is the impedance of the whole system (motional part included)
  - [x] Decide on the new name for `ze`: `zeb`, after the symbol $Z_{eb}$; `te` keeps its name, like `tm`
    (2026-09-24)
  - [x] Update the code and the documentation (`zebdoc.m`, `tedoc.m`, `driverdoc.m`, `symbols.m`, class
    diagram) (2026-09-24)
- [ ] Support radiation angles other than `"2pi"` (postponed on 2026-09-24: only `"2pi"` for now)
  - [ ] Extend the `RadiationAngle` validation in `lspsys` and the `ra == "2pi"` branches in the enclosures
  - [ ] Add the solid angle to the `switch` in `result.get.Pressure`
- [x] Find out when and how the tests run
  - [x] Keep it simple: `buildtool` runs the one test, `buildtool package` runs the test and then packages the
    toolbox into `release\LoudspeakerSystemToolbox.mltbx`, version 0.1.0; `buildfile.m` is as short as possible
    (2026-09-24)
  - [x] Decide whether the tests also run automatically on GitHub: no, only locally (2026-09-24)
  - [x] Decide what documentation the tests need: none apart from the help in the test class (2026-09-24)
- [x] Replace the old toolbox name "JVsound Toolbox" with "Loudspeaker System Toolbox" (renamed 2026-09-23) in
  `GettingStarted.m`, `overview.m`, `symbols.m`, the diagram generators and the SVG diagrams; keep the byline
  "J.G. Vermond, JVsound" (2026-09-24; the repository on GitHub was renamed by hand, the folder on disk keeps its
  name for now)
