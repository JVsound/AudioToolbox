# TODO

Cross-cutting tasks for the Loudspeaker System Toolbox. Tasks that belong to one specific file go in
that file as `% TODO: ...` (see the TODO/FIXME Report in the MATLAB Current Folder panel).

## Open

- [ ] Fix `lspsys` ignoring the rear enclosure (found 2026-09-21, root cause found 2026-09-22)
  - `ClosedBox.RearVolume` has no effect on `result`: `ElectricalImpedance`, `SoundPressureLevel` and the volume
    velocity are identical for 20 L, 200 L and 5 m3.
  - **Root cause, proven algebraically:** in `lspsys.solve2PortNetwork`, `Tar` is the last matrix in
    `T = Te*Tbl*Tm*Tsd*Taf*Tar`, and `ClosedBox.tar` builds it as a shunt matrix (`val(2,1,:) = zarInt.^-1`). For
    any matrices `M*[1 0;Y 1]`, column 2 of the product equals column 2 of `M`: appending a shunt matrix as the
    LAST factor can never change `T(1,2)` or `T(2,2)`, which are exactly what `Qd = Eg/T(1,2)` and
    `ig = T(2,2)*Qd` use. So `Zar` (and `RearVolume`) is mathematically guaranteed to have no effect as long as
    `tar` stays shunt-form and stays last, regardless of its value.
  - **Cross-checked against `sandbox\_archive\simulinkdiagram\equivalentcircuit.slx`** (2026-09-22): traced its
    `Line` connections (block `Sd`, an Ideal Transformer). Both of its secondary terminals reach the SAME ground
    (`rf`+front reactive network on one, `rr`+rear reactive network on the other, all `Electrical Reference` blocks
    on that island are one node), so `Zaf` and `Zar` are electrically in SERIES with each other there, not one in
    shunt. This matches `taf`'s series form, not `tar`'s shunt form.
  - [ ] Likely fix: change `ClosedBox.tar` to build a series matrix (`val(1,2,:) = zarInt`, mirroring `taf`)
    instead of a shunt matrix, so `T = Te*Tbl*Tm*Tsd*Taf*Tar` sums `Zaf+Zar` in series (verify algebraically that
    this makes `T(1,2)` depend on `Zar` before committing) — NOT YET APPLIED, needs confirmation first
  - [ ] After a fix, check the impedance peak lands near `fc = Fs*sqrt(1+Vas/Vb)` (45 Hz for the test driver in
    200 L, not the current 33 Hz which is the free-air peak)
  - [ ] Re-embed the outputs of `lspsysdoc.m` (and check `GettingStarted.m`) after the fix
- [ ] Check the closed-box model (`comp.ClosedBox`)
  - [ ] Review `zaf`, `zar`, `taf`, `tar` and `qd2Qr` against closed-box theory (Beranek and Mellow, Small) and
    against `equivalentcircuit.slx`
- [ ] Decide whether to rename the electrical impedance of the driver to the blocked electrical impedance
  - `comp.Driver.ze` returns `Re + 1i*w*Le`, the impedance of the voice coil with the diaphragm blocked, while
    `result.ElectricalImpedance` is the impedance of the whole system (motional part included)
  - [ ] Decide on the new name for `ze` (and check the name of `te`, which uses it)
  - [ ] If renamed: update the code, the tests and the documentation (`zedoc.m`, `tedoc.m`, `driverdoc.m`)
- [ ] Validate sound pressure level for a closed box (`comp.ClosedBox`)
  - [ ] Make `resultTest.m` sensitive to the box: the closed-box comparisons pass for 200 L only because that box
    (`Vb = Vas`) has a response close to the free-air response. Add a test that `RearVolume` changes the level and
    use a smaller box (for example 20 L) for the closed-box formulas
  - [ ] Validate the `lspsys` engine with `ClosedBox` against closed-form `fc` and `Qtc` (`lspsysTest.m`)
  - [ ] Test `ClosedBox` compliance and `zarad` against theory (`ClosedBoxTest.m`)
  - [ ] Complete the enclosure contract test `EnclosureTest.m`
  - [ ] Check that `resultTest.m` fails when the pressure formula is wrong (mutation check)
