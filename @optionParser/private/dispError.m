function dispError(this, msg, arg)

fprintf(stderr, '%s: %s\n', msg, arg);
printUsage(this, stderr, true);
exit(1);

end
