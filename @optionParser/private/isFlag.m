function bool = isFlag(arg)

bool = (~isempty(arg) && arg(1) == '-');

end
