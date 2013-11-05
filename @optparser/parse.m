function [vals, args] = parse(this, varargin)

vals = optdefaults(this);
iter = iterator(varargin);

args = [];
while ~hasnext(iter)
    [iter, arg] = next(iter);
    if ~isflag(arg)
        args{end + 1} = arg;
        continue;
    end

    % get the corresponding option instance
    opt = getopt(this, arg);
    if isempty(opt)
        disperr(this, 'Unknown option: %s\n', arg);
    end

    name = opt.name;
    switch opt.nargs
    case '0'
        % option with no argument
        vals.(name) = opt.const;

    case '1'
        % option with exact one argument
        if hasnext(iter)
            disperr(this, 'Expected one argument: %s\n', arg);
        end

        [iter, val] = next(iter);
        if (isflag(val))
            disperr(this, 'Expected one argument: %s\n', arg);
        end

        vals.(name) = opt.handle(val);

    case '?'
        % option without or with one argument
        if hasnext(iter)
            vals.(name) = opt.const;
        else
            [iter, val] = next(iter);
            if (isflag(val))
                iter = revert(iter);
                vals.(name) = opt.const;
            else
                vals.(name) = opt.handle(val);
            end
        end

    case '+'
        % option with one or more arguments
        vals.(name) = {};
        while ~hasnext(iter)
            [iter, val] = next(iter);
            if (isflag(val))
                iter = revert(iter);
                break;
            end

            vals.(name){end + 1} = opt.handle(val);
        end

        if isempty(vals.(name))
            disperr(this, 'Expected one or more argument: %s\n', arg);
        end

    case '*'
        % option without or with multiple arguments
        vals.(name) = [];
        while ~hasnext(iter)
            [iter, val] = next(iter);
            if (isflag(val))
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
    disperr(this, 'Require option: %s\n', requires(idx(1)).flags{1});
end

end
