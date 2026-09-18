%[text] # Documentation hierarchy
%[text] J.G. Vermond, JVsound
%[text] ## Hierarchy in documentation folder of JVsound toolbox
%[text] Directly in the 'toolbox' folder there is a 'doc' folder, which contains all documentation for the toolbox.
%[text] - First subdivision (folders directly in 'doc'): folders for each class, namespace, or standalone function directly located in the 'toolbox' directory, with the exception of the 'doc' folder itself, which is neither a class, namespace, nor function. The folders have the same name as the class, namespace, or function they document, in lowercase (for example `doc/comp/driver` for `comp.Driver`).
%[text] - Inside a class or function folder: a single live script file describing that class or function (see 'Filename conventions' below), plus a 'helperfiles' subfolder.
%[text] - Inside a namespace folder: **the same structure recurses one level down** — one subfolder per class/function that lives in that namespace, each again containing its own live script and its own 'helperfiles' subfolder. A namespace folder does not itself hold loose live script files; it only holds class/function subfolders (and, if the namespace contains nested namespaces, further namespace subfolders, recursing the same way).
%[text] - Each documentation folder (class, function, or namespace) gets its own subfolder called 'helperfiles', for figures, additional info etc. This keeps helper files unambiguous even for namespaces with several classes, since each class keeps its own 'helperfiles'.
%[text] - A class or function documentation folder may also contain a `methods` subfolder. Only public instance methods substantial enough to warrant their own page go here (trivial accessors don't) — each gets its own subfolder inside `methods`, named after it, again recursing the same class/function pattern one level down: `methods/<methodname>doc/<methodname>doc.m` plus its own `helperfiles` subfolder.
%[text] - `doc/GettingStarted.m` is reserved by MathWorks' own toolbox-packaging convention (used by `packageToolbox`/the `matlab-package-toolbox` skill, following [mathworks/toolboxdesign](https://github.com/mathworks/toolboxdesign)) as the single onboarding script shown automatically on installation. It coexists directly inside `doc/` alongside the class/namespace subfolders described above — never repurpose or overwrite it for class documentation, and it must keep running in under 5 seconds without user interaction.
%[text] - `doc/overview.m` is the landing live script for the whole hierarchy: a short page that links to every top-level class and namespace documentation folder, so a reader does not have to discover the structure by browsing folders. \
%[text] ## Filename conventions
%[text] - A documentation file is named as the class, namespace-member, or function it documents, all lowercase, with the literal suffix `doc` appended directly (no separator): `<name>doc.m`. Examples: `lspsysdoc.m`, `driverdoc.m`, `enclosuredoc.m`. This applies at every nesting level, including inside namespace subfolders. \
%[text] ## Links between documentation files
%[text] Live scripts have no native relative-path link to another file: a markdown link whose target is a relative file path is not resolved as a file link. Use a `matlab:` link that opens the target with `open`, and build the target path from an anchor on the MATLAB path instead of hard-coding it. Pattern (the label is the link text; the path segments after `'doc'` follow the documentation hierarchy above):
%[text] ```matlabCodeExample
%[text] [label](matlab:open(fullfile(fileparts(fileparts(which('lspsys'))),'doc','lspsys','lspsysdoc.m')))
%[text] ```
%[text] - `which('lspsys')` locates the toolbox root through a class that is always on the MATLAB path, both in the development project and in an installed (packaged) toolbox. The two `fileparts` calls strip the file name and the `@lspsys` folder, leaving the `toolbox` folder; the rest of the path is built with `fullfile` relative to it.
%[text] - Do **not** hard-code absolute paths. This is what Insert Hyperlink, Existing file, stores; it breaks as soon as the project is moved or the toolbox is installed elsewhere.
%[text] - Do **not** use `matlab:open` with a bare file name. It relies on every `doc` subfolder being on the MATLAB path: in the project that is a manually maintained list (new folders are not added automatically), and a packaged toolbox does not add `doc` folders to the path by default.
%[text] - Do **not** use `currentProject().RootFolder`. An installed toolbox is not opened as a project, so it fails (or points at an unrelated project) for other users.
%[text] - Requirement: the `doc` folder must be packaged as a sibling of the class folders (inside the toolbox files), so the same anchor-relative path exists in the installed toolbox. If `lspsys` is ever renamed or moved, update the anchor in every link. \
%[text] ## Relation to MathWorks' own toolbox documentation conventions
%[text] These per-class/per-namespace live scripts are the toolbox's **deep reference layer**. They complement, and do not replace, two other layers that MathWorks' toolbox-packaging conventions expect ([mathworks/toolboxdesign](https://github.com/mathworks/toolboxdesign), surfaced locally by the `matlab-package-toolbox` skill):
%[text] - **Inline help** (H1 line + syntax paragraphs in the `classdef`/function file itself) — what answers `help ClassName` / `doc ClassName` on the command line. Covered separately by the `matlab-write-help` skill/guidelines, not by this hierarchy.
%[text] - **`doc/GettingStarted.m`** — single quick-start script auto-shown on install (see above).
%[text] - **`toolbox/examples/`** **+** **`demos.xml`** — short, runnable example scripts (plain `%%` section breaks, not full live-script markup) registered in MATLAB's Examples gallery. \
%[text] If this toolbox is ever packaged as an installable add-on, keep these three layers and this documentation hierarchy distinct rather than merging them. \\

%[appendix]{"version":"1.0"}
%---
%[metadata:view]
%   data: {"layout":"inline","rightPanelPercent":40}
%---
