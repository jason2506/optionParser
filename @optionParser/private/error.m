function error(this, template, varargin)

fprintf(stderr, template, varargin{:});
printUsage(this, stderr, true);
exit(1);

end
