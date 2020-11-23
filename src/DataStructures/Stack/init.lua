local Stack = {ClassName = "Stack"}
Stack.__index = Stack

type Array<Value> = {[number]: Value}
export type Stack = typeof(setmetatable({
	1, 2, 3;
	Length = 3;
}, Stack))

local null = nil

function Stack.new(): Stack
	return setmetatable({Length = 0}, Stack)
end

function Stack:Push(Value: any): number
	local Length: number = self.Length + 1
	self[Length] = Value
	self.Length = Length
	return Length
end

function Stack:Pop(): any?
	local Length: number = self.Length
	if Length > 0 then
		local Value: any = self[Length]
		self[Length] = null
		self.Length = Length - 1
		return Value
	end
end

function Stack:Top(): any
	return self[self.Length]
end

function Stack:IsEmpty(): boolean
	return self.Length == 0
end

function Stack:__tostring(): string
	return "[" .. table.concat(self, ", ") .. "]"
end

return Stack