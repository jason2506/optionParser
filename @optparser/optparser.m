function this = optparser(varargin)

config = struct(varargin{:});

s = struct;
s.opts      = [];
s.prog      = getfield_default(config, 'prog', []);
s.textwitdh = getfield_default(config, 'textwidth', 80);

this = class(s, 'optparser');

end
