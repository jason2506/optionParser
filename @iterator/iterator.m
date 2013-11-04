function this = iterator(cells)

s = struct;
s.ptr = 0;
s.cells = cells;

this = class(s, 'iterator');

end
