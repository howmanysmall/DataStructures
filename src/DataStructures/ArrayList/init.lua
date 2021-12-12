local Types = require(script.Parent.Types)

--[=[
	An object to represent a list of values in an array.

	@class ArrayList
]=]
local ArrayList = {}
ArrayList.ClassName = "ArrayList"
ArrayList.__index = ArrayList

type Array<Value> = Types.Array<Value>
type int = Types.int
type NonNil = Types.NonNil

--[=[
	@within ArrayList
	@prop IsFixedSize boolean

	Whether or not the ArrayList is fixed size. Defaults to `false`.
]=]

--[=[
	@within ArrayList
	@prop IsReadOnly boolean
	Whether or not the ArrayList is read-only. Defaults to `false`.
]=]

--[=[
	@within ArrayList
	@prop Length number
	The length of the ArrayList.
]=]

--[=[
	Creates a new ArrayList.
	@return ArrayList<T>
]=]
function ArrayList.new()
	return setmetatable({
		IsFixedSize = false;
		IsReadOnly = false;
		Length = 0;
	}, ArrayList)
end

--[=[
	Creates a new ArrayList with the given capacity.
	@param Capacity int -- The capacity of the ArrayList.
	@return ArrayList<T>
]=]
function ArrayList.FromCapacity(Capacity: int)
	local self = table.create(Capacity)
	self.IsFixedSize = false
	self.IsReadOnly = false
	self.Length = 0
	return setmetatable(self, ArrayList)
end

--[=[
	Creates a new ArrayList from the given array. Will not mutate the original array.
	@param Array Array<T> -- The array to use as the source. This makes a shallow copy.
	@return ArrayList<T>
]=]
function ArrayList.FromArray(Array: Array<any>)
	local Length = #Array
	local self = table.move(Array, 1, Length, 1, table.create(Length))
	self.IsFixedSize = false
	self.IsReadOnly = false
	self.Length = Length
	return setmetatable(self, ArrayList)
end

ArrayList.WithCapacity = ArrayList.FromCapacity

--[=[
	Determines if the passed Value is an ArrayList.
	@param Value any -- The value to check.
	@return boolean
]=]
function ArrayList.Is(Value)
	return type(Value) == "table" and getmetatable(Value) == ArrayList
end

--[=[
	Marks the ArrayList as read-only. Returns a clone of the ArrayList.
	@error "InvalidArgument" -- Thrown when the List is nil.
	@error "NotArrayList" -- Thrown when the List isn't an ArrayList.

	@param List ArrayList<T> -- The ArrayList to make read-only.
	@return ArrayList<T>
]=]
function ArrayList.MarkReadOnly(List: ArrayList)
	if List == nil then
		error("Argument #1 to 'ArrayList.MarkReadOnly' missing or nil", 2)
	end

	if type(List) ~= "table" or getmetatable(List) ~= ArrayList then
		error("Argument #1 to 'ArrayList.MarkReadOnly' is not an ArrayList", 2)
	end

	local self = List:Clone()
	self.IsReadOnly = true
	return self
end

--[=[
	Marks the ArrayList as a fixed size. Returns a clone of the ArrayList.
	@error "InvalidArgument" -- Thrown when the List is nil.
	@error "NotArrayList" -- Thrown when the List isn't an ArrayList.

	@param List ArrayList<T> -- The ArrayList to mark as fixed size.
	@return ArrayList<T>
]=]
function ArrayList.MarkFixedSize(List: ArrayList)
	if List == nil then
		error("Argument #1 to 'ArrayList.MarkFixedSize' missing or nil", 2)
	end

	if type(List) ~= "table" or getmetatable(List) ~= ArrayList then
		error("Argument #1 to 'ArrayList.MarkFixedSize' is not an ArrayList", 2)
	end

	local self = List:Clone()
	self.IsFixedSize = true
	return self
end

