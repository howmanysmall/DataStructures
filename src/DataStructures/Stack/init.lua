local Types = require(script.Parent.Types)

local Stack = {}
Stack.ClassName = "Stack"
Stack.__index = Stack

type Array<Value> = Types.Array<Value>
type int = Types.int
type NonNil = Types.NonNil

--[[**
	Creates an empty `Stack`.
	@returns [t:Stack]
**--]]
function Stack.new()
	return setmetatable({Length = 0}, Stack)
end

--[[**
	Determines whether the passed value is a Stack.
	@param [t:any] Value The value to check.
	@returns [t:boolean] Whether or not the passed value is a Stack.
**--]]
function Stack.Is(Value)
	return type(Value) == "table" and getmetatable(Value) == Stack
end

--[[**
	Pushes the passed value to the end of the Stack.
	@param [t:NonNil] Value The value you are pushing.
	@returns [t:int] The passed value's location.
**--]]
function Stack:Push(Value: NonNil): int
	if Value == nil then
		error("Argument #2 to 'Stack:Push' missing or nil", 2)
	end

	local Length: int = self.Length + 1
	self[Length] = Value
	self.Length = Length
	return Length
end

--[[**
	Removes the last value from the Stack.
	@returns [t:any?] The last value from the Stack, if it exists.
**--]]
function Stack:Pop(): any?
	local Length: number = self.Length
	if Length > 0 then
		local Value = self[Length]
		self[Length] = nil
		self.Length = Length - 1
		return Value
	end

	return nil
end

--[[**
	Gets the last value of the Stack.
	@returns [t:any] The last value.
**--]]
function Stack:GetTop(): any
	return self[self.Length]
end

--[[**
	Gets the first value of the Stack.
	@returns [t:any] The first value.
**--]]
function Stack:GetBottom(): any
	return self[1]
end

Stack.Bottom = Stack.GetBottom
Stack.Top = Stack.GetTop

--[[**
	Determines if the Stack is empty.
	@returns [t:boolean] Whether or not the Stack is empty.
**--]]
function Stack:IsEmpty(): boolean
	return self.Length == 0
end

--[[**
	Returns an iterator that can be used to iterate through the Stack. This is just an alias for `ipairs`, which you can use instead. This only exists for consistency reasons.
	@returns [t:StackIterator] The iterator, which is used in a for loop.
**--]]
Stack.Iterator = ipairs

function Stack:__tostring(): string
	local StackArray = table.create(self.Length)
	for Index, Value in ipairs(self) do
		StackArray[Index] = tostring(Value)
	end

	return "Stack<[" .. table.concat(StackArray, ", ") .. "]>"
end

export type Stack = typeof(Stack.new())
table.freeze(Stack)
return Stack
