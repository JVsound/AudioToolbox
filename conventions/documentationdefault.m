%[text] # Documentation defaults
%[text] **J.G. Vermond, JVsound**
%[text] Default layout for documentation in the Loudspeaker System Toolbox. The folder structure and the file names are described in `documentationhierarchy.m`; this document describes the content and the formatting of the documentation files. `lspsysdoc.m` is the example of a class page.
%%
%[text] ## Classes
%[text] Classes are documented with the same layout that MathWorks shows on its site for a class. Reference: [matlab.unittest.TestCase class](https://nl.mathworks.com/help/matlab/ref/matlab.unittest.testcase-class.html); for the layout of properties: [matlab.unittest.TestRunner class](https://nl.mathworks.com/help/matlab/ref/matlab.unittest.testrunner-class.html). The sections appear in this order:
%[text] 1. **Title block** — the title `# name Class` in plain letters, without code formatting, as MathWorks does (for example `lspsys Class`); below it one sentence that summarizes the class, and the lines Namespace and Superclasses.
%[text] 2. **Description** — what the class is for.
%[text] 3. **Creation** — how to create an object, see below.
%[text] 4. **Properties** — each property gets its own heading (`###`) with the name in code formatting and a short description, below it the type and size, the description and an Attributes line (for example GetAccess, SetAccess, Dependent, Hidden, Constant). No grouping per attribute block.
%[text] 5. **Methods** — one table with the public methods: name (link to the method documentation), type (Instance or Static) and short description.
%[text] 6. **Events** — table with Event, Trigger, Event Data and Attributes; only if the class has events.
%[text] 7. **Examples** — named examples. \
%[text] Sections without content, such as Events for a class without events, are left out.
%%
%[text] ### Creation
%[text] MathWorks uses two patterns for the Creation section, depending on how the object is created:
%[text] - **The constructor is the class itself** (example: [datetime](https://www.mathworks.com/help/matlab/ref/datetime.html)). The Creation section on the class page then contains the syntax as a code example, a description and the arguments (Input Arguments or Name-Value Arguments), only if the constructor has them. There is no separate page for the constructor, and the constructor is not in the Methods table. This is the pattern for the classes in this toolbox.
%[text] - **The object is created with a function or static methods** (example: [testrunner](https://nl.mathworks.com/help/matlab/ref/testrunner.html) for TestRunner). The Creation section on the class page is then a short explanation that points to those pages; the syntax is on those pages. \
%%
%[text] ## Formatting
%[text] The formatting of the live script follows the rules of the skill `matlab-create-live-script`, supplemented with:
%[text] - There is no `clearvars`, `close all` or `clc` at the top of the file.
%[text] - Before every heading (`##` and `###`), except the title, there is a `%%` on its own line, so that every heading is a section of its own.
%[text] - From the Description chapter on, every MATLAB name in running text is written in monospace (with backticks): classes, methods, functions, properties, arguments, variables and so on. Units, such as Hz and kHz, are not MATLAB names and are not written in monospace. This does not apply in the Title block.
%[text] - Matrices and vectors are written in bold upright letters with `\\mathbf`, in equations and in the labels of diagrams: $ \\mathbf{T}\_a $, $ \\mathbf{x}\_3 $. Only the letter is bold, not the subscript. Scalars stay in italics, also the elements of a matrix ($ T\_{11} $) and quantities that are arrays over frequency ($ U\_d $).
%[text] - A class page has no table of contents: MathWorks does not show one in the class page itself either, and with every property as a heading the list would become unwieldy. \
%%
%[text] ### Width of figures and tables
%[text] Every figure and every table stays completely visible when the live script is exported to PDF. The export does not scale content to the page: a width of 1 px in the live script becomes 0.75 pt in the PDF, and whatever is wider than the text width is cut off. Without the `Margins` option, the export uses margins of 28 pt (measured in the exported PDF; the help of `export` mentions 72 pt), so the text width is 539 pt on A4 and 556 pt on Letter. Therefore:
%[text] - An image is at most 700 px wide: the `width` in its appendix entry is 700 or less, and its `height` keeps the ratio of the PNG.
%[text] - A table has a sum of `columnWidths` of 700 px or less. A column with width `-1` is as wide as its content, so its content must fit in what the fixed columns leave of the 700 px.
%[text] - Export to PDF without the `Margins` option, for example `export("name.m","name.pdf",PageSize="A4")`. \

%[appendix]{"version":"1.0"}
%---
%[metadata:view]
%   data: {"layout":"inline"}
%---
