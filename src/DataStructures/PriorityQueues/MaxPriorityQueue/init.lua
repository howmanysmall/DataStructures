local MaxPriorityQueue = {ClassName = "MaxPriorityQueue"}
MaxPriorityQueue.__index = MaxPriorityQueue

type Array<Value> = {[number]: Value}
type IteratorFunction = typeof(ipairs {}) -- maybe?

export type HeapEntry = {
	Priority: number,
	Value: any,
}

export type MaxPriorityQueue = typeof(setmetatable({
	Heap = {};
	Length = 0;
}, MaxPriorityQueue))

local ipairs = ipairs
local null = nil

--[[**
	Creates a new `MaxPriorityQueue`.
	@returns [MaxPriorityQueue]
**--]]
function MaxPriorityQueue.new(): MaxPriorityQueue
	return setmetatable({
		Heap = {};
		Length = 0;
	}, MaxPriorityQueue)
end

--[[**
	Check whether the `MaxPriorityQueue` has no elements.
	@returns [boolean] This will be true iff the queue is empty.
**--]]
function MaxPriorityQueue:IsEmpty(): boolean
	return self.Length == 0
end

local function FindClosestIndex(self: MaxPriorityQueue, Priority: number, Low: number, High: number): number
	local Middle: number do
		local Sum: number = Low + High
		Middle = (Sum - Sum % 2) / 2
	end

	if Middle == 0 then
		return -1
	end

	local Heap: Array<HeapEntry> = self.Heap
	local Element: HeapEntry = Heap[Middle]

	while Middle ~= High do
		local Priority2: number = Element.Priority
		if Priority == Priority2 then
			return Middle
		end

		if Priority < Priority2 then
			High = Middle - 1
		else
			Low = Middle + 1
		end

		local Sum: number = Low + High
		Middle = (Sum - Sum % 2) / 2
		Element = Heap[Middle]
	end

	return Middle
end

--[[**
	Add an element to the `MaxPriorityQueue` with an associated priority.
	@param [any] Value The value of the element.
	@param [number] Priority The priority of the element.
	@returns [number] The inserted position.
**--]]
function MaxPriorityQueue:InsertWithPriority(Value: any, Priority: number): number
	local Heap: Array<HeapEntry> = self.Heap
	local Position: number = FindClosestIndex(self, Priority, 1, self.Length)
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

--[[**
	Changes the priority of the given value in the `MaxPriorityQueue`.
	@param [any] Value The value you are updating the priority of.
	@param [number] NewPriority The new priority of the value.
	@returns [number?] The new position of the HeapEntry if it was found. This function will error if it couldn't find the value.
**--]]
function MaxPriorityQueue:ChangePriority(Value: any, NewPriority: number): number?
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
	Gets the priority of the first value in the `MaxPriorityQueue`. This is the value that will be removed last.
	@returns [number?] The priority of the first value.
**--]]
function MaxPriorityQueue:GetFirstPriority(): number?
	if self.Length == 0 then
		return null
	end

	return self.Heap[1].Priority
end

--[[**
	Gets the priority of the last value in the `MaxPriorityQueue`. This is the value that will be removed first.
	@returns [number?] The priority of the last value.
**--]]
function MaxPriorityQueue:GetLastPriority(): number?
	local Length: number = self.Length
	if Length == 0 then
		return null
	end

	return self.Heap[Length].Priority
end

--[[**
	Remove the element from the `MaxPriorityQueue` that has the highest priority, and return it.
	@param [boolean?] OnlyValue Whether or not to return only the value or the entire entry.
	@returns [any | HeapEntry] The removed element.
**--]]
function MaxPriorityQueue:PopElement(OnlyValue: boolean?): any | HeapEntry
	local Heap: Array<HeapEntry> = self.Heap
	local Length: number = self.Length
	self.Length -= 1

	local Element: HeapEntry = Heap[Length]
	Heap[Length] = null
	return OnlyValue and Element.Value or Element or nil
end

