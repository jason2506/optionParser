function this = removeOption(this, name)

% protect the help option
if this.AddHelp && isequal(name, 'help')
    return;
end

idx = strcmp({this.Opts.name}, name);
this.Opts(idx) = [];

end
