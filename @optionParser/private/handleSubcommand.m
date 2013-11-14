function [vals, iter] = handleSubcommand(this, vals, iter, val)

idx = strcmp({this.Subparsers.Name}, val);
if ~any(idx)
    dispError(this, 'Unknown subcommand: %s\n', val);
end

p = this.Subparsers(idx).Parser;
newVals = parse(p, iter);
names = fieldnames(newVals);
N = length(names);
for n = 1:N
    vals.(names{n}) = newVals.(names{n});
end

vals.subcommand = val;
iter = toEnd(iter);

end
