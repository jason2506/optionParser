function vals = parse(this, varargin)

vals = getOptionDefaults(this);
iter = iterator(varargin);

idx = @cellfun(@isempty, {this.Opts.Flags});
posOpts = this.Opts(idx);
posIdx = 1;

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
            error(this, 'Unknown option: %s\n', arg);
        end
    else
        if posIdx > length(posOpts)
            error(this, 'Unrecognized argument: %s\n', arg);
        end

        opt = posOpts(posIdx);
        posIdx = posIdx + 1;
        iter = revert(iter);
    end

    % get option arguments
    name = opt.Name;
    switch opt.ArgsNum
    case '0'
        % option with no argument
        if exist('val', 'var')
            if isequal(arg(2), '-')
                error(this, 'No argument expected: %s\n', nextFlag);
            end

            % treat all characters of `val` as the flag of options without argument
            newVal = {opt.ConstVal};
            opt = [opt];
            N = length(val);
            for n = 1:N
                flag = ['-', val(n)];
                opt(n + 1) = getOption(this, flag);
                if isempty(opt(n + 1))
                    error(this, 'Unknown option: %s\n', flag);
                elseif ~isequal(opt(n + 1).ArgsNum, '0')
                    error(this, 'Only options without argument can be joined togather: %s\n', flag);
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
                error(this, 'Expected one argument: %s\n', arg);
            end

            newVal = opt.ConstVal;
        else
            [iter, val] = next(iter);
            if ~breaked && isFlag(val)
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
                if ~breaked && isFlag(val)
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

            vals.(name) = opt(n).Action(this, newVal{n}, oldVal);
        end
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
