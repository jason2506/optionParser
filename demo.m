clear all; close all; clc;

p = optionParser;

p = addOption(p, 'basic', '-b', ...
              'Desc', 'option without any configuration');

p = addOption(p, 'default', '-d', 'Default', 'foo',
              'Desc', 'option with default value');

p = addOption(p, 'flags', {'-m', '--multi'}, ...
              'Desc', 'option with multiple flags');

p = addOption(p, 'required', '-r', 'Required', true, ...
              'Desc', 'required option');

p = addOption(p, 'noarg', '--noarg', 'ArgsNum', '0', 'ConstVal', 3.14, ...
              'Desc', 'option without any argument');

p = addOption(p, 'optional', '-o', 'ArgsNum', '?', 'ConstVal', 'foo', ...
              'Desc', 'option without or with one argument');

p = addOption(p, 'more', '--more', 'ArgsNum', '+', ...
              'Desc', 'option with one or more arguments');

p = addOption(p, 'multiple', '--many', 'ArgsNum', '*', ...
              'Desc', 'option without or with multiple arguments');

% now let's parse the arguments
args = argv();
[vals, args] = parse(p, args{:});
printf('args = %s\n', disp(args));
printf('vals = %s\n', disp(vals));
