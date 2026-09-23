function svgPath = generatenetworkdiagramsvg(svgPath)
    %GENERATENETWORKDIAGRAMSVG - Write the 2-port network diagram of the loudspeaker system as SVG
    %   GENERATENETWORKDIAGRAMSVG() writes networkdiagram.svg next to this file.
    %
    %   GENERATENETWORKDIAGRAMSVG(svgPath) writes the diagram to svgPath.
    %
    %   svgPath = GENERATENETWORKDIAGRAMSVG(...) also returns the path of the
    %   written file.
    %
    %   The diagram shows the electrical, mechanical and acoustical 2-port
    %   networks of solve2PortNetwork, for documentation only. The element
    %   icons are read from the Simscape Foundation library (Simscape must be
    %   installed); the labels are the symbols of symbols.m. The labels are
    %   typeset with the MathJax that ships with MATLAB, the same as the
    %   equations in a live script, which runs in headless Chrome. The PNG
    %   shown in solve2portnetworkdoc.m is rendered from the SVG with a
    %   browser, for example headless Chrome.

    arguments
        svgPath (1,1) string = ""
    end

    if svgPath == ""
        svgPath = fullfile(fileparts(mfilename("fullpath")), "networkdiagram.svg");
    end

    ink = "#1f4e9c";
    iconRoot = fullfile(matlabroot, "toolbox", "physmod", "simscape", "library", "m", "+foundation", ...
        "+electrical");
    resistor = readicon(fullfile(iconRoot, "+elements", "resistor.svg"), ink);
    inductor = readicon(fullfile(iconRoot, "+elements", "inductor.svg"), ink);
    capacitor = readicon(fullfile(iconRoot, "+elements", "capacitor.svg"), ink);
    gyrator = readicon(fullfile(iconRoot, "+elements", "gyrator.svg"), ink);
    transformer = readicon(fullfile(iconRoot, "+elements", "ideal_transformer.svg"), ink);
    openCircuit = readicon(fullfile(iconRoot, "+elements", "open_circuit.svg"), ink);
    source = readicon(fullfile(iconRoot, "+sources", "ac_voltage.svg"), ink);

    % Rails of the front row (top, bottom), offset of the rear row and label heights
    top = 100;
    bottom = 240;
    rowOffset = 280;
    railGap = bottom - top;
    middle = (top + bottom) / 2 + 8;
    above = top - 14;
    small = 0.2946;
    large = railGap / (416.7 - 141.3);

    parts = strings(0, 1);
    labels = cell(0, 4);
    wire = @(points) sprintf('<polyline points="%s" fill="none" stroke="%s" stroke-width="1.5"/>', ...
        strjoin(compose("%g,%g", points(:, 1), points(:, 2)), " "), ink);
    arrow = @(x, y) sprintf('<path d="M%g,%g L%g,%g L%g,%g z" fill="%s"/>', x - 5, y - 5, x + 5, y, ...
        x - 5, y + 5, ink);

    % Electrical side: source and T_e, port 1 (e_g, i_g) and port 2
    parts(end+1) = placeicon(source, 60, top, railGap / 243, 90, [0 81]);
    labels(end+1, :) = {"e_g", 20, middle, "end"};
    labels(end+1, :) = {"i_g", 100, above, "middle"};
    parts(end+1) = arrow(100, top);
    parts(end+1) = frame(140, 360);
    labels(end+1, :) = {"T_e", 152, 68, "start"};
    parts(end+1) = placeicon(resistor, 160, top, small, 0, [5.4 90]);
    labels(end+1, :) = {"R_e", 195, 145, "middle"};
    parts(end+1) = placeicon(inductor, 255, top, small, 0, [5.4 90]);
    labels(end+1, :) = {"L_e", 286, 145, "middle"};
    parts(end+1) = wire([60 top; 160 top]);
    parts(end+1) = wire([230 top; 255 top]);
    parts(end+1) = wire([317 top; 445 top]);
    parts(end+1) = wire([60 bottom; 445 bottom]);
    labels(end+1, :) = {"e_2", 395, middle, "middle"};
    labels(end+1, :) = {"i_2", 395, above, "middle"};
    parts(end+1) = arrow(395, top);

    % Electromechanical coupling T_bl, mechanical port 1
    parts(end+1) = frame(430, 650);
    labels(end+1, :) = {"T_{bl}", 442, 68, "start"};
    parts(end+1) = placeicon(gyrator, 445, top, large, 0, [5.4 141.3]);
    labels(end+1, :) = {"Bl", 540, 275, "middle"};
    labels(end+1, :) = {"f_1", 685, middle, "middle"};
    labels(end+1, :) = {"u_1", 685, above, "middle"};
    parts(end+1) = arrow(685, top);

    % Mechanical side T_m, mechanical port 2
    parts(end+1) = frame(720, 1020);
    labels(end+1, :) = {"T_m", 732, 68, "start"};
    parts(end+1) = placeicon(inductor, 740, top, small, 0, [5.4 90]);
    labels(end+1, :) = {"M_{ms}", 771, 145, "middle"};
    parts(end+1) = placeicon(resistor, 825, top, small, 0, [5.4 90]);
    labels(end+1, :) = {"R_{ms}", 860, 145, "middle"};
    parts(end+1) = placeicon(capacitor, 920, top, small, 0, [9 90]);
    labels(end+1, :) = {"C_{ms}", 944, 145, "middle"};
    parts(end+1) = wire([634 top; 740 top]);
    parts(end+1) = wire([802 top; 825 top]);
    parts(end+1) = wire([895 top; 920 top]);
    parts(end+1) = wire([968 top; 1105 top]);
    parts(end+1) = wire([634 bottom; 1105 bottom]);
    labels(end+1, :) = {"f_2", 1055, middle, "middle"};
    labels(end+1, :) = {"u_2", 1055, above, "middle"};
    parts(end+1) = arrow(1055, top);

    % Mechanoacoustical coupling T_sd, acoustical port 1 (p_1, Q_d)
    parts(end+1) = frame(1090, 1310);
    labels(end+1, :) = {"T_{sd}", 1102, 68, "start"};
    parts(end+1) = placeicon(transformer, 1105, top, large, 0, [5.4 141.3]);
    labels(end+1, :) = {"S_d", 1200, 275, "middle"};
    labels(end+1, :) = {"p_1", 1332, middle, "middle"};
    labels(end+1, :) = {"Q_d", 1332, above, "middle"};
    parts(end+1) = arrow(1332, top);

    % Acoustical side: the front and rear chains in series in the loop of Q_d
    parts(end+1) = wire([1294 top; 1485 top]);
    parts(end+1) = wire([1294 bottom; 1355 bottom; 1355 bottom + rowOffset; 1485 bottom + rowOffset]);
    parts(end+1) = wire([1485 bottom; 1375 bottom; 1375 top + rowOffset; 1485 top + rowOffset]);
    rows = [0 rowOffset];
    rowSides = ["f", "r"];
    rowNames = ["front", "rear"];
    for k = 1:numel(rows)
        dy = rows(k);
        side = rowSides(k);
        labels(end+1, :) = {"p_{" + side + "1}", 1410, middle + dy, "middle"}; %#ok<AGROW>
        parts(end+1) = twoport(1440, 1600, dy, rowNames(k) + " enclosure", ink); %#ok<AGROW>
        labels(end+1, :) = {"T_{a" + side + "e}", 1452, 68 + dy, "start"}; %#ok<AGROW>
        labels(end+1, :) = {"p_{" + side + "2}", 1635, middle + dy, "middle"}; %#ok<AGROW>
        labels(end+1, :) = {"Q_{" + side + "2}", 1635, above + dy, "middle"}; %#ok<AGROW>
        parts(end+1) = arrow(1635, top + dy); %#ok<AGROW>
        parts(end+1) = twoport(1670, 1830, dy, rowNames(k) + " radiation", ink); %#ok<AGROW>
        labels(end+1, :) = {"T_{a" + side + "r}", 1682, 68 + dy, "start"}; %#ok<AGROW>
        labels(end+1, :) = {"p_{" + side + "3}", 1865, middle + dy, "middle"}; %#ok<AGROW>
        labels(end+1, :) = {"Q_{" + side + "3}", 1865, above + dy, "middle"}; %#ok<AGROW>
        parts(end+1) = arrow(1865, top + dy); %#ok<AGROW>
        parts(end+1) = wire([1555 top + dy; 1715 top + dy]); %#ok<AGROW>
        parts(end+1) = wire([1555 bottom + dy; 1715 bottom + dy]); %#ok<AGROW>
        parts(end+1) = wire([1785 top + dy; 1900 top + dy]); %#ok<AGROW>
        parts(end+1) = wire([1785 bottom + dy; 1900 bottom + dy]); %#ok<AGROW>
        parts(end+1) = placeicon(openCircuit, 1900, top + dy, 0.4, 0, [5.4 22.5]); %#ok<AGROW>
        parts(end+1) = placeicon(openCircuit, 1900, bottom + dy, 0.4, 0, [5.4 22.5]); %#ok<AGROW>
    end

    texSvg = typesettex(string(labels(:, 1)));
    for k = 1:size(labels, 1)
        parts(end+1) = placetex(texSvg(k), labels{k, 2}, labels{k, 3}, labels{k, 4}); %#ok<AGROW>
    end

    canvasWidth = 1960;
    canvasHeight = 600;
    header = sprintf(['<?xml version="1.0" encoding="UTF-8"?>\n' ...
        '<svg xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink" width="%d" ' ...
        'height="%d" viewBox="0 0 %d %d" role="img">\n' ...
        '<title>JVsound Toolbox 2-port network diagram</title>\n' ...
        '<rect width="100%%" height="100%%" fill="#ffffff"/>\n'], ...
        canvasWidth, canvasHeight, canvasWidth, canvasHeight);
    document = string(header) + strjoin(parts, newline) + newline + "</svg>" + newline;

    fileId = fopen(svgPath, "w", "n", "UTF-8");
    fwrite(fileId, char(document), "char");
    fclose(fileId);
    xmlread(svgPath);
