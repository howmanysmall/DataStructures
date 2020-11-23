local function TypeOf(Value: any): string
	local ValueType: string = typeof(Value)
	if ValueType == "table" then
		local Metatable = getmetatable(Value)
		if type(Metatable) == "table" then
			local CustomType: string? = Metatable.__type or Metatable.ClassName
			if CustomType then
				return CustomType
			end
		end
	end

	return ValueType
end

return TypeOf