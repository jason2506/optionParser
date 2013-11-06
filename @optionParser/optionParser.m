function this = optionParser(varargin)

p = inputParser;
p.FunctionName = 'optionParser';
p = p.addOptional('prog', '', @ischar);
p = p.addParamValue('addhelp', true, @islogical);
p = p.addParamValue('textwidth', 80, @isnumeric);
p = p.addParamValue('flagswidth', 24, @isnumeric);
p = p.addParamValue('padwidth', 2, @isnumeric);
p = p.addParamValue('identwidth', 2, @isnumeric);
p = p.parse(varargin{:});

s = p.Results;
s.opts = [];

this = class(s, 'optionParser');
if s.addhelp
    this = addOption(this, 'help', {'-h', '--help'}, 'nargs', '0', ...
                     'desc', 'show this help message and exit');
end

end
