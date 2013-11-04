function display(this, fid=stdout)

prog = this.prog;
if isempty(prog)
    prog = program_name;
end

msg = sprintf('Usage: %s', prog);
len = length(msg);
fprintf(fid, msg);

N = length(this.opts);
totlen = len;
for n = 1:N
    msg = ' ';
    opt = this.opts(n);
    if opt.required
        msg = [msg, opt.flags{1}];
    else
        msg = [msg, '[', opt.flags{1}];
    end

    switch opt.nargs
    case '1'
        msg = [msg, ' <', opt.name, '>'];
    case '?'
        msg = [msg, ' [<', opt.name, '>]'];
    case '*'
        msg = [msg, ' [<', opt.name, '> ...]'];
    end

    if ~opt.required
        msg = [msg, ']'];
    end

    totlen = totlen + length(msg);
    if totlen > 80
        totlen = len + length(msg);
        s = sprintf('\n%%%ds', len);
        fprintf(fid, s, '');
    end

    fprintf(fid, msg);
end

end
