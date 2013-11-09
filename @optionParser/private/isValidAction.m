function bool = isValidAction(action)

bool = ischar(action) && ismember(action, {'store', 'append'});

end
