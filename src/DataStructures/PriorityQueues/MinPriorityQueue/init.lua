local Types = require(script.Parent.Parent.Types)

--[=[
	In a min priority queue, elements are inserted in the order in which they arrive the queue and the smallest value is always removed first from the queue.

	@class MinPriorityQueue
]=]
local MinPriorityQueue = {}
MinPriorityQueue.ClassName = "MinPriorityQueue"
MinPriorityQueue.__index = MinPriorityQueue

type Array<Value> = Types.Array<Value>
type NonNil = Types.NonNil
type int = Types.int

export type HeapEntry = {
	Priority: number,
	Value: NonNil,
}

--[=[
	@within MinPriorityQueue
	@prop Length int
	The length of the MinPriorityQueue.
]=]

--[=[
	@within MinPriorityQueue
	@prop Heap Array<T>
	The heap data of the MinPriorityQueue.
]=]

--[=[
	Creates a new `MinPriorityQueue`.
	@return MinPriorityQueue<T>
]=]
function MinPriorityQueue.new()
	return setmetatable({
		Heap = {};
		Length = 0;
	}, MinPriorityQueue)
end

--[=[
	Determines whether the passed value is a MinPriorityQueue.
	@param Value any -- The value to check.
	@return boolean -- Whether or not the passed value is a MinPriorityQueue.
]=]
function MinPriorityQueue.Is(Value)
	return type(Value) == "table" and getmetatable(Value) == MinPriorityQueue
end

--[=[
	Check whether the `MinPriorityQueue` has no elements.
	@return boolean -- This will be true iff the queue is empty.
]=]
function MinPriorityQueue:IsEmpty(): boolean
	return self.Length == 0
end

local function FindClosestIndex(self: MinPriorityQueue, Priority: number, Low: int, High: int): int
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

		if Priority > Priority2 then
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
	Add an element to the `MinPriorityQueue` with an associated priority.
	@error "InvalidValue" -- Thrown when the value is nil.

	@param Value T -- The value of the element.
	@param Priority number -- The priority of the element.
	@return int -- The inserted position.
]=]
function MinPriorityQueue:InsertWithPriority(Value: NonNil, Priority: number): int
	if Value == nil then
		error("Argument #2 to 'MinPriorityQueue:InsertWithPriority' missing or nil", 2)
	end

	local Heap = self.Heap
	local Position = FindClosestIndex(self, Priority, 1, self.Length)
	local Element1: HeapEntry = {Value = Value, Priority = Priority}
	local Element2: HeapEntry? = Heap[Position]

	if Element2 then
		Position = Priority > Element2.Priority and Position or Position + 1
	else
		Position = 1
	end

	table.insert(Heap, Position, Element1)
	self.Length += 1
	return Position
end

MinPriorityQueue.Insert = MinPriorityQueue.InsertWithPriority

--[=[
	Changes the priority of the given value in the `MinPriorityQueue`.
	@error "InvalidValue" -- Thrown when the value is nil.
	@error "CouldNotFind" -- Thrown when the value couldn't be found.

	@param Value T -- The value you are updating the priority of.
	@param NewPriority number -- The new priority of the value.
	@return int? -- The new position of the HeapEntry if it was found. This function will error if it couldn't find the value.
]=]
function MinPriorityQueue:ChangePriority(Value: NonNil, NewPriority: number): int?
	if Value == nil then
		error("Argument #2 to 'MinPriorityQueue:ChangePriority' missing or nil", 2)
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
	Gets the priority of the first value in the `MinPriorityQueue`. This is the value that will be removed last.
	@return number? -- The priority of the first value.
]=]
function MinPriorityQueue:GetFirstPriority(): number?
	if self.Length == 0 then
		return nil
	end

	return self.Heap[1].Priority
end

--[=[
	Gets the priority of the last value in the `MinPriorityQueue`. This is the value that will be removed first.
	@return number? -- The priority of the last value.
]=]
function MinPriorityQueue:GetLastPriority(): number?
	local Length: number = self.Length
	if Length == 0 then
		return nil
	end

	return self.Heap[Length].Priority
end

