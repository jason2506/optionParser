function bool = isnargs(nargs)

bool = ischar(nargs) && length(nargs) == 1 && ismember(nargs, '01?+*');

end
