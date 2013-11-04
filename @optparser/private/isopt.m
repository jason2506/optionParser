function bool = isopt(arg)

bool = (~isempty(arg) && arg(1) == '-');

end
