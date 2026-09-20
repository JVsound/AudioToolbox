classdef ClosedBoxTest < EnclosureTest
    %CLOSEDBOXTEST Tests for comp.ClosedBox
    %   Inherits the contract tests from EnclosureTest. The tests specific to ClosedBox (compliance,
    %   zarad, fc and Qtc) still have to be added.

    methods
        function enclosure = createEnclosure(~)
            %CREATEENCLOSURE Enclosure under test
            enclosure = comp.ClosedBox;
            enclosure.Driver = createTestDriver;
        end
    end
end