end

function icon = readicon(file, ink)
    % Read the shapes of a Simscape icon and restyle them with the diagram ink
    text = fileread(file);
    styles = regexp(text, '\.(s[A-Z])\s*\{([^}]*)\}', "tokens");
    filledClasses = strings(0, 1);
    for k = 1:numel(styles)
        if contains(styles{k}{2}, "fill: #000000")
            filledClasses(end+1) = styles{k}{1}; %#ok<AGROW>
        end
    end
    shapes = regexp(text, '<(polyline|path|rect|ellipse)\>[^>]*/>', "match");
    for k = 1:numel(shapes)
        shapeClass = regexp(shapes{k}, 'class="([^"]*)"', "tokens", "once");
        isFilled = ~isempty(shapeClass) && any(shapeClass{1} == filledClasses);
        shape = regexprep(shapes{k}, '\s+(class|id|d:options)="[^"]*"', '');
        shape = regexprep(shape, '\s+', ' ');
        if isFilled
            fill = ink;
        elseif startsWith(shape, "<ellipse")
            fill = "#ffffff";
        else
            fill = "none";
        end
        style = sprintf(' fill="%s" stroke="%s" stroke-width="1.5" vector-effect="non-scaling-stroke"', fill, ink);
        shapes{k} = regexprep(shape, '^<(\w+)', ['<$1' char(style)]);
    end
    icon = strjoin(string(shapes), newline);