--[=[
	Remove the element from the `MinPriorityQueue` that has the highest priority, and return it.
	@param OnlyValue boolean? -- Whether or not to return only the value or the entire entry.
	@return T | HeapEntry? -- The removed element.
]=]
function MinPriorityQueue:PopElement(OnlyValue: boolean?): any | HeapEntry
	local Heap: Array<HeapEntry> = self.Heap
	local Length: number = self.Length
	self.Length = Length - 1

	local Element: HeapEntry = Heap[Length]
	Heap[Length] = nil
	return OnlyValue and Element.Value or Element or nil
end

MinPriorityQueue.PullHighestPriorityElement = MinPriorityQueue.PopElement
MinPriorityQueue.GetMaximumElement = MinPriorityQueue.PopElement

--[=[
	Converts the entire `MinPriorityQueue` to an array.
	@param OnlyValues boolean? -- Whether or not the array is just the values or the priorities as well.
	@return Array<T> | Array<HeapEntry<T>> -- The `MinPriorityQueue`'s array.
]=]
function MinPriorityQueue:ToArray(OnlyValues: boolean?): Array<any> | Array<HeapEntry>
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
	Returns an iterator function for iterating over the `MinPriorityQueue`.

	:::warning Performance
	If you care about performance, do not use this function. Just do `for Index, Value in ipairs(MinPriorityQueue.Heap) do` directly.
	:::

	@param OnlyValues boolean? -- Whether or not the iterator returns just the values or the priorities as well.
	@return IteratorFunction -- The iterator function. Usage is `for Index, Value in MinPriorityQueue:Iterator(OnlyValues) do`.
]=]
function MinPriorityQueue:Iterator(OnlyValues: boolean?)
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
	Returns an iterator function for iterating over the `MinPriorityQueue` in reverse.
	@param OnlyValues boolean? -- Whether or not the iterator returns just the values or the priorities as well.
	@return IteratorFunction -- The iterator function. Usage is `for Index, Value in MinPriorityQueue:ReverseIterator(OnlyValues) do`.
]=]
function MinPriorityQueue:ReverseIterator(OnlyValues: boolean?)
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

MinPriorityQueue.Iterate = MinPriorityQueue.Iterator
MinPriorityQueue.ReverseIterate = MinPriorityQueue.ReverseIterator

--[=[
	Clears the entire `MinPriorityQueue`.
	@return MinPriorityQueue<T> -- The same `MinPriorityQueue`.
]=]
function MinPriorityQueue:Clear()
	table.clear(self.Heap)
	self.Length = 0
	return self
end

--[=[
	Determines if the `MinPriorityQueue` contains the given value.
	@error "InvalidValue" -- Thrown when the value is nil.

	@param Value T -- The value you are searching for.
	@return boolean -- Whether or not the value was found.
]=]
function MinPriorityQueue:Contains(Value: NonNil): boolean
	if Value == nil then
		error("Argument #2 to 'MinPriorityQueue:Contains' missing or nil", 2)
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
	@param Priority number -- The priority you are removing from the `MinPriorityQueue`.
]=]
function MinPriorityQueue:RemovePriority(Priority: number)
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
	@error "InvalidValue" -- Thrown when the value is nil.

	@param Value T -- The value you are removing from the `MinPriorityQueue`.
]=]
function MinPriorityQueue:RemoveValue(Value: NonNil)
	if Value == nil then
		error("Argument #2 to 'MinPriorityQueue:RemoveValue' missing or nil", 2)
	end

	for Index, HeapEntry in ipairs(self.Heap) do
		if HeapEntry.Value == Value then
			table.remove(self.Heap, Index)
			self.Length -= 1
			break
		end
	end
end

function MinPriorityQueue:__tostring()
	local Array = table.create(self.Length)
	for Index, Value in ipairs(self.Heap) do
		Array[Index] = string.format("\t{Priority = %s, Value = %s};", tostring(Value.Priority), tostring(Value.Value))
	end

	return string.format("MinPriorityQueue<{\n%s\n}>", table.concat(Array, "\n"))
end

export type MinPriorityQueue = typeof(MinPriorityQueue.new())
table.freeze(MinPriorityQueue)
return MinPriorityQueue
