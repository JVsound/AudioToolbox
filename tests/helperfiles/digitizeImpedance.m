function digitizeImpedance
    %DIGITIZEIMPEDANCE Digitize the impedance curve of the B&C 21SW152-8 datasheet
    %   digitizeImpedance reads bc21sw152impedance.png (the impedance chart on page 3 of the datasheet
    %   B&C 21SW152-8.pdf), finds the axes from the frame of the chart, extracts the red curve and
    %   writes 300 logarithmically spaced points to bc21sw152impedance.csv. The columns are
    %   Frequency in [Hz] and Impedance in [Ohm]. Both files are next to this file.
    %
    %   The chart has logarithmic axes: 20 Hz to 20 kHz horizontally and 2 to 200 Ohm vertically. The
    %   accuracy is limited by the resolution of the image: about 1 pixel, which is well below 1% of the
    %   impedance, but the line is 3 pixels wide, so steep parts (the resonance peak) are less accurate.

    folder = fileparts(mfilename('fullpath'));
    img = imread(fullfile(folder,'bc21sw152impedance.png'));
    [height,width,~] = size(img);
    red = double(img(:,:,1));
    green = double(img(:,:,2));
    blue = double(img(:,:,3));

    % Frame of the chart: the long dark vertical and horizontal lines.
    dark = red < 110 & green < 110 & blue < 110;
    isVerticalLine = sum(dark,1) > 0.6*height;
    isHorizontalLine = sum(dark,2) > 0.6*width;
    left = find(isVerticalLine,1);
    right = find(isVerticalLine,1,'last');
    top = find(isHorizontalLine,1);
    bottom = find(isHorizontalLine,1,'last');

    % Pixels of the red curve, one impedance value per pixel column.
    curve = (red - max(green,blue)) > 120;
    columns = left+2:right-2;
    impedance = nan(size(columns));
    for k = 1:numel(columns)
        rows = find(curve(top:bottom,columns(k))) + top - 1;
        if ~isempty(rows)
            impedance(k) = 200*10^(-2*(median(rows)-top)/(bottom-top));
        end
    end
    frequency = 20*10.^(3*(columns-left)/(right-left));
    valid = ~isnan(impedance);
    frequency = frequency(valid);
    impedance = impedance(valid);

    % Resample to logarithmically spaced frequencies.
    frequencyOut = logspace(log10(frequency(1)),log10(frequency(end)),300)';
    impedanceOut = 10.^interp1(log10(frequency),log10(impedance),log10(frequencyOut));
    result = table(frequencyOut,impedanceOut,'VariableNames',{'Frequency','Impedance'});
    writetable(result,fullfile(folder,'bc21sw152impedance.csv'));
end
