--!strict
local MinPriorityQueue = {}
MinPriorityQueue.ClassName = "MinPriorityQueue"
MinPriorityQueue.__index = MinPriorityQueue

type Array<Value> = {Value}
export type HeapEntry = {
	Priority: number,
	Value: any,
}

--[[**
	Creates a new `MinPriorityQueue`.
	@returns [t:MinPriorityQueue]
**--]]
function MinPriorityQueue.new()
	return setmetatable({
		Heap = {};
		Length = 0;
	}, MinPriorityQueue)
end

export type MinPriorityQueue = typeof(MinPriorityQueue.new())

--[[**
	Check whether the `MinPriorityQueue` has no elements.
	@returns [t:boolean] This will be true iff the queue is empty.
**--]]
function MinPriorityQueue:IsEmpty(): boolean
	return self.Length == 0
end

local function FindClosestIndex(self: MinPriorityQueue, Priority: number, Low: number, High: number): number
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

--[[**
	Add an element to the `MinPriorityQueue` with an associated priority.
	@param [t:any] Value The value of the element.
	@param [t:number] Priority The priority of the element.
	@returns [t:number] The inserted position.
**--]]
function MinPriorityQueue:InsertWithPriority(Value: any, Priority: number): number
	local Heap: Array<HeapEntry> = self.Heap
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

--[[**
	Changes the priority of the given value in the `MinPriorityQueue`.
	@param [t:any] Value The value you are updating the priority of.
	@param [t:number] NewPriority The new priority of the value.
	@returns [t:number?] The new position of the HeapEntry if it was found. This function will error if it couldn't find the value.
**--]]
function MinPriorityQueue:ChangePriority(Value: any, NewPriority: number): number?
	self = self :: MinPriorityQueue
	local Heap: Array<HeapEntry> = self.Heap
	for Index, HeapEntry in ipairs(Heap) do
		if HeapEntry.Value == Value then
			table.remove(self.Heap, Index)
			self.Length -= 1
			return self:InsertWithPriority(Value, NewPriority)
		end
	end

	error("Couldn't find value in queue?", 2)
end

--[[**
	Gets the priority of the first value in the `MinPriorityQueue`. This is the value that will be removed last.
	@returns [t:number?] The priority of the first value.
**--]]
function MinPriorityQueue:GetFirstPriority(): number?
	if self.Length == 0 then
		return nil
	end

	return self.Heap[1].Priority
end

--[[**
	Gets the priority of the last value in the `MinPriorityQueue`. This is the value that will be removed first.
	@returns [t:number?] The priority of the last value.
**--]]
function MinPriorityQueue:GetLastPriority(): number?
	local Length: number = self.Length
	if Length == 0 then
		return nil
	end

	return self.Heap[Length].Priority
end

--[[**
	Remove the element from the `MinPriorityQueue` that has the highest priority, and return it.
	@param [t:boolean?] OnlyValue Whether or not to return only the value or the entire entry.
	@returns [t:any|HeapEntry] The removed element.
**--]]
function MinPriorityQueue:PopElement(OnlyValue: boolean?): any | HeapEntry
	local Heap: Array<HeapEntry> = self.Heap
	local Length : number = self.Length
	self.Length = Length - 1

	local Element: HeapEntry = Heap[Length]
	Heap[Length] = nil
	return OnlyValue and Element.Value or Element or nil
end

MinPriorityQueue.PullHighestPriorityElement = MinPriorityQueue.PopElement
MinPriorityQueue.GetMinimumElement = MinPriorityQueue.PopElement

--[[**
	Converts the entire `MinPriorityQueue` to an array.
	@param [t:boolean?] OnlyValues Whether or not the array is just the values or the priorities as well.
	@returns [t:Array<any>|Array<HeapEntry>] The `MinPriorityQueue`'s array.
**--]]
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

--[[**
	Returns an iterator function for iterating over the `MinPriorityQueue`.
	@param [t:boolean?] OnlyValues Whether or not the iterator returns just the values or the priorities as well.
	@returns [t:IteratorFunction] The iterator function. Usage is `for Index, Value in MinPriorityQueue:Iterate(OnlyValues) do`.
**--]]
function MinPriorityQueue:Iterate(OnlyValues: boolean?)
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

--[[**
	Returns an iterator function for iterating over the `MinPriorityQueue` in reverse.
	@param [t:boolean?] OnlyValues Whether or not the iterator returns just the values or the priorities as well.
	@returns [t:IteratorFunction] The iterator function. Usage is `for Index, Value in MinPriorityQueue:ReverseIterate(OnlyValues) do`.
**--]]
function MinPriorityQueue:ReverseIterate(OnlyValues: boolean?)
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

--[[**
	Clears the entire `MinPriorityQueue`.
	@returns [t:MinPriorityQueue] The same `MinPriorityQueue`.
**--]]
function MinPriorityQueue:Clear(): MinPriorityQueue
	table.clear(self.Heap)
	self.Length = 0
	return self
end

--[[**
	Determines if the `MinPriorityQueue` contains the given value.
	@param [t:any] Value The value you are searching for.
	@returns [t:boolean] Whether or not the value was found.
**--]]
function MinPriorityQueue:Contains(Value: any): boolean
	for _, HeapEntry in ipairs(self.Heap) do
		if HeapEntry.Value == Value then
			return true
		end
	end

	return false
end

--[[**
	Removes the `HeapEntry` with the given priority, if it exists.
	@param [t:number] Priority The priority you are removing from the `MinPriorityQueue`.
	@returns [t:nil]
**--]]
function MinPriorityQueue:RemovePriority(Priority: number)
	self = self :: MinPriorityQueue
	for Index, HeapEntry in ipairs(self.Heap) do
		if HeapEntry.Priority == Priority then
			table.remove(self.Heap, Index)
			self.Length -= 1
			break
		end
	end
end

--[[**
	Removes the `HeapEntry` with the given value, if it exists.
	@param [t:any] Value The value you are removing from the `MinPriorityQueue`.
	@returns [t:nil]
**--]]
function MinPriorityQueue:RemoveValue(Value: any)
	self = self :: MinPriorityQueue
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
	for Index, Value in self:Iterate(false) do
		Array[Index] = string.format("\t{Priority = %s, Value = %s};", tostring(Value.Priority), tostring(Value.Value))
	end

	return string.format("MinPriorityQueue<{\n%s\n}>", table.concat(Array, "\n"))
end

return MinPriorityQueue
