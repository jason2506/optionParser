function [this, val] = next(this)

if hasnext(this)
    error('There are no additional items');
end

this.ptr = this.ptr + 1;
val = this.cells{this.ptr};

end
