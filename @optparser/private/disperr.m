function disperr(this, templ, varargin)

fprintf(stderr, templ, varargin{:});
display(this, stderr);
exit(1);

end
