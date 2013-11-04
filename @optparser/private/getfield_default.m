function val = getfield_default(s, key, default)

if isfield(s, key)
    val = getfield(s, key);
else
    val = default;
end

end
