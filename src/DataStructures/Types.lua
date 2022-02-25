export type Array<Value> = {Value}
export type Dictionary<Value> = {[string]: Value}
export type Map<Index, Value> = {[Index]: Value}

export type float = number
export type int = number
export type int64 = number
export type NonNil = any

export type Comparable = any
export type ComparisonFunction<T> = (T, T) -> boolean

export type userdata = typeof(newproxy(false))

local Types = {}

function Types.TypeOf(Value)
	local ValueType = typeof(Value)
	if ValueType == "table" then
		local Type = Value.__type
		if Type then
			return Type
		end

		local Metatable = getmetatable(Value)
		if type(Metatable) == "table" then
			local CustomType = Metatable.__type or Metatable.ClassName
			if CustomType then
				return CustomType
			end
		end
	end

	return ValueType
end

return Types
