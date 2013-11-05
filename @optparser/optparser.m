function this = optparser(varargin)

p = inputParser;
p.FunctionName = 'optparser';
p = p.addOptional('prog', '', @ischar);
p = p.addParamValue('textwidth', 80, @isnumeric);
p = p.parse(varargin{:});

s = p.Results;
s.opts = [];

this = class(s, 'optparser');

end
