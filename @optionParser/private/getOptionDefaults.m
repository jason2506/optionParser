function vals = getOptionDefaults(this)

vals = struct;

idx = cellfun(@isempty, {this.Opts.Default});
defaults = this.Opts(~idx);
N = length(defaults);
for n = 1:N
    vals.(defaults(n).Name) = defaults(n).Default;
end

end
