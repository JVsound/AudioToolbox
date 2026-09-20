%[text] # Classdef conventions
%[text] **J.G. Vermond, JVsound**
%[text] This document holds four conventions for writing a class in the JVsound Toolbox. A class follows the layout of the template that MATLAB generates for File \> New \> Class. Property validation is not part of that template; it is added to it. Names follow the naming rules of the [MATLAB Coding Guidelines](https://github.com/mathworks/MATLAB-Coding-Guidelines) from MathWorks, and so do the spaces. The example shows the layout and the property validation, and its properties are taken from the `lspsys` class.
%%
%[text] ## Example
%[text] ```matlabCodeExample
%[text] classdef Name
%[text]     %NAME Summary
%[text]     %   Description
%[text] 
%[text]     properties
%[text]         Frequency (1,:) double {mustBePositive} = logspace(log10(2e1),log10(2e4),1e3); % Frequencies in [Hz]
%[text]         SourceVoltage (1,1) double {mustBePositive} = 2.83; % Source voltage in [V]
%[text]         RadiationAngle (1,1) string {mustBeMember(RadiationAngle,"2pi")} = "2pi"; % Radiation angle
%[text]         Enclosure (1,1) comp.Enclosure = comp.ClosedBox; % Enclosure of the loudspeaker
%[text]     end
%[text] 
%[text]     properties (Dependent, Hidden)
%[text]         AngularFrequency % Angular frequency in [rad/s]
%[text]         NumFrequencies % Number of frequencies
%[text]     end
%[text] 
%[text]     methods
%[text]         function obj = Name(inputArg1,inputArg2)
%[text]             %NAME Summary
%[text]             %   Description
%[text]             obj.SourceVoltage = inputArg1 + inputArg2;
%[text]         end
%[text] 
%[text]         function val = get.AngularFrequency(obj)
%[text]             %ANGULARFREQUENCY Angular frequency in [rad/s]
%[text]             val = obj.Frequency*2*pi;
%[text]         end
%[text] 
%[text]         function val = get.NumFrequencies(obj)
%[text]             %NUMFREQUENCIES Number of frequencies
%[text]             val = numel(obj.Frequency);
%[text]         end
%[text] 
%[text]         function outputArg = method1(obj,inputArg)
%[text]             %METHOD1 Summary
%[text]             %   Description
%[text]             outputArg = obj.SourceVoltage + inputArg;
%[text]         end
%[text]     end
%[text] end
%[text] ```
%%
%[text] ## Layout of the template
%[text] - Indentation is 4 spaces per level.
%[text] - The H1 line and the help lines are comments directly below the `classdef` line and below the `function` line of a method. They are indented one level deeper than the `classdef` or `function` line above them; for a method that is level with its body.
%[text] - The name in the H1 line is written in capitals (`%NAME`, `%METHOD1`).
%[text] - The blocks appear in this order: `properties`, `properties (Dependent, Hidden)`, then `methods`. In `methods` the constructor comes first, then the `get.` methods.
%[text] - There is one blank line between the blocks and between the methods. \
%%
%[text] ## Property validation (added to the template)
%[text] - Validation is defined on the property line in the `properties` block. Methods do not get an `arguments` block.
%[text] - Each property is one line: the name, the size, the class, the validation functions between braces, and the default value, in that order. Size, class, validation functions and default value are left out where they are not needed.
%[text] - A comment at the end of the line describes the property (the help line).
%[text] - `Dependent` properties have no validation: no size, class, validation functions or default value. They only get a comment at the end of the line with help text, and are computed in a `get.` method.
%[text] - Commas inside the size and inside the validation functions have no space after them (`(1,:)`, `mustBeMember(RadiationAngle,"2pi")`). \
%%
%[text] ## Naming (MathWorks rules)
%[text] Names follow the naming rules of the MATLAB Coding Guidelines. The guideline IDs are given in the table.
%[text:table]
%[text] | Element | Casing | Guideline |
%[text] | --- | --- | --- |
%[text] | Class in a namespace | UpperCamelCase (`comp.Driver`) | R-CLASS-002 |
%[text] | Class in the global namespace | like a function: lowercase or lowerCamelCase (`lspsys`, `result`) | R-CLASS-002, R-FUN-003 |
%[text] | Method | lowerCamelCase or lowercase; lowerCamelCase for multi-word names (`createResult`) | R-CLASS-004 |
%[text] | Property | UpperCamelCase (`SourceVoltage`) | R-CLASS-006 |
%[text] | Event | UpperCamelCase | R-CLASS-007 |
%[text] | Variable | lowerCamelCase; a leading capital is allowed for short mathematical symbols (`Te`, `Qd`) | R-VAR-003 |
%[text:table]
%[text] - Names of functions, classes, methods, properties, events and enumerations are at most 32 characters long (R-FUN-001). Variable names are at most 32 characters long too (R-VAR-001).
%[text] - In the example, `Name` stands for the name of the class: it is written like `Name` in a namespace and like a function (`name`) in the global namespace. The other names in the example follow the table. \
%%
%[text] ## Spaces (MathWorks rules)
%[text] Spaces follow the spacing rules of the MATLAB Coding Guidelines, with one exception: the rule for the space after a comma (R-SPACE-004) is listed in the table but not followed.
%[text:table]{"columnWidths":[324,236,-1]}
%[text] | Operator | Spacing | Guideline |
%[text] | --- | --- | --- |
%[text] | Indentation | 4 spaces per level, no tabs | R-SPACE-001, R-SPACE-002 |
%[text] | Inside parentheses, brackets and braces | no space after the opening or before the closing character (`f(x)`, `[1 2 3]`, `c{k}`) | R-SPACE-003 |
%[text] | After a comma or semicolon | MathWorks: one space, except at the end of a line (`f(a, b)`). **Not followed here for commas:** they are written without a space (`f(a,b)`, `(1,:)`), as in the MATLAB class template | R-SPACE-004 |
%[text] | End of a line | no trailing whitespace | R-SPACE-005 |
%[text] | Around `=` in an assignment | one space on each side (`x = 3`); none in `Name=Value` | R-SPACE-006 |
%[text] | Around relational operators (`<`, `<=`, `==`, `~=`, `>`, `>=`) | one space on each side (`if x <= 3`) | R-SPACE-007 |
%[text] | Around logical AND and OR operators | one space on each side (`a & b`, `a && b`) | R-SPACE-008 |
%[text] | Around the colon operator | no spaces, also not in the operands (`2:2:10`, `A(2:end-1)`) | R-SPACE-009 |
%[text] | Multiply, divide and power (`*`, `.*`, `/`, `./`, `^`, `.^`) | no spaces (`2*pi*f/c`, `x.^2`) | R-SPACE-010 |
%[text] | Plus and minus on the right of an assignment | one space around the operators between the main terms (`z = a*b + c*d`, `z = (a+b) + exp(c+d)`) | R-SPACE-011 |
%[text] | Plus and minus elsewhere: inside parentheses, in function arguments, in indices and in a comparison | no spaces (`exp(a+b)`, `A(k-1)`, `w = y > x+1`) | R-SPACE-011 |
%[text] | Unary plus, minus and not | no space after the operator (`x = -1`, `y = ~flag`) | R-SPACE-012 |
%[text:table]
%[text] - The example above follows this table, for instance `obj.Frequency*2*pi`, `inputArg1 + inputArg2` and, for the commas, `logspace(log10(2e1),log10(2e4),1e3)`. \

%[appendix]{"version":"1.0"}
%---
%[metadata:view]
%   data: {"layout":"inline"}
%---
