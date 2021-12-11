local Types = require(script.Parent.Parent.Types)

--[=[
	In a max priority queue, elements are inserted in the order in which they arrive the queue and the maximum value is always removed first from the queue.

	@class MaxPriorityQueue
]=]
local MaxPriorityQueue = {}
MaxPriorityQueue.ClassName = "MaxPriorityQueue"
MaxPriorityQueue.__index = MaxPriorityQueue

type Array<Value> = Types.Array<Value>
type NonNil = Types.NonNil
type int = Types.int

export type HeapEntry = {
	Priority: number,
	Value: NonNil,
}

--[=[
	@within MaxPriorityQueue
	@prop Length int
	The length of the MaxPriorityQueue.
]=]

--[=[
	Creates a new `MaxPriorityQueue`.
	@return MaxPriorityQueue<T>
]=]
function MaxPriorityQueue.new()
	return setmetatable({
		Heap = {};
		Length = 0;
	}, MaxPriorityQueue)
end

--[=[
	Determines whether the passed value is a MaxPriorityQueue.
	@param Value any -- The value to check.
	@return boolean -- Whether or not the passed value is a MaxPriorityQueue.
]=]
function MaxPriorityQueue.Is(Value)
	return type(Value) == "table" and getmetatable(Value) == MaxPriorityQueue
end

--[=[
	Check whether the `MaxPriorityQueue` has no elements.
	@return boolean -- This will be true iff the queue is empty.
]=]
function MaxPriorityQueue:IsEmpty(): boolean
	return self.Length == 0
end

local function FindClosestIndex(self: MaxPriorityQueue, Priority: number, Low: int, High: int): int
	local Middle

	do
		local Sum = Low + High
		Middle = (Sum - Sum % 2) / 2
	end

	if Middle == 0 then
		return -1
	end

	local Heap: Array<HeapEntry> = self.Heap
	local Element: HeapEntry = Heap[Middle]

	while Middle ~= High do
		local Priority2 = Element.Priority
		if Priority == Priority2 then
			return Middle
		end

		if Priority < Priority2 then
			High = Middle - 1
		else
			Low = Middle + 1
		end

		local Sum = Low + High
		Middle = (Sum - Sum % 2) / 2
		Element = Heap[Middle]
	end

	return Middle
end

--[=[
	Add an element to the `MaxPriorityQueue` with an associated priority.
	@error InvalidValue -- Thrown when the value is nil.

	@param Value NonNil -- The value of the element.
	@param Priority number -- The priority of the element.
	@return int -- The inserted position.
]=]
function MaxPriorityQueue:InsertWithPriority(Value: NonNil, Priority: number): int
	if Value == nil then
		error("Argument #2 to 'MaxPriorityQueue:InsertWithPriority' missing or nil", 2)
	end

	local Heap = self.Heap
	local Position = FindClosestIndex(self, Priority, 1, self.Length)
	local Element1: HeapEntry = {Value = Value, Priority = Priority}
	local Element2: HeapEntry? = Heap[Position]

	if Element2 then
		Position = Priority < Element2.Priority and Position or Position + 1
	else
		Position = 1
	end

	table.insert(Heap, Position, Element1)
	self.Length += 1
	return Position
end

MaxPriorityQueue.Insert = MaxPriorityQueue.InsertWithPriority

--[=[
	Changes the priority of the given value in the `MaxPriorityQueue`.
	@error InvalidValue -- Thrown when the value is nil.
	@error CouldNotFind -- Thrown when the value couldn't be found.

	@param Value NonNil -- The value you are updating the priority of.
	@param NewPriority number -- The new priority of the value.
	@return int? -- The new position of the HeapEntry if it was found. This function will error if it couldn't find the value.
]=]
function MaxPriorityQueue:ChangePriority(Value: NonNil, NewPriority: number): int?
	if Value == nil then
		error("Argument #2 to 'MaxPriorityQueue:ChangePriority' missing or nil", 2)
	end

	local Heap: Array<HeapEntry> = self.Heap
	for Index, HeapEntry in ipairs(Heap) do
		if HeapEntry.Value == Value then
			table.remove(Heap, Index)
			self.Length -= 1
			return self:InsertWithPriority(Value, NewPriority)
		end
	end

	error("Couldn't find value in queue?", 2)
end

--[=[
	Gets the priority of the first value in the `MaxPriorityQueue`. This is the value that will be removed last.
	@return number? -- The priority of the first value.
]=]
function MaxPriorityQueue:GetFirstPriority(): number?
	if self.Length == 0 then
		return nil
	end

	return self.Heap[1].Priority
end

--[=[
	Gets the priority of the last value in the `MaxPriorityQueue`. This is the value that will be removed first.
	@return number? -- The priority of the last value.
]=]
function MaxPriorityQueue:GetLastPriority(): number?
	local Length: number = self.Length
	if Length == 0 then
		return nil
	end

	return self.Heap[Length].Priority
end

--[=[
	Remove the element from the `MaxPriorityQueue` that has the highest priority, and return it.
	@param OnlyValue boolean? -- Whether or not to return only the value or the entire entry.
	@return T | HeapEntry -- The removed element.
]=]
function MaxPriorityQueue:PopElement(OnlyValue: boolean?): any | HeapEntry
	local Heap: Array<HeapEntry> = self.Heap
	local Length: number = self.Length
	self.Length = Length - 1

	local Element: HeapEntry = Heap[Length]
	Heap[Length] = nil
	return OnlyValue and Element.Value or Element or nil
