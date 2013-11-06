function this = optionParser(varargin)

p = inputParser;
p.FunctionName = 'optionParser';
p = p.addOptional('Prog', '', @ischar);
p = p.addParamValue('AddHelp', true, @islogical);
p = p.addParamValue('TextWidth', 80, @isnumeric);
p = p.addParamValue('HeaderWidth', 24, @isnumeric);
p = p.addParamValue('PaddingWidth', 2, @isnumeric);
p = p.addParamValue('IndentWidth', 2, @isnumeric);
p = p.parse(varargin{:});

s = p.Results;
s.Opts = [];

this = class(s, 'optionParser');
if s.AddHelp
    this = addOption(this, 'help', {'-h', '--help'}, 'ArgsNum', '0', ...
                     'Desc', 'show this help message and exit');
end

end
