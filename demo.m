clear all; close all; clc;

% create option parser
p = optionParser('', 'Version', '0.1', ...
                 'Desc', 'An example of optionParser');

p = addOption(p, 'position', [], ...
              'Desc', 'simplest positional option');

p = addOption(p, 'basic', '-b', ...
              'Desc', 'option without any configuration');

p = addOption(p, 'flags', {'-m', '--multi'}, ...
              'Desc', 'option with multiple flags');

% create first subcommand parser
sp1 = optionParser('', 'Desc', 'An example of subparser');

sp1 = addOption(sp1, 'required', '-r', 'Required', true, ...
                'Desc', 'required option');

sp1 = addOption(sp1, 'default', '-d', 'Default', 'def',
                'Desc', 'option with default value');

% create second subcommand parser
sp2 = optionParser('', 'Desc', 'Another example of subparser');

sp2 = addOption(sp2, 'noarg', '--noarg', 'ArgsNum', '0', 'ConstVal', 3.14, ...
                'Desc', 'option without any argument');

sp2 = addOption(sp2, 'optional', '-o', 'ArgsNum', '?', 'ConstVal', 'const', ...
                'Desc', 'option without or with one argument');

sp2 = addOption(sp2, 'more', '--more', 'ArgsNum', '+', ...
                'Desc', 'option with one or more arguments');

sp2 = addOption(sp2, 'multiple', '--many', 'ArgsNum', '*', ...
                'Desc', 'option without or with multiple arguments');

% add subcommand parsers
p = addSubparser(p, 'foo', sp1);
p = addSubparser(p, 'bar', sp2);

% now let's parse the arguments
args = argv();
vals = parse(p, args);
fprintf('vals = %s\n', disp(vals));