end

MaxPriorityQueue.PullHighestPriorityElement = MaxPriorityQueue.PopElement
MaxPriorityQueue.GetMaximumElement = MaxPriorityQueue.PopElement

--[=[
	Converts the entire `MaxPriorityQueue` to an array.
	@param OnlyValues boolean? -- Whether or not the array is just the values or the priorities as well.
	@return Array<T> | Array<HeapEntry> -- The `MaxPriorityQueue`'s array.
]=]
function MaxPriorityQueue:ToArray(OnlyValues: boolean?): Array<any> | Array<HeapEntry>
	if OnlyValues then
		local Array = table.create(self.Length)
		for Index, HeapEntry in ipairs(self.Heap) do
			Array[Index] = HeapEntry.Value
		end

		return Array
	else
		-- This is slower, but it's so it's immutable.
		local Array: Array<HeapEntry> = table.create(self.Length)
		for Index, HeapEntry in ipairs(self.Heap) do
			Array[Index] = HeapEntry
		end

		return Array
	end
end

--[=[
	Returns an iterator function for iterating over the `MaxPriorityQueue`.
	@param OnlyValues boolean? Whether or not the iterator returns just the values or the priorities as well.
	@return IteratorFunction -- The iterator function. Usage is `for Index, Value in MaxPriorityQueue:Iterator(OnlyValues) do`.
]=]
function MaxPriorityQueue:Iterator(OnlyValues: boolean?)
	if OnlyValues then
		local Array = table.create(self.Length)
		for Index, HeapEntry in ipairs(self.Heap) do
			Array[Index] = HeapEntry.Value
		end

		return ipairs(Array)
	else
		return ipairs(self.Heap)
	end
end

--[=[
	Returns an iterator function for iterating over the `MaxPriorityQueue` in reverse.
	@param OnlyValues boolean? -- Whether or not the iterator returns just the values or the priorities as well.
	@return IteratorFunction -- The iterator function. Usage is `for Index, Value in MaxPriorityQueue:ReverseIterator(OnlyValues) do`.
]=]
function MaxPriorityQueue:ReverseIterator(OnlyValues: boolean?)
	local Length: number = self.Length
	local Top = Length + 1

	if OnlyValues then
		local Array = table.create(Length)
		for Index, HeapEntry in ipairs(self.Heap) do
			Array[Top - Index] = HeapEntry.Value
		end

		return ipairs(Array)
	else
		local Array = table.create(Length)
		for Index, HeapEntry in ipairs(self.Heap) do
			Array[Top - Index] = HeapEntry
		end

		return ipairs(Array)
	end
end

MaxPriorityQueue.Iterate = MaxPriorityQueue.Iterator
MaxPriorityQueue.ReverseIterate = MaxPriorityQueue.ReverseIterator

--[=[
	Clears the entire `MaxPriorityQueue`.
	@return MaxPriorityQueue<T> -- The same `MaxPriorityQueue`.
]=]
function MaxPriorityQueue:Clear()
	table.clear(self.Heap)
	self.Length = 0
	return self
end

--[=[
	Determines if the `MaxPriorityQueue` contains the given value.
	@error InvalidValue -- Thrown when the value is nil.

	@param Value NonNil -- The value you are searching for.
	@return boolean -- Whether or not the value was found.
]=]
function MaxPriorityQueue:Contains(Value: NonNil): boolean
	if Value == nil then
		error("Argument #2 to 'MaxPriorityQueue:Contains' missing or nil", 2)
	end

	for _, HeapEntry in ipairs(self.Heap) do
		if HeapEntry.Value == Value then
			return true
		end
	end

	return false
end

--[=[
	Removes the `HeapEntry` with the given priority, if it exists.
	@param Priority number -- The priority you are removing from the `MaxPriorityQueue`.
]=]
function MaxPriorityQueue:RemovePriority(Priority: number)
	for Index, HeapEntry in ipairs(self.Heap) do
		if HeapEntry.Priority == Priority then
			table.remove(self.Heap, Index)
			self.Length -= 1
			break
		end
	end
end

--[=[
	Removes the `HeapEntry` with the given value, if it exists.
	@error InvalidValue -- Thrown when the value is nil.

	@param Value NonNil -- The value you are removing from the `MaxPriorityQueue`.
]=]
function MaxPriorityQueue:RemoveValue(Value: NonNil)
	if Value == nil then
		error("Argument #2 to 'MaxPriorityQueue:RemoveValue' missing or nil", 2)
	end

	for Index, HeapEntry in ipairs(self.Heap) do
		if HeapEntry.Value == Value then
			table.remove(self.Heap, Index)
			self.Length -= 1
			break
		end
	end
end

function MaxPriorityQueue:__tostring()
	local Array = table.create(self.Length)
	for Index, Value in self:Iterator(false) do
		Array[Index] = string.format("\t{Priority = %s, Value = %s};", tostring(Value.Priority), tostring(Value.Value))
	end

	return string.format("MaxPriorityQueue<{\n%s\n}>", table.concat(Array, "\n"))
end

export type MaxPriorityQueue = typeof(MaxPriorityQueue.new())
table.freeze(MaxPriorityQueue)
return MaxPriorityQueue
