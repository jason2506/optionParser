function opt = getopt(this, flag)

m = arrayfun(@(opt) ismember(flag, opt.flags), this.opts);
idx = find(m);
if isempty(idx)
    opt = [];
else
    opt = this.opts(idx(1));
end

end
