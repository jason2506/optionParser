function vals = getOptionDefaults(this)

vals = struct;

idx = cellfun(@isempty, {this.opts.default});
defaults = this.opts(~idx);
N = length(defaults);
for n = 1:N
    vals.(defaults(n).name) = defaults(n).default;
end

end
