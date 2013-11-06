function this = removeOption(this, name)

% protect the help option
if this.addhelp && isequal(name, 'help')
    return;
end

idx = strcmp({this.opts.name}, name);
this.opts(idx) = [];

end
