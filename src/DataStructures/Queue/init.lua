local Types = require(script.Parent.Types)

--[=[
	A Queue is a data structure that follows the first-in, first-out (FIFO).

	@class Queue
]=]
local Queue = {}
Queue.ClassName = "Queue"
Queue.__index = Queue

type Array<Value> = Types.Array<Value>
type int = Types.int
type NonNil = Types.NonNil

--[=[
	@within Queue
	@prop First int
	The index of the first element in the queue.
]=]

--[=[
	@within Queue
	@prop Length int
	The length of the queue.
]=]

--[=[
	Creates an empty `Queue`.
	@return Queue<T>
]=]
function Queue.new()
	return setmetatable({
		First = 1;
		Length = 0;
	}, Queue)
end

--[=[
	Determines whether the passed value is a Queue.
	@param Value any -- The value to check.
	@return boolean -- Whether or not the passed value is a Queue.
]=]
function Queue.Is(Value)
	return type(Value) == "table" and getmetatable(Value) == Queue
end

--[=[
	Pushes the passed value to the end of the Queue.
	@error InvalidValue -- Thrown when the value is nil.

	@param Value T -- The value you are pushing.
	@return int -- The passed value's location.
]=]
function Queue:Push(Value: NonNil): int
	if Value == nil then
		error("Argument #2 to 'Queue:Push' missing or nil", 2)
	end

	local Length = self.Length + 1
	self.Length = Length
	Length += self.First - 1

	self[Length] = Value
	return Length
end

--[=[
	Removes the first value from the Queue.
	@return T? -- The first value from the Queue, if it exists.
]=]
function Queue:Pop(): any?
	local Length = self.Length
	if Length > 0 then
		local First = self.First
		local Value = self[First]
		self[First] = nil

		self.First = First + 1
		self.Length = Length - 1

		return Value
	end

	return nil
end

--[=[
	Gets the front value of the Queue.
	@return T -- The first value.
]=]
function Queue:GetFront(): any
	return self[self.First]
end

--[=[
	Gets the last value of the Queue.
	@return T -- The last value.
]=]
function Queue:GetBack(): any
	return self[self.Length]
end

Queue.Back = Queue.GetBack
Queue.Front = Queue.GetFront

--[=[
	Determines if the Queue is empty.
	@return boolean -- Whether or not the Queue is empty.
]=]
function Queue:IsEmpty(): boolean
	return self.Length == 0
end

local function QueueIterator(self: Queue, Position: number?)
	local NewPosition = 1
	if Position then
		NewPosition = Position + 1
	end

	if NewPosition > self.Length then
		return nil, nil
	else
		return NewPosition, self[self.First + NewPosition - 1]
	end
end

--[=[
	Returns an iterator that can be used to iterate through the Queue.
	@return QueueIterator -- The iterator, which is used in a for loop.
]=]
function Queue:Iterator()
	return QueueIterator, self
end

function Queue:__tostring(): string
	local QueueArray = table.create(self.Length)
	for Index, Value in self:Iterator() do
		QueueArray[Index] = tostring(Value)
	end

	return "Queue<[" .. table.concat(QueueArray, ", ") .. "]>"
end

export type Queue = typeof(Queue.new())
table.freeze(Queue)
return Queue
