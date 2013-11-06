function error(this, templ, varargin)

fprintf(stderr, templ, varargin{:});
printUsage(this, stderr, true);
exit(1);

end
