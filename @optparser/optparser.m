function this = optparser(prog=[])

s = struct;
s.prog = prog;
s.opts = [];

this = class(s, 'optparser');

end
