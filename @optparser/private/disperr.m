function disperr(this, templ, varargin)

fprintf(stderr, templ, varargin{:});
display(this, stderr, true);
exit(1);

end
