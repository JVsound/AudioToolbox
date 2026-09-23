# Loudspeaker System Toolbox

MATLAB toolbox (MATLAB Project `lspsystbx.prj` and git repository) for modelling loudspeaker systems. `lspsys`
is the shared engine, `result` holds its results, and the enclosures and the driver are classes in the `comp`
namespace.

## Conventions: always follow them

Write all code and all documentation according to the files in `conventions\`. This applies to every new or
edited file, whether or not the request mentions the conventions.

- `classdefconventions.m`: layout of a class, property validation, naming, spaces and line length (at most 120
  characters on every line).
- `documentationdefault.m`: layout of a class documentation page.
- `documentationhierarchy.m`: folder layout of the documentation, `<name>doc.m` naming, and the roles of
  `GettingStarted` and `overview`.

Before writing or editing, read the relevant convention file again: the files change over time and are the
single source of truth, so this file does not repeat their rules. Afterwards, check what you touched against them
(MATLAB Code Analyzer, naming, spaces, line length).

- Do not invent extra rules. If a convention is missing, unclear or conflicts with the request, ask.
- Cite MathWorks coding rules by their title in the latest official MATLAB Coding Guidelines
  (github.com/mathworks/MATLAB-Coding-Guidelines, branch `main`). The guidelines have no rule IDs.
- Documents, conventions and code comments are written in English.
- Methods get no `arguments` block.

## Code first, documentation later

When code is created or changed, do not update the documentation pages (`toolbox\doc\`) or the diagrams in them in
the same task. The documentation is brought up to date later, in one pass, from the code.

- The code must be complete for that pass: everything that follows the conventions, including the help comments
  (H1 line, help lines and the comment at the end of each property line) in the class files.
- Only write or change documentation when the request explicitly asks for it. Then follow `documentationdefault.m`
  and `documentationhierarchy.m` as usual.

## Working in the repository

- Do not convert or reformat files that the request does not mention.
- Renaming breaks saved objects, code and links. Plan a rename first, then update every place in the code that
  uses the name. The documentation is not part of that (see the next section).
- Renamed or moved files must be synchronised with the MATLAB Project afterwards.
- When refactoring, show that behaviour is unchanged by comparing results with a baseline taken before the change.
- Commits are made from the MATLAB Project's source control, not from the shell. Do not commit, push or change
  git configuration unless asked.
- `resources\project\` holds MATLAB Project metadata: do not edit it by hand.
