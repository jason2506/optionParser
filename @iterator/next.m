function [this, val] = next(this)

if ~hasNext(this)
    error('There are no additional items');
end

this.ptr = this.ptr + 1;
if iscell(this.cells)
    val = this.cells{this.ptr};
else
    val = this.cells(this.ptr);
end

end
