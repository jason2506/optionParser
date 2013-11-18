function vals = parse(this, args, errorFunc)

vals = getOptionDefaults(this);
if isa(args, 'iterator')
    iter = args;
elseif all(cellfun(@ischar, args))
    iter = iterator(args);
else
    error('Arguments must be an iterator or a cell array of strings');
end

if ~exist('errorFunc', 'var')
    errorFunc = @dispError;
elseif ~is_function_handle(errorFunc)
    error('Error handler must be a function');
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
            if errorFunc(this, this.ErrorCodes.UnknownOpt, arg)
                continue;
            else
                return;
            end
        end
    elseif hasNext(posOpts)
        [posOpts, opt] = next(posOpts);
        iter = revert(iter);
    elseif errorFunc(this, this.ErrorCodes.UnknownArg, arg)
        continue;
    else
        return;
    end

    % get option arguments
    name = opt.Name;
    switch opt.ArgsNum
    case '0'
        % option with no argument
        if exist('val', 'var')
            if isequal(arg(2), '-')
                if errorFunc(this, this.ErrorCodes.ExceptNoArg, nextFlag)
                    continue;
                else
                    return;
                end
            end

            % treat all characters of `val` as the flag of options without argument
            newVal = {opt.ConstVal};
            opt = [opt];
            N = length(val);
            for n = 1:N
                flag = ['-', val(n)];
                opt(n + 1) = getOption(this, flag);
                if isempty(opt(n + 1))
                    if errorFunc(this, this.ErrorCodes.UnknownOpt, flag)
                        continue;
                    else
                        return;
                    end
                elseif ~isequal(opt(n + 1).ArgsNum, '0')
                    if errorFunc(this, this.ErrorCodes.InvalidJoinedOpts, flag)
                        continue;
                    else
                        return;
                    end
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
                if errorFunc(this, this.ErrorCodes.ExceptOneArg, arg)
                    continue;
                else
                    return;
                end
            end

            newVal = opt.ConstVal;
        else
            [iter, val] = next(iter);
            if ~breaked && isFlag(val)
                if isequal(opt.ArgsNum, '1')
                    if errorFunc(this, this.ErrorCodes.ExceptOneArg, arg)
                        iter = revert(iter);
                        continue;
                    else
                        return;
                    end
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
            if errorFunc(this, this.ErrorCodes.ExceptAtLeastOneArg, arg)
                continue;
            else
                return;
            end
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

            [vals, iter] = opt(n).Action(this, vals, iter, errorFunc, newVal{n});
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
        name = upper(opt.Name);
    else
        name = opt.Flags{1};
    end

    errorFunc(this, this.ErrorCodes.RequireOpt, name);
end

end
