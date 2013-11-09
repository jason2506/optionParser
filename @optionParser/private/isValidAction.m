function bool = isValidAction(action)

bool = ischar(action) && ismember(action, {'store', 'append', 'version', 'help'});

end
