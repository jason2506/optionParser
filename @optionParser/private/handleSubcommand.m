function [vals, iter] = handleSubcommand(this, vals, iter, errorFunc, val)

idx = strcmp({this.Subparsers.Name}, val);
if ~any(idx)
    if ~errorFunc(this, this.ErrorCodes.UnknownCmd, val)
        iter = toEnd(iter);
    end

    return;
end

p = this.Subparsers(idx).Parser;
vals.(this.SubcmdOptName) = val;
newVals = parse(p, iter);
names = fieldnames(newVals);
N = length(names);
for n = 1:N
    vals.(names{n}) = newVals.(names{n});
end

iter = toEnd(iter);

end
