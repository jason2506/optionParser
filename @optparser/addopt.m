function this = addopt(this, name, flags, varargin)

config = struct(varargin{:});

% check option name
if length(this.opts) > 0 && ismember({this.opts.name}, name)
    error(['Conflicting option name: ', name]);
end

% check flags
if ischar(flags)
    flags = {flags};
elseif ~iscell(flags)
    error('Flags must be a cell array of strings');
elseif length(flags) == 0
    error('Require at least one flag');
end

if length(this.opts) > 0
    m = ismember(flags, [this.opts.flags]);
    idx = find(m);
    if ~isempty(idx)
        error(['Conflicting option flag: ', flags{idx}]);
    end
end

opt = struct;
opt.name        = name;
opt.flags       = unique(flags);
opt.required    = getfield_default(config, 'required',  false);
opt.default     = getfield_default(config, 'default',   []);
opt.const       = getfield_default(config, 'const',     []);
opt.nargs       = getfield_default(config, 'nargs',     '1');
opt.handle      = getfield_default(config, 'handle',    @(v) v);
opt.desc        = getfield_default(config, 'desc',      []);

if ~ischar(opt.nargs) || length(opt.nargs) ~= 1 || ~ismember(opt.nargs, '01?*')
    error('Invalid nargs option');
end

this.opts(end + 1) = opt;

end
