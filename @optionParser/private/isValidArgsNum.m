function bool = isValidArgsNum(argsNum)

bool = ischar(argsNum) && length(argsNum) == 1 && ismember(argsNum, '01?+*');

end
