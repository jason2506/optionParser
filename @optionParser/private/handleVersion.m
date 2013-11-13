function [vals, iter] = handleVersion(this, vals, iter, val)

prog = this.Prog;
if isempty(prog)
    prog = program_name;
end

fprintf(stdout, '%s version %s', prog, this.Version);
exit(0);

end
