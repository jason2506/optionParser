function lines = wrapLines(text, width)

if length(text) <= width
    lines = {text};
    return;
end

[tok, rem] = strtok(text, ' ');
lines = {tok};
totLength = length(tok);
while ~isempty(rem)
    [tok, rem] = strtok(rem, ' ');
    tokLength = length(tok);
    if totLength + tokLength + 1 > width
        lines{end + 1} = tok;
        totLength = tokLength;
    else
        lines{end} = [lines{end}, ' ', tok];
        totLength = totLength + tokLength + 1;
    end
end

end
