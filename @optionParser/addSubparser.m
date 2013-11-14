function this = addSubparser(this, name, parser)

% check parser name
if ~ischar(name) || ~isvarname(name)
    error(['Invalid parser name: ', name]);
elseif ~isempty(this.Subparsers) && ismember(name, {this.Subparsers.Name})
    error(['Conflicting parser name: ', name]);
end

% check parser instance
if ~isa(parser, class(this))
    error('Parser must be an instance of optionParser');
end

if isempty(parser.Prog)
    prog = this.Prog;
    if isempty(prog)
        prog = program_name;
    end

    parser.Prog = sprintf('%s %s', prog, name);
end

this.Subparsers(end + 1) = struct('Name', name, 'Parser', parser);

% add subcommand option if it is not exist
if ~ismember(this.SubcmdOptName, {this.Opts.Name})
    this = addOption(this, this.SubcmdOptName, [], 'ArgsNum', '1', ...
                     'Action', @handleSubcommand);
end

end
