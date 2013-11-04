function display(this, fid=stdout)

prog = this.prog;
if isempty(prog)
    prog = program_name;
end
fprintf(fid, 'Usage: %s', prog);

N = length(this.opts);
for n = 1:N
    opt = this.opts(n);
    if opt.required
        fprintf(fid, ' %s', opt.flags{1});
    else
        fprintf(fid, ' [%s', opt.flags{1});
    end

    switch opt.nargs
    case '1'
        fprintf(fid, ' <%s>', opt.name);
    case '?'
        fprintf(fid, ' [<%s>]', opt.name);
    case '*'
        fprintf(fid, ' [<%s> ...]', opt.name);
    end

    if ~opt.required
        fprintf(fid, ']');
    end
end

end
