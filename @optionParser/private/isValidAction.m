function bool = isValidAction(action)

bool = ischar(action) && ismember(action, {'store', 'append'}) ...
       || is_function_handle(action);

end
