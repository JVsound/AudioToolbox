classdef (Abstract) EnclosureTest < matlab.unittest.TestCase
    %ENCLOSURETEST Contract tests that every comp.Enclosure must pass
    %   Concrete enclosure test classes inherit from this class and implement createEnclosure. The
    %   tests run for every value of RadiationAngle.

    properties (TestParameter)
        RadiationAngle = {"2pi"}; % Add further radiation angles here when lspsys supports them
    end

    methods (Abstract)
        enclosure = createEnclosure(testCase)
    end

    methods (Test)
        function tafSize(testCase, RadiationAngle)
            %TAFSIZE taf returns a 2x2 transmission matrix for each frequency
            f = logspace(1, 4, 50);
            taf = testCase.createEnclosure.taf(f, RadiationAngle);
            testCase.verifySize(taf, [2 2 numel(f)]);
        end

        function tarSize(testCase, RadiationAngle)
            %TARSIZE tar returns a 2x2 transmission matrix for each frequency
            f = logspace(1, 4, 50);
            tar = testCase.createEnclosure.tar(f, RadiationAngle);
            testCase.verifySize(tar, [2 2 numel(f)]);
        end
    end
end
