function opt = getOption(this, flag)

m = arrayfun(@(opt) ismember(flag, opt.Flags), this.Opts);
idx = find(m);
if isempty(idx)
    opt = [];
else
    opt = this.Opts(idx(1));
end

end
