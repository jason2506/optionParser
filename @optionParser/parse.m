function [vals, args] = parse(this, varargin)

vals = getOptionDefaults(this);
iter = iterator(varargin);

args = {};
while hasNext(iter)
    [iter, arg] = next(iter);
    if ~isFlag(arg)
        args{end + 1} = arg;
        continue;
    end

    if isequal(arg, '--')
        args = [args, remains(iter)];
        break;
    end

    % get the corresponding option instance
    opt = getOption(this, arg);
    if isempty(opt)
        error(this, 'Unknown option: %s\n', arg);
    end

    if isequal(opt.Action, 'help')
        printUsage(this);
        exit(0);
    elseif isequal(opt.Action, 'version')
        prog = this.Prog;
        if isempty(prog)
            prog = program_name;
        end

        fprintf(stdout, '%s version %s', prog, this.Version);
        exit(0);
    end

    name = opt.Name;
    switch opt.ArgsNum
    case '0'
        % option with no argument
        newVal = opt.ConstVal;

    case {'1', '?'}
        % option without or with one argument
        if ~hasNext(iter)
            if isequal(opt.ArgsNum, '1')
                error(this, 'Expected one argument: %s\n', arg);
            end

            newVal = opt.ConstVal;
        else
            [iter, val] = next(iter);
            if isFlag(val)
                if isequal(opt.ArgsNum, '1')
                    error(this, 'Expected one argument: %s\n', arg);
                end

                iter = revert(iter);
                newVal = opt.ConstVal;
            else
                newVal = opt.HandleFunc(val);
            end
        end

    case {'+', '*'}
        % option without or more arguments
        argList = [];
        while hasNext(iter)
            [iter, val] = next(iter);
            if (isFlag(val))
                iter = revert(iter);
                break;
            end

            argList{end + 1} = val;
        end

        if isequal(opt.ArgsNum, '+') && isempty(argList)
            error(this, 'Expected one or more argument: %s\n', arg);
        end

        newVal = opt.HandleFunc(argList);
    end

    switch opt.Action
    case 'store'
        vals.(name) = newVal;

    case 'append'
        if ~isfield(vals, name)
            vals.(name) = {};
        end

        vals.(name) = [vals.(name), newVal];
    end
end

% check required options
requiredOpts = this.Opts([this.Opts.Required]);
check = isfield(vals, {requiredOpts.Name});
if ~all(check)
    idx = find(~check);
    error(this, 'Require option: %s\n', requiredOpts(idx(1)).Flags{1});
end

end
