function printUsage(this, fid=stdout, isbrief=false)

prog = this.prog;
if isempty(prog)
    prog = program_name;
end

% print the program name
msg = sprintf('Usage: %s', prog);
width = length(msg);
fprintf(fid, msg);

% generated decorated option name
N = length(this.opts);
optnames = {};
for n = 1:N
    opt = this.opts(n);
    name = upper(opt.name);
    switch opt.nargs
    case '0'
        optnames{n} = '';
    case '1'
        optnames{n} = [' ', name, ''];
    case '?'
        optnames{n} = [' [', name, ']'];
    case '+'
        optnames{n} = [' ', name, ' ...'];
    case '*'
        optnames{n} = [' [', name, ' ...]'];
    end
end

% print the option list (in a few lines)
totlen = width;
for n = 1:N
    opt = this.opts(n);
    if opt.required
        template = ' %s%s';
    else
        template = ' [%s%s]';
    end

    msg = sprintf(template, opt.flags{1}, optnames{n});
    totlen = totlen + length(msg);
    if totlen > this.textwidth
        totlen = width + length(msg);
        fprintf(fid, '\n%*s', width, '');
    end

    fprintf(fid, msg);
end

fprintf(fid, '\n');

if isbrief
    return;
end

fprintf(fid, '\n');

% select options which have description
idx = cellfun(@isempty, {this.opts.desc});
opts = this.opts(~idx);
N = length(opts);

% generate strings of flags (headers)
flagstrs = {};
for n = 1:N
    opt = opts(n);
    if length(opt.flags) > 1
        str = sprintf('%s, ', opt.flags{1:end - 1});
        flagstrs{n} = sprintf('%*s%s%s%s', this.identwidth, '', ...
                              str, opt.flags{end}, optnames{n});
    else
        flagstrs{n} = sprintf('%*s%s%s', this.identwidth, '', ...
                              opt.flags{1}, optnames{n});
    end
end

% calculate widths for headers and descriptions
lens = cellfun(@length, flagstrs);
flagswidth = min(max(lens) + this.padwidth, this.flagswidth);
descwidth = this.textwidth - flagswidth;

% print the option descriptions
for n = 1:N
    opt = opts(n);
    if length(flagstrs{n}) > flagswidth - this.padwidth
        fprintf(fid, '%s\n%-*s', flagstrs{n}, flagswidth, '');
    else
        fprintf(fid, '%-*s%*s', ...
                flagswidth - this.padwidth, flagstrs{n}, ...
                this.padwidth, '');
    end

    if length(opt.desc) > descwidth
        [tok, rem] = strtok(opt.desc, ' ');
        lines = {tok};
        len = length(tok);
        while ~isempty(rem)
            [tok, rem] = strtok(rem, ' ');
            toklen = length(tok);
            if len + toklen + 1 > descwidth
                lines{end + 1} = tok;
                len = toklen;
            else
                lines{end} = [lines{end}, ' ', tok];
                len = len + toklen + 1;
            end
        end

        M = length(lines);
        fprintf(fid, '%s\n', lines{1});
        for m = 2:M
            fprintf(fid, '%*s%s\n', flagswidth, '', lines{m});
        end
    else
        fprintf(fid, '%s\n', opt.desc);
    end
end

end
