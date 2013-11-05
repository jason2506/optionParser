function [vals, args] = parse(this, varargin)

vals = optdefaults(this);
iter = iterator(varargin);

args = [];
while hasnext(iter)
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

    case {'1', '?'}
        % option without or with one argument
        if ~hasnext(iter)
            if isequal(opt.nargs, '1')
                disperr(this, 'Expected one argument: %s\n', arg);
            end

            vals.(name) = opt.const;
        else
            [iter, val] = next(iter);
            if isflag(val)
                if isequal(opt.nargs, '1')
                    disperr(this, 'Expected one argument: %s\n', arg);
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
        while hasnext(iter)
            [iter, val] = next(iter);
            if (isflag(val))
                iter = revert(iter);
                break;
            end

            arglist{end + 1} = val;
        end

        if isequal(opt.nargs, '+') && isempty(arglist)
            disperr(this, 'Expected one or more argument: %s\n', arg);
        end

        vals.(name) = opt.handle(arglist);
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
