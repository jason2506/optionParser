function this = rmopt(this, name)

idx = strcmp({this.opts.name}, name);
this.opts(idx) = [];

end
