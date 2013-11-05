function this = optparser(varargin)

p = inputParser;
p.FunctionName = 'optparser';
p = p.addOptional('prog', '', @ischar);
p = p.addParamValue('addhelp', true, @islogical);
p = p.addParamValue('textwidth', 80, @isnumeric);
p = p.addParamValue('flagswidth', 24, @isnumeric);
p = p.addParamValue('padwidth', 2, @isnumeric);
p = p.addParamValue('identwidth', 2, @isnumeric);
p = p.parse(varargin{:});

s = p.Results;
s.opts = [];

this = class(s, 'optparser');
if s.addhelp
    this = addopt(this, 'help', {'-h', '--help'}, 'nargs', '0', ...
                  'desc', 'show this help message and exit');
end

end
