function [vals, args] = parse(this, varargin)

vals = getOptionDefaults(this);
iter = iterator(varargin);

args = {};
while hasNext(iter)
    [iter, arg] = next(iter);
    if ~isFlag(arg)
        args{end + 1} = arg;
        continue;
    elseif isequal(arg, '--')
        args = [args, remains(iter)];
        break;
    end

    % split option flag and option argument (if any)
    clear val;
    if length(arg) > 2
        if ~isequal(arg(1:2), '--')
            % `-xabc` => `-x abc`
            val = arg(3:end);
            arg = arg(1:2);
        elseif index(arg, '=') > 0
            % `--foo=bar` => `--foo bar`
            [arg, val] = strtok(arg, '=');
            val = val(2:end);
        end
    end

    % get the corresponding option instance
    opt = getOption(this, arg);
    if isempty(opt)
        error(this, 'Unknown option: %s\n', arg);
    end

    % get option arguments
    name = opt.Name;
    switch opt.ArgsNum
    case '0'
        % option with no argument
        if exist('val', 'var')
            error(this, 'No argument expected: %s\n', arg);;
        end

        newVal = opt.ConstVal;

    case {'1', '?'}
        % option without or with one argument
        if exist('val', 'var')
            newVal = opt.HandleFunc(val);
        elseif ~hasNext(iter)
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
        if exist('val', 'var')
            argList = {val};
        else
            argList = {};
            while hasNext(iter)
                [iter, val] = next(iter);
                if (isFlag(val))
                    iter = revert(iter);
                    break;
                end

                argList{end + 1} = val;
            end
        end

        if isequal(opt.ArgsNum, '+') && isempty(argList)
            error(this, 'Expected one or more arguments: %s\n', arg);
        end

        newVal = opt.HandleFunc(argList);
    end

    % perform option action
    switch opt.Action
    case 'store'
        vals.(name) = newVal;

    case 'append'
        if ~isfield(vals, name)
            vals.(name) = {};
        end

        vals.(name){end + 1} = newVal;

    otherwise
        if isfield(vals, name)
            oldVal = vals.(name);
        else
            oldVal = [];
        end

        vals.(name) = opt.Action(this, newVal, oldVal);
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
