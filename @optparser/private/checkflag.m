function bool = checkflag(flag)

bool = ischar(flag) && regexp(flag, '^(-[A-Za-z]|--[A-Za-z]+(-[A-Za-z]+)*)$');

end
