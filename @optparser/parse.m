function [vals, args] = parse(this, varargin)

vals = optdefaults(this);
iter = iterator(varargin);

args = [];
while ~hasnext(iter)
    [iter, arg] = next(iter);
    if ~isopt(arg)
        args{end + 1} = arg;
        continue;
    end

    % get the corresponding option instance
    opt = getopt(this, arg);
    if isempty(opt)
        error(['Unknown option: ', arg]);
    end

    name = opt.name;
    switch opt.nargs
    case '0'
        % option with no argument
        vals.(name) = opt.const;

    case '1'
        % option with exact one argument
        if hasnext(iter)
            error(['Expected one argument: ', arg]);
        end

        [iter, val] = next(iter);
        if (isopt(val))
            error(['Expected one argument: ', arg]);
        end

        vals.(name) = opt.handle(val);

    case '?'
        % option with zero or one argument
        if hasnext(iter)
            vals.(name) = opt.const;
        else
            [iter, val] = next(iter);
            if (isopt(val))
                iter = revert(iter);
                vals.(name) = opt.const;
            else
                vals.(name) = opt.handle(val);
            end
        end

    case '*'
        % option with zero or multiple arguments
        vals.(name) = [];
        while ~hasnext(iter)
            [iter, val] = next(iter);
            if (isopt(val))
                iter = revert(iter);
                break;
            end

            vals.(name){end + 1} = opt.handle(val);
        end
    end
end

% check required options
requires = this.opts([this.opts.required]);
check = isfield(vals, {requires.name});
if ~all(check)
    idx = find(~check);
    error(['Require option: ', requires(idx(1)).flags{1}]);
end

end
