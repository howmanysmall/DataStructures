local Types = require(script.Parent.Types)

--[=[
	A Stack is a LIFO (Last In First Out) data structure.
	@class Stack
]=]
local Stack = {}
Stack.ClassName = "Stack"
Stack.__index = Stack

type Array<Value> = Types.Array<Value>
type int = Types.int
type NonNil = Types.NonNil

--[=[
	@within Stack
	@prop Length int
	The length of the Stack.
]=]

--[=[
	Creates an empty `Stack`.
	@return Stack<T>
]=]
function Stack.new()
	return setmetatable({Length = 0}, Stack)
end

--[=[
	Determines whether the passed value is a Stack.
	@param Value any -- The value to check.
	@return boolean -- Whether or not the passed value is a Stack.
]=]
function Stack.Is(Value)
	return type(Value) == "table" and getmetatable(Value) == Stack
end

--[=[
	Pushes the passed value to the end of the Stack.
	@error InvalidValue -- Thrown when the value is nil.

	@param Value T -- The value you are pushing.
	@return int -- The passed value's location.
]=]
function Stack:Push(Value: NonNil): int
	if Value == nil then
		error("Argument #2 to 'Stack:Push' missing or nil", 2)
	end

	local Length: int = self.Length + 1
	self[Length] = Value
	self.Length = Length
	return Length
end

--[=[
	Removes the last value from the Stack.
	@return T? -- The last value from the Stack, if it exists.
]=]
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

--[=[
	Gets the last value of the Stack.
	@return T? -- The last value.
]=]
function Stack:GetTop(): any
	return self[self.Length]
end

--[=[
	Gets the first value of the Stack.
	@return T? -- The first value.
]=]
function Stack:GetBottom(): any
	return self[1]
end

Stack.Bottom = Stack.GetBottom
Stack.Top = Stack.GetTop

--[=[
	Determines if the Stack is empty.
	@return boolean -- Whether or not the Stack is empty.
]=]
function Stack:IsEmpty(): boolean
	return self.Length == 0
end

--[=[
	Returns an iterator that can be used to iterate through the Stack. This is just an alias for `ipairs`, which you can use instead. This only exists for consistency reasons.
	@function Iterator
	@within Stack
	@return StackIterator -- The iterator, which is used in a for loop.
]=]
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
