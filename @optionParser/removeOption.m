function this = removeOption(this, name)

idx = strcmp({this.Opts.name}, name);
this.Opts(idx) = [];

end