MaxPriorityQueue.PullHighestPriorityElement = MaxPriorityQueue.PopElement
MaxPriorityQueue.GetMaximumElement = MaxPriorityQueue.PopElement

--[[**
	Converts the entire `MaxPriorityQueue` to an array.
	@param [boolean?] OnlyValues Whether or not the array is just the values or the priorities as well.
	@returns [Array<any> | Array<HeapEntry>] The `MaxPriorityQueue`'s array.
**--]]
function MaxPriorityQueue:ToArray(OnlyValues: boolean?): Array<any> | Array<HeapEntry>
	if OnlyValues then
		local Array: Array<any> = table.create(self.Length)
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
	Returns an iterator function for iterating over the `MaxPriorityQueue`.
	@param [boolean?] OnlyValues Whether or not the iterator returns just the values or the priorities as well.
	@returns [IteratorFunction] The iterator function. Usage is `for Index, Value in MaxPriorityQueue:Iterate(OnlyValues) do`.
**--]]
function MaxPriorityQueue:Iterate(OnlyValues: boolean?): IteratorFunction
	if OnlyValues then
		local Array: Array<any> = table.create(self.Length)
		for Index, HeapEntry in ipairs(self.Heap) do
			Array[Index] = HeapEntry.Value
		end

		return ipairs(Array)
	else
		return ipairs(self.Heap)
	end
end

--[[**
	Returns an iterator function for iterating over the `MaxPriorityQueue` in reverse.
	@param [boolean?] OnlyValues Whether or not the iterator returns just the values or the priorities as well.
	@returns [IteratorFunction] The iterator function. Usage is `for Index, Value in MaxPriorityQueue:ReverseIterate(OnlyValues) do`.
**--]]
function MaxPriorityQueue:ReverseIterate(OnlyValues: boolean?): IteratorFunction
	local Length: number = self.Length
	local Top: number = Length + 1

	if OnlyValues then
		local Array: Array<any> = table.create(Length)
		for Index, HeapEntry in ipairs(self.Heap) do
			Array[Top - Index] = HeapEntry.Value
		end

		return ipairs(Array)
	else
		local Array: Array<HeapEntry> = table.create(Length)
		for Index, HeapEntry in ipairs(self.Heap) do
			Array[Top - Index] = HeapEntry
		end

		return ipairs(Array)
	end
end

--[[**
	Clears the entire `MaxPriorityQueue`.
	@returns [MaxPriorityQueue] The same `MaxPriorityQueue`.
**--]]
function MaxPriorityQueue:Clear(): MaxPriorityQueue
	table.clear(self.Heap)
	self.Length = 0
	return self
end

--[[**
	Determines if the `MaxPriorityQueue` contains the given value.
	@param [any] Value The value you are searching for.
	@returns [boolean] Whether or not the value was found.
**--]]
function MaxPriorityQueue:Contains(Value: any): boolean
	for _, HeapEntry in ipairs(self.Heap) do
		if HeapEntry.Value == Value then
			return true
		end
	end

	return false
end

--[[**
	Removes the `HeapEntry` with the given priority, if it exists.
	@param [number] Priority The priority you are removing from the `MaxPriorityQueue`.
	@returns [nil]
**--]]
function MaxPriorityQueue:RemovePriority(Priority: number)
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
	@param [any] Value The value you are removing from the `MaxPriorityQueue`.
	@returns [nil]
**--]]
function MaxPriorityQueue:RemoveValue(Value: any)
	for Index, HeapEntry in ipairs(self.Heap) do
		if HeapEntry.Value == Value then
			table.remove(self.Heap, Index)
			self.Length -= 1
			break
		end
	end
end

function MaxPriorityQueue:__tostring(): string
	local Array: Array<string> = table.create(self.Length)
	for Index, Value in self:Iterate(false) do
		Array[Index] = string.format("\t{Priority = %s, Value = %s};", tostring(Value.Priority), tostring(Value.Value))
	end

	return string.format("MaxPriorityQueue {\n%s\n}", table.concat(Array, "\n"))
end

return MaxPriorityQueue