function driver = createTestDriver
    %CREATETESTDRIVER Fixture driver for the tests: B&C 21SW152-8
    %   driver = createTestDriver returns a comp.Driver with the Thiele-Small parameters of the B&C
    %   21SW152-8 from the datasheet in tests/helperfiles (B&C 21SW152-8.pdf, page 2).

    driver = comp.Driver;
    driver.Re = 6;
    driver.Le = 2.2e-3;
    driver.Qes = 0.38;
    driver.Qms = 6.4;
    driver.Fs = 32;
    driver.Sd = 1680e-4;
    driver.Vas = 200e-3;
end
