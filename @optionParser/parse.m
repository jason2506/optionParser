function vals = parse(this, args)

vals = getOptionDefaults(this);
if isa(args, 'iterator')
    iter = args;
elseif all(cellfun(@ischar, args))
    iter = iterator(args);
else
    error('Arguments must be an iterator or a cell array of strings');
end

idx = @cellfun(@isempty, {this.Opts.Flags});
posOpts = iterator(this.Opts(idx));

breaked = false;

while hasNext(iter)
    [iter, arg] = next(iter);
    if isequal(arg, '--')
        breaked = true;
        continue;
    end

    clear val;
    if ~breaked && isFlag(arg)
        % split option flag and option argument (if any)
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
            dispError(this, 'Unknown option: %s\n', arg);
        end
    elseif hasNext(posOpts)
        [posOpts, opt] = next(posOpts);
        iter = revert(iter);
    else
        dispError(this, 'Unrecognized argument: %s\n', arg);
    end

    % get option arguments
    name = opt.Name;
    switch opt.ArgsNum
    case '0'
        % option with no argument
        if exist('val', 'var')
            if isequal(arg(2), '-')
                dispError(this, 'No argument expected: %s\n', nextFlag);
            end

            % treat all characters of `val` as the flag of options without argument
            newVal = {opt.ConstVal};
            opt = [opt];
            N = length(val);
            for n = 1:N
                flag = ['-', val(n)];
                opt(n + 1) = getOption(this, flag);
                if isempty(opt(n + 1))
                    dispError(this, 'Unknown option: %s\n', flag);
                elseif ~isequal(opt(n + 1).ArgsNum, '0')
                    dispError(this, 'Only options without argument can be joined togather: %s\n', flag);
                end

                newVal{n + 1} = opt(n + 1).ConstVal;
            end
        else
            newVal = opt.ConstVal;
        end

    case {'1', '?'}
        % option without or with one argument
        if exist('val', 'var')
            newVal = opt.HandleFunc(val);
        elseif ~hasNext(iter)
            if isequal(opt.ArgsNum, '1')
                dispError(this, 'Expected one argument: %s\n', arg);
            end

            newVal = opt.ConstVal;
        else
            [iter, val] = next(iter);
            if ~breaked && isFlag(val)
                if isequal(opt.ArgsNum, '1')
                    dispError(this, 'Expected one argument: %s\n', arg);
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
                if ~breaked && isFlag(val)
                    iter = revert(iter);
                    break;
                end

                argList{end + 1} = val;
            end
        end

        if isequal(opt.ArgsNum, '+') && isempty(argList)
            dispError(this, 'Expected one or more arguments: %s\n', arg);
        end

        newVal = opt.HandleFunc(argList);
    end

    if length(opt) == 1
        newVal = {newVal};
    end

    % perform option action
    N = length(opt);
    for n = 1:N
        name = opt(n).Name;
        switch opt(n).Action
        case 'store'
            vals.(name) = newVal{n};

        case 'append'
            if ~isfield(vals, name)
                vals.(name) = {};
            end

            vals.(name){end + 1} = newVal{n};

        otherwise
            if isfield(vals, name)
                oldVal = vals.(name);
            else
                oldVal = [];
            end

            [vals, iter] = opt(n).Action(this, vals, iter, newVal{n});
        end
    end
end

% check required options
requiredOpts = this.Opts([this.Opts.Required]);
check = isfield(vals, {requiredOpts.Name});
if ~all(check)
    idx = find(~check);
    opt = requiredOpts(idx(1));
    if isempty(opt.Flags)
        dispError(this, 'Require option: %s\n', upper(opt.Name));
    else
        dispError(this, 'Require option: %s\n', opt.Flags{1});
    end
end

end