- [ ] Calculate and validate sound pressure level for an FEA enclosure (`comp.FeaEnclosure`)
  - [ ] Implement `importAnsysPressureResults` and the impedance from the FEA
  - [ ] Add `FeaEnclosureTest.m` (inherits `EnclosureTest`)
  - [ ] Compare with `comp.ClosedBox` at low frequency
- [ ] Support radiation angles other than `"2pi"`
  - [ ] Extend the `RadiationAngle` validation in `lspsys` and the `ra == "2pi"` branches in the enclosures
  - [ ] Add the solid angle to the `switch` in `result.get.Pressure` and the angle to the test parameters
    `RadiationAngle` of `EnclosureTest.m` and `resultTest.m`
  - [ ] Test the error `result:unsupportedRadiationAngle` for an unsupported angle
- [ ] Apply the conventions to the remaining code
  - [ ] Convert the enclosure classes (`comp.*` except `Driver`) to `conventions\classdefconventions.m`
  - [ ] Remove the spaces after commas in `ClosedBoxTest.m` and `EnclosureTest.m`
  - [ ] Record the test class naming in `conventions\documentationhierarchy.m` (`resultTest` for a class in the global
    namespace, `EnclosureTest` for a class in a namespace)
- [ ] Find out when and how the tests run (next session)
  - Current state (2026-09-21): nothing runs automatically. There is no `buildfile.m`, no `.github` folder and no
    Project shortcuts. In the Project, `EnclosureTest.m` and `resultTest.m` have the label Test, but
    `ClosedBoxTest.m` has the label Design.
  - [ ] Correct the Project label of `ClosedBoxTest.m` (Test instead of Design), if the Project uses the labels
    to find the tests
  - [ ] Decide how the tests are started: by hand (`runtests`, Test Browser), from the MATLAB Project, with a
    `buildtool` task, or automatically (Git hook, GitHub Actions)
  - [ ] Decide whether the tests must run before the toolbox is packaged (`tests` is outside `toolbox`, so it is
    not packaged with it)
  - [ ] Decide what documentation the tests need: an overview of the tests, what each one covers and how to run
    them (for example a live script in `tests\validation`, see `conventions\documentationhierarchy.m`)
- [ ] Bring the documentation up to date with the code, in one pass
  - [ ] `resultdoc.m` (`Pressure`, `SoundPressureLevel`, `MicRadius`) and `lspsysdoc.m`
  - [ ] Class diagrams: regenerate them, the members are listed by hand in `generateclassdiagramsvg.m`
  - [ ] `doc/symbols.m` (added 2026-09-22): keep it in sync when properties are renamed, added or removed, and
    add rows for `comp.BassReflex`/`comp.FrontLoadedHorn`/`comp.FeaEnclosure` once those classes have real properties
  - [ ] Replace the old toolbox name "JVsound Toolbox" with "Loudspeaker System Toolbox" (renamed 2026-09-23) in
    `GettingStarted.m`, `overview.m`, `symbols.m`, the diagram generators and the SVG diagrams; keep the byline
    "J.G. Vermond, JVsound"

## In progress

## Done

- [x] Use the test driver values (B&C 21SW152-8) in `GettingStarted.m`, `lspsysdoc.m` and `driverdoc.m`, with the
  outputs of the last two re-embedded (2026-09-21)
- [x] Implement `result.Pressure` and `result.SoundPressureLevel` (phasors are RMS) and test them in `resultTest.m`
  (2026-09-21)
- [x] Convert `lspsys`, `Driver` and `result` to the class conventions (2026-09-19 to 2026-09-21)
- [x] Add the fixture driver B&C 21SW152-8 (`tests\createTestDriver.m`) with the datasheet PDF and the digitized
  impedance curve in `tests\helperfiles` (2026-09-20)
- [x] Set up SSH authentication between MATLAB and GitHub (2026-09-20)
