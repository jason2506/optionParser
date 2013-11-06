function [vals, args] = parse(this, varargin)

vals = getOptionDefaults(this);
iter = iterator(varargin);

args = [];
while hasNext(iter)
    [iter, arg] = next(iter);
    if ~isFlag(arg)
        args{end + 1} = arg;
        continue;
    end

    if this.addhelp && (isequal(arg, '-h') || isequal(arg, '--help'))
        printUsage(this);
        exit(0);
    end

    % get the corresponding option instance
    opt = getOption(this, arg);
    if isempty(opt)
        error(this, 'Unknown option: %s\n', arg);
    end

    name = opt.name;
    switch opt.nargs
    case '0'
        % option with no argument
        vals.(name) = opt.const;

    case {'1', '?'}
        % option without or with one argument
        if ~hasNext(iter)
            if isequal(opt.nargs, '1')
                error(this, 'Expected one argument: %s\n', arg);
            end

            vals.(name) = opt.const;
        else
            [iter, val] = next(iter);
            if isFlag(val)
                if isequal(opt.nargs, '1')
                    error(this, 'Expected one argument: %s\n', arg);
                end

                iter = revert(iter);
                vals.(name) = opt.const;
            else
                vals.(name) = opt.handle(val);
            end
        end

    case {'+', '*'}
        % option without or more arguments
        arglist = [];
        while hasNext(iter)
            [iter, val] = next(iter);
            if (isFlag(val))
                iter = revert(iter);
                break;
            end

            arglist{end + 1} = val;
        end

        if isequal(opt.nargs, '+') && isempty(arglist)
            error(this, 'Expected one or more argument: %s\n', arg);
        end

        vals.(name) = opt.handle(arglist);
    end
end

% check required options
requires = this.opts([this.opts.required]);
check = isfield(vals, {requires.name});
if ~all(check)
    idx = find(~check);
    error(this, 'Require option: %s\n', requires(idx(1)).flags{1});
end

end
