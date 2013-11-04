function this = rmopt(this, name)

N = length(this.opts);
idx = strcmp({this.opts.name}, name);
this.opts(idx) = [];

end