end

function svg = placeicon(icon, x, y, scale, angle, anchor)
    % Place an icon with its anchor point (in icon units) at x, y
    svg = sprintf('<g transform="translate(%g,%g) rotate(%g) scale(%g) translate(%g,%g)">\n%s\n</g>', ...
        x, y, angle, scale, -anchor(1), -anchor(2), icon);
end

function texSvg = typesettex(texList)
    % Typeset TeX strings to SVG with the MathJax of MATLAB, run in headless Chrome
    chrome = "C:\Program Files\Google\Chrome\Application\chrome.exe";
    mathJax = fullfile(matlabroot, "derived", "ui", "mathjax", "tex-mml-svg.js");
    fileUrl = @(file) "file:///" + replace(replace(file, "\", "/"), " ", "%20");
    html = "<!DOCTYPE html><html><head><script>window.texInput = " + jsonencode(texList) + ";" + ...
        "window.MathJax = {svg: {fontCache: 'none'}, startup: {typeset: false, ready: () => {" + ...
        "MathJax.startup.defaultReady(); MathJax.startup.promise.then(() => {" + ...
        "const out = window.texInput.map(t => MathJax.tex2svg(t, {display: false})" + ...
        ".querySelector('svg').outerHTML);" + ...
        "document.getElementById('out').textContent = JSON.stringify(out);});}}};</script>" + ...
        "<script src=""" + fileUrl(mathJax) + """></script></head>" + ...
        "<body><pre id=""out""></pre></body></html>";
    htmlFile = string(tempname) + ".html";
    fileId = fopen(htmlFile, "w", "n", "UTF-8");
    fwrite(fileId, char(html), "char");
    fclose(fileId);
    cleanup = onCleanup(@() delete(htmlFile));

    command = """" + chrome + """ --headless=new --disable-gpu --virtual-time-budget=10000 --dump-dom """ + ...
        fileUrl(htmlFile) + """";
    [status, output] = system(command);
    json = regexp(output, '<pre id="out">(.*?)</pre>', "tokens", "once");
    if status ~= 0 || isempty(json) || json{1} == ""
        error("JVsound:generatenetworkdiagramsvg:typesetFailed", "Typesetting the labels with MathJax failed.");
    end
    json = replace(json{1}, ["&lt;", "&gt;", "&quot;", "&amp;"], ["<", ">", """", "&"]);
    texSvg = string(jsondecode(json));
end

function svg = placetex(texSvg, x, y, anchor)
    % Place a typeset label with its baseline at y; one TeX em is the font size
    fontSize = 22;
    viewBox = sscanf(regexp(texSvg, 'viewBox="([^"]*)"', "tokens", "once"), "%f");
    width = viewBox(3) / 1000 * fontSize;
    height = viewBox(4) / 1000 * fontSize;
    left = x;
    if anchor == "middle"
        left = x - width / 2;
    elseif anchor == "end"
        left = x - width;
    end
    topEdge = y + viewBox(2) / 1000 * fontSize;
    openingTag = regexp(texSvg, '^<svg[^>]*>', "match", "once");
    newTag = regexprep(openingTag, '\s(width|height|style)="[^"]*"', '');
    newTag = replace(newTag, "<svg", sprintf('<svg x="%g" y="%g" width="%g" height="%g" color="#14233b"', ...
        left, topEdge, width, height));
    svg = newTag + extractAfter(texSvg, strlength(openingTag));
end

function svg = frame(left, right, dy)
    % Draw the frame of one 2-port network
    if nargin < 3
        dy = 0;
    end
    svg = string(sprintf(['<rect x="%g" y="%g" width="%g" height="250" rx="4" fill="none" stroke="#8a96a8" ' ...
        'stroke-width="1.2"/>'], left, 40 + dy, right - left));
end

function svg = twoport(left, right, dy, caption, ink)
    % Draw a 2-port network that is not detailed yet, as a block in its frame
    center = (left + right) / 2;
    svg = frame(left, right, dy) + newline + sprintf(['<rect x="%g" y="%g" width="70" height="170" rx="3" ' ...
        'fill="#ffffff" stroke="%s" stroke-width="1.5"/>'], center - 35, 85 + dy, ink);
    words = split(caption);
    for k = 1:numel(words)
        svg = svg + newline + sprintf(['<text x="%g" y="%g" text-anchor="middle" font-family="''Segoe UI'', ' ...
            'Arial, sans-serif" font-size="13" fill="#44546a">%s</text>'], center, 165 + dy + 18 * (k - 1), ...
            words(k));
    end
end
