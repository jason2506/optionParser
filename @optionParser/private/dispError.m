function dispError(this, code, arg)

switch code
case this.ErrorCodes.UnknownOpt
    msg = 'Unknown option';
case this.ErrorCodes.UnknownArg
    msg = 'Unrecognized argument';
case this.ErrorCodes.RequireOpt
    msg = 'Require option';
case this.ErrorCodes.ExceptNoArg
    msg = 'No argument expected';
case this.ErrorCodes.ExceptOneArg
    msg = 'Expected one argument';
case this.ErrorCodes.ExceptAtLeastOneArg
    msg = 'Expected at least one argument';
case this.ErrorCodes.InvalidJoinedOpts
    msg = 'Only options without argument can be joined togather';
end

fprintf(stderr, '%s: %s\n', msg, arg);
printUsage(this, stderr, true);
exit(1);

end
