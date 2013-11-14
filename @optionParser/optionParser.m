function this = optionParser(varargin)

p = inputParser;
p.FunctionName = 'optionParser';

p = p.addOptional  ('Prog',             '',         @ischar);
p = p.addParamValue('Desc',             '',         @ischar);

p = p.addParamValue('SubcmdOptName',    'command',  @ischar);

p = p.addParamValue('TextWidth',        80,         @isnumeric);
p = p.addParamValue('HeaderWidth',      24,         @isnumeric);
p = p.addParamValue('PaddingWidth',     2,          @isnumeric);
p = p.addParamValue('IndentWidth',      2,          @isnumeric);

p = p.addParamValue('HelpOptFlags',     {'-h', '--help'});
p = p.addParamValue('HelpOptDesc',      '',         @ischar);

p = p.addParamValue('VersionOptFlags',  {'-v', '--version'});
p = p.addParamValue('VersionOptDesc',   '',         @ischar);
p = p.addParamValue('Version',          '',         @ischar);

p = p.parse(varargin{:});

s = orderfields(p.Results);
s.Opts = [];
s.Subparsers = [];
this = class(s, 'optionParser');

if ~isempty(this.HelpOptFlags)
    this = addOption(this, 'help', s.HelpOptFlags, 'ArgsNum', '0', ...
                     'Desc', this.HelpOptDesc, 'Action', @handleHelp);
end

if ~isempty(s.Version) && ~isempty(this.VersionOptFlags)
    this = addOption(this, 'version', s.VersionOptFlags, 'ArgsNum', '0', ...
                     'Desc', this.VersionOptDesc, 'Action', @handleVersion);
end

end
