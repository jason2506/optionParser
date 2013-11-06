function printUsage(this, fid=stdout, isBrief=false)

prog = this.Prog;
if isempty(prog)
    prog = program_name;
end

% print the program name
msg = sprintf('Usage: %s', prog);
width = length(msg);
fprintf(fid, msg);

% generated decorated option name
N = length(this.Opts);
optNames = {};
for n = 1:N
    opt = this.Opts(n);
    name = upper(opt.Name);
    switch opt.ArgsNum
    case '0'
        optNames{n} = '';
    case '1'
        optNames{n} = [' ', name, ''];
    case '?'
        optNames{n} = [' [', name, ']'];
    case '+'
        optNames{n} = [' ', name, ' ...'];
    case '*'
        optNames{n} = [' [', name, ' ...]'];
    end
end

% print the option list (in a few lines)
totLength = width;
for n = 1:N
    opt = this.Opts(n);
    if opt.Required
        template = ' %s%s';
    else
        template = ' [%s%s]';
    end

    msg = sprintf(template, opt.Flags{1}, optNames{n});
    totLength = totLength + length(msg);
    if totLength > this.TextWidth
        totLength = width + length(msg);
        fprintf(fid, '\n%*s', width, '');
    end

    fprintf(fid, msg);
end

fprintf(fid, '\n');

if isBrief
    return;
end

fprintf(fid, '\n');

% select options which have description
idx = cellfun(@isempty, {this.Opts.Desc});
opts = this.Opts(~idx);
N = length(opts);

% generate strings of flags (headers)
headers = {};
for n = 1:N
    opt = opts(n);
    if length(opt.Flags) > 1
        str = sprintf('%s, ', opt.Flags{1:end - 1});
        headers{n} = sprintf('%*s%s%s%s', this.IndentWidth, '', ...
                             str, opt.Flags{end}, optNames{n});
    else
        headers{n} = sprintf('%*s%s%s', this.IndentWidth, '', ...
                             opt.Flags{1}, optNames{n});
    end
end

% calculate widths for headers and descriptions
lengths = cellfun(@length, headers);
headerWidth = min(max(lengths) + this.PaddingWidth, this.HeaderWidth);
descWidth = this.TextWidth - headerWidth;

% print the option descriptions
for n = 1:N
    opt = opts(n);
    if length(headers{n}) > headerWidth - this.PaddingWidth
        fprintf(fid, '%s\n%-*s', headers{n}, headerWidth, '');
    else
        fprintf(fid, '%-*s%*s', ...
                headerWidth - this.PaddingWidth, headers{n}, ...
                this.PaddingWidth, '');
    end

    if length(opt.Desc) > descWidth
        [tok, rem] = strtok(opt.Desc, ' ');
        lines = {tok};
        totLength = length(tok);
        while ~isempty(rem)
            [tok, rem] = strtok(rem, ' ');
            tokLength = length(tok);
            if totLength + tokLength + 1 > descWidth
                lines{end + 1} = tok;
                totLength = tokLength;
            else
                lines{end} = [lines{end}, ' ', tok];
                totLength = totLength + tokLength + 1;
            end
        end

        M = length(lines);
        fprintf(fid, '%s\n', lines{1});
        for m = 2:M
            fprintf(fid, '%*s%s\n', headerWidth, '', lines{m});
        end
    else
        fprintf(fid, '%s\n', opt.Desc);
    end
end

end
