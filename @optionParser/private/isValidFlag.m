function bool = isValidFlag(flag)

bool = ischar(flag) && regexp(flag, '^-([A-Za-z]|-[A-Za-z]+(-[A-Za-z]+)+|-[A-Za-z]{2,})$');

end