--[=[
	Adds an object to the end of the ArrayList.
	@error "IsFixedSize" -- Thrown when the ArrayList is fixed size.
	@error "IsReadOnly" -- Thrown when the ArrayList is read-only.
	@error "InvalidArgument" -- Thrown when the value is nil.

	@param Value NonNil -- The value to be added to the end of the ArrayList. The value cannot be nil.
	@return int -- The ArrayList index at which the value has been added.
]=]
function ArrayList:Add(Value: NonNil): int
	if self.IsFixedSize then
		error("This ArrayList has a fixed size.", 2)
	end

	if self.IsReadOnly then
		error("This ArrayList is read-only.", 2)
	end

	if Value == nil then
		error("Argument #2 to 'ArrayList:Add' missing or nil", 2)
	end

	local Length = self.Length + 1
	self.Length = Length
	self[Length] = Value
	return Length
end

--[=[
	Creates a shallow copy of the ArrayList.
	@return ArrayList<T> -- A shallow copy of the ArrayList.
]=]
function ArrayList:Clone()
	local NewSelf = table.move(self, 1, self.Length, 1, table.create(self.Length))
	NewSelf.IsFixedSize = self.IsFixedSize
	NewSelf.IsReadOnly = self.IsReadOnly
	NewSelf.Length = self.Length
	return setmetatable(NewSelf, ArrayList)
end

--[=[
	Clears the ArrayList.
	@error "IsFixedSize" -- Thrown when the ArrayList is fixed size.
	@error "IsReadOnly" -- Thrown when the ArrayList is read-only.
]=]
function ArrayList:Clear()
	if self.IsFixedSize then
		error("This ArrayList has a fixed size.", 2)
	end

	if self.IsReadOnly then
		error("This ArrayList is read-only.", 2)
	end

	table.clear(self)
	self.IsReadOnly = false
	self.IsFixedSize = false
	self.Length = 0
end

--[=[
	Determines if the ArrayList contains the given value.
	@error "InvalidArgument" -- Thrown when the value is nil.

	@param Value NonNil -- The value to check.
	@return boolean
]=]
function ArrayList:Contains(Value: NonNil): boolean
	if Value == nil then
		error("Argument #2 to 'ArrayList:Contains' missing or nil", 2)
	end

	return table.find(self, Value) ~= nil
end

--[=[
	Locates the index of the given value in the ArrayList.
	@error "InvalidArgument" -- Thrown when the value is nil.

	@param Value NonNil -- The value to search for.
	@return int? -- The index of the value.
]=]
function ArrayList:IndexOf(Value: NonNil): int?
	if Value == nil then
		error("Argument #2 to 'ArrayList:IndexOf' missing or nil", 2)
	end

	return table.find(self, Value)
end

--[=[
	Inserts the given value into the ArrayList at the given index.
	@error "IsFixedSize" -- Thrown when the ArrayList is fixed size.
	@error "IsReadOnly" -- Thrown when the ArrayList is read-only.
	@error "InvalidArgument" -- Thrown when either the value or the index is incorrect.

	@param Index int -- The index to insert at.
	@param Value NonNil -- The value to be added to the end of the ArrayList. The value cannot be nil.
]=]
function ArrayList:Insert(Index: int, Value: NonNil)
	if self.IsFixedSize then
		error("This ArrayList has a fixed size.", 2)
	end

	if self.IsReadOnly then
		error("This ArrayList is read-only.", 2)
	end

	if Value == nil then
		error("Argument #3 to 'ArrayList:Insert' missing or nil", 2)
	end

	if Index < 1 then
		error("Argument #2 to 'ArrayList:Insert' must be greater than zero.", 2)
	end

	if Index > self.Length + 1 then
		error("Argument #2 to 'ArrayList:Insert' must be less than or equal to the length of the ArrayList.", 2)
	end

	self.Length += 1
	table.insert(self, Index, Value)
end

function ArrayList:__tostring()
	local String = table.move(self, 1, self.Length, 1, table.create(self.Length))
	for Index, Value in ipairs(String) do
		String[Index] = tostring(Value)
	end

	return string.format("ArrayList<[%s]>", table.concat(String, ", "))
end

export type ArrayList = typeof(ArrayList.new())
table.freeze(ArrayList)
return ArrayList
