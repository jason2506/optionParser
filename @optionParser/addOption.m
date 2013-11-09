function this = addOption(this, name, flags, varargin)

% check option name
if ~ischar(name) || ~isvarname(name)
    error(['Invalid option name: ', name]);
elseif ~isempty(this.Opts) && ismember(name, {this.Opts.Name})
    error(['Conflicting option name: ', name]);
end

% check flags
if ischar(flags)
    flags = {flags};
elseif ~iscell(flags)
    error('Flags must be a cell array of strings');
elseif isempty(flags)
    error('Require at least one flag');
end

if ~isempty(this.Opts)
    m = ismember(flags, [this.Opts.Flags]);
    idx = find(m);
    if ~isempty(idx)
        error(['Conflicting option flag: ', flags{idx}]);
    end

    b = cellfun(@isValidFlag, flags);
    idx = find(~b);
    if ~isempty(idx)
        error(['Invalid flag: ', flags{idx}]);
    end
end

p = inputParser;
p.FunctionName = 'addOption';
p = p.addParamValue('HandleFunc',   @(v) v,     @is_function_handle);
p = p.addParamValue('Desc',         '',         @ischar);
p = p.addParamValue('Required',     false,      @islogical);
p = p.addParamValue('ArgsNum',      '1',        @isValidArgsNum);
p = p.addParamValue('Action',       'store',    @isValidAction);
p = p.addParamValue('Default',      []);
p = p.addParamValue('ConstVal',     []);
p = p.parse(varargin{:});

opt = p.Results;
opt.Name = name;
opt.Flags = flags;

this.Opts(end + 1) = opt;

end
