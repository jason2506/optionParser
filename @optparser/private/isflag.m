function bool = isflag(arg)

bool = (~isempty(arg) && arg(1) == '-');

end
