clear all; close all; clc;

p = optparser;

% option without any configuration
p = addopt(p, 'basic', '-b');

% option with default value
p = addopt(p, 'default', '-d', 'default', 'foo');

% option with multiple flags
p = addopt(p, 'flags', {'-m', '--multi'});

% required option
p = addopt(p, 'required', '-r', 'required', true);

% option without any argument
p = addopt(p, 'noarg', '--noarg', 'nargs', '0');

% option without or with one argument
% if no argument given, the value will be set to 1 (const)
p = addopt(p, 'optional', '-o', 'nargs', '?', 'const', 1);

% option with one or more arguments (store in a cell array)
p = addopt(p, 'more', '--more', 'nargs', '+');

% option without or with multiple arguments (store in a cell array)
p = addopt(p, 'multiple', '--many', 'nargs', '*');

% now let's parse the arguments
args = argv();
[vals, args] = parse(p, args{:});
printf('args = %s\n', disp(args));
printf('vals = %s\n', disp(vals));
