clear all; close all; clc;

p = optparser;

p = addopt(p, 'basic', '-b', ...
           'desc', 'option without any configuration');

p = addopt(p, 'default', '-d', 'default', 'foo',
           'desc', 'option with default value');

p = addopt(p, 'flags', {'-m', '--multi'}, ...
           'desc', 'option with multiple flags');

p = addopt(p, 'required', '-r', 'required', true, ...
           'desc', 'required option');

p = addopt(p, 'noarg', '--noarg', 'nargs', '0', 'const', 3.14, ...
           'desc', 'option without any argument');

p = addopt(p, 'optional', '-o', 'nargs', '?', 'const', 'foo', ...
           'desc', 'option without or with one argument');

p = addopt(p, 'more', '--more', 'nargs', '+', ...
           'desc', 'option with one or more arguments');

p = addopt(p, 'multiple', '--many', 'nargs', '*', ...
           'desc', 'option without or with multiple arguments');

% now let's parse the arguments
args = argv();
[vals, args] = parse(p, args{:});
printf('args = %s\n', disp(args));
printf('vals = %s\n', disp(vals));
