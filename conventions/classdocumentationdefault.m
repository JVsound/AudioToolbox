%[text] Openstaande punten: 
%[text] - Vragen aan claude hoe matlab documentatie maakt voor een class.
%[text] - Kijken of name - Value combo logische input is voor een class constructor. \
%[text] Hierarchy for documentation: All documentation
%[text] Opzet van documentatie Live script (plain text) voor een class in de JVsound Toolbox
%[text] # Class: `lspsys` (loudspeaker system)
%[text] J.G. Vermond, JVsound
%[text:tableOfContents]{"heading":"Table of Contents"}
%[text] ## Description
%[text] Hier een beschrijving van wat de class doet.
%[text] ### Syntax
%[text] Hier komt een 'code example' block volgens MATLAB interpretatie, voor hoe de class is te constructen: 
%[text] ```matlabCodeExample
%[text] obj = lspsys
%[text] obj = lspsys()
%[text] ```
%[text] ## Properties
%[text] Hier komt een lijst met properties, onderverdeeld in dezelfde blokken als in het class definition file. Zie onder het voorbeeld. De attribute "Access = public" noemen we niet.
%[text] ### Value
%[text] - `Frequency` \[Hz\] (1,:) // Frequency vector for simulation purposes. Defaults to ...
%[text] - `SourceVoltage`
%[text] - `RadiationAngle`
%[text] - `Enclosure` \
%[text] ### Dependent, hidden
%[text] - `AngularFrequency`
%[text] - `WaveNumber`
%[text] - `Wavelength`
%[text] - `NumFrequencies` \
%[text] ### Constant, hidden
%[text] - `SpeedOfSound = 343` \[m/s\] //
%[text] - `AirDensity = 1.225` \[kg/m3\] //
%[text] - `ReferencePressure = 20e-6` \[Pa\] // \
%[text] ## Methods
%[text] ### Constructor
%[text]
%[text] ### Instance methods
%[text] Elke publieke instance-methode die een eigen documentatiebestand heeft (in de `methods`-submap van deze class) wordt hier als link met een korte omschrijving opgenomen — dit is de index waar de losse method-doc-bestanden vanuit deze pagina vindbaar worden. Methodes zonder eigen documentatiebestand hoeven hier niet vermeld te worden.
%[text] - [`methodName`](matlab:open(fullfile(fileparts(fileparts(which('lspsys'))),'doc','lspsys','methods','methodNamedoc','methodNamedoc.m'))) — Brief description of what the method does. Link pattern: see 'Links between documentation files' in documentationhierarchy.m. \
%[text] ### Static
%[text]
%[text] ## Examples
%[text] Praktijkvoorbeelden van gebruik, elk met een eigen naam/label.
%[text] ### Example: Brief label describing the example
%[text] ```matlabCodeExample
%[text] obj = lspsys;
%[text] ```
%[text] ## See Also
%[text] Gerelateerde classes of namespaces uit de toolbox, elk met één regel context over de relatie.
%[text] - `RelatedClass` — one-line description of how it relates to this class. \

%[appendix]{"version":"1.0"}
%---
%[metadata:view]
%   data: {"layout":"inline"}
%---
