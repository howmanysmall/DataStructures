local Types = require(script.Parent.Types)
local _ = Types -- shut up

local Queue = {}
Queue.ClassName = "Queue"
Queue.__index = Queue

type Array<Value> = Types.Array<Value>
type int = Types.int
type NonNil = Types.NonNil

--[[**
	Creates an empty `Queue`.
	@returns [t:Queue]
**--]]
function Queue.new()
	return setmetatable({
		First = 1;
		Length = 0;
	}, Queue)
end

export type Queue = typeof(Queue.new())

--[[**
	Determines whether the passed value is a Queue.
	@param [t:any] Value The value to check.
	@returns [t:boolean] Whether or not the passed value is a Queue.
**--]]
function Queue.Is(Value)
	return type(Value) == "table" and getmetatable(Value) == Queue
end

--[[**
	Pushes the passed value to the end of the Queue.
	@param [t:NonNil] Value The value you are pushing.
	@returns [t:int] The passed value's location.
**--]]
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

--[[**
	Removes the first value from the Queue.
	@returns [t:any?] The first value from the Queue, if it exists.
**--]]
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

--[[**
	Gets the front value of the Queue.
	@returns [t:any] The first value.
**--]]
function Queue:GetFront(): any
	return self[self.First]
end

--[[**
	Gets the last value of the Queue.
	@returns [t:any] The last value.
**--]]
function Queue:GetBack(): any
	return self[self.Length]
end

Queue.Back = Queue.GetBack
Queue.Front = Queue.GetFront

--[[**
	Determines if the Queue is empty.
	@returns [t:boolean] Whether or not the Queue is empty.
**--]]
function Queue:IsEmpty(): boolean
	return self.Length == 0
end

local function QueueIterator(This: Queue, Position: number?)
	local self = This
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

--[[**
	Returns an iterator that can be used to iterate through the Queue.
	@returns [t:QueueIterator] The iterator, which is used in a for loop.
**--]]
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

return Queue
