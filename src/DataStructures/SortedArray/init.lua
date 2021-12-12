-- @author Validark
local Types = require(script.Parent.Types)

--[=[
	A class to create sorted arrays. Must contain objects comparable to
	one another (that can use the `<` and `==` operators). Numbers and
	strings support these operators by default.

	```lua
	local SortedArray = require("SortedArray")
	local Array1 = SortedArray.new({1, 2, 3}) -- Gets sorted.
	local Array2 = SortedArray.new()
	```

	@class SortedArray
]=]
local SortedArray = {}
SortedArray.ClassName = "SortedArray"
SortedArray.__index = SortedArray

type Array<Value> = Types.Array<Value>
type int = Types.int
type NonNil = Types.NonNil

type CompareFunction<T> = (A: T, B: T) -> boolean
type GenericPredicate<ValueType, ReturnType> = (
	Value: ValueType,
	Index: int,
	self: SortedArray<ValueType>
) -> ReturnType

type ReducePredicate<ValueType, ReturnType> = (
	Accumulator: ValueType,
	Value: ValueType,
	Index: int,
	self: SortedArray<ValueType>
) -> ReturnType

type GenericPredicateNoReturn<ValueType> = (Value: ValueType, Index: int, self: SortedArray<ValueType>) -> ()

--[=[
	Instantiates and returns a new SortedArray, with optional parameters.

	@param BaseArray Array<T>? -- An array of data which will be sorted upon instantiation. If this is omitted, an empty array is used.
	@param Comparison <T>((A: T, B: T) -> boolean)? -- An optional comparison function which is used to customize the element sorting, which will be given two elements `A` and `B` from the array as parameters. The function should return a boolean value specifying whether the first argument should be before the second argument in the sequence. If no comparison function is passed, the Lua-default `A < B` sorting is used.
	@return SortedArray<T>
]=]
function SortedArray.new<T>(BaseArray: Array<T>?, Comparison: CompareFunction<T>?)
	local self
	if BaseArray then
		local Length = #BaseArray
		self = table.move(BaseArray, 1, Length, 1, table.create(Length))
		table.sort(self, Comparison)
	else
		self = {}
	end

	self.Comparison = Comparison
	return setmetatable(self, SortedArray)
end

local function FindClosest(self, Value, Low, High, Eq, Lt)
	local Middle

	do
		local Sum = Low + High
		Middle = (Sum - Sum % 2) / 2
	end

	if Middle == 0 then
		return nil
	end

	local Compare = Lt or self.Comparison
	local Value2 = self[Middle]

	while Middle ~= High do
		if Eq then
			if Eq(Value, Value2) then
				return Middle
			end
		elseif Value == Value2 then
			return Middle
		end

		local Bool = if Compare then Compare(Value, Value2) else Value < Value2
		if Bool then
			High = Middle - 1
		else
			Low = Middle + 1
		end

		local Sum = Low + High
		Middle = (Sum - Sum % 2) / 2
		Value2 = self[Middle]
	end

	return Middle
end

--[=[
	Runs the given function on every element in the array.

	```lua
	SortedArray.new({1, 2, 3}):ForEach(function(Value)
		print(Value)
	end) -- prints 1, 2, and 3
	```

	@param Function <T>(Value: T, Index: int, self: SortedArray<T>) -> () -- The function you are running.
]=]
function SortedArray:ForEach(Function: GenericPredicateNoReturn<any>)
	for Index, Value in ipairs(self) do
		Function(Value, Index, self)
	end
end

--[=[
	Maps the SortedArray to a new array using the given predicate.

	```lua
	print(SortedArray.new({1, 2, 3}):Map(function(Value)
		return Value * 2
	end)) -- {2, 4, 6}
	```

	@param Predicate <T>(Value: T, Index: int, self: SortedArray<T>) -> T? -- The function you are running.
	@return Array<T> -- The mapped array.
]=]
function SortedArray:Map(Predicate: GenericPredicate<any, any?>)
	local Result = {}
	for Index, Value in ipairs(self) do
		Result[Index] = Predicate(Value, Index, self)
	end

	return Result
end

--[=[
	Maps the SortedArray to a new SortedArray using the given predicate.

	```lua
	print(SortedArray.new({1, 2, 3}):MapToSortedArray(function(Value)
		return Value * 2
	end)) -- SortedArray<[2, 4, 6]>
	```

	@param Predicate <T>(Value: T, Index: int, self: SortedArray<T>) -> T? -- The function you are running.
	@return SortedArray<T> -- The mapped array.
]=]
function SortedArray:MapToSortedArray(Predicate: GenericPredicate<any, any?>)
	local Result = {}
	for Index, Value in ipairs(self) do
		Result[Index] = Predicate(Value, Index, self)
	end

	local NewSelf = setmetatable(Result, SortedArray)
	NewSelf.Comparison = self.Comparison
	NewSelf:Sort()
	return NewSelf
end

--[=[
	Runs every the given predicate on every element in the array to check if some value in the array satisfies the predicate.

	```lua
	print(SortedArray.new({2, 4, 6, 8}):Some(function(Value)
		return Value == 4
	end)) -- true

	print(SortedArray.new({1, 2, 4, 6, 8}):Some(function(Value)
		return Value == 3
	end)) -- false
	```

	@param Predicate <T>(Value: T, Index: int, self: SortedArray<T>) -> boolean? -- The function you are running.
	@return boolean -- Whether or not the predicate was satisfied.
]=]
function SortedArray:Some(Predicate: GenericPredicate<any, boolean?>)
	for Index, Value in ipairs(self) do
		if Predicate(Value, Index, self) == true then
			return true
		end
	end

	return false
end

--[=[
	Runs every the given predicate on every element in the array to check if every value in the array satisfies the predicate.

	```lua
	print(SortedArray.new({2, 4, 6, 8}):Every(function(Value)
		return Value % 2 == 0
	end)) -- true

	print(SortedArray.new({1, 2, 4, 6, 8}):Every(function(Value)
		return Value % 2 == 0
	end)) -- false
	```

	@param Predicate <T>(Value: T, Index: int, self: SortedArray<T>) -> boolean? -- The function you are running.
	@return boolean -- Whether or not the predicate was satisfied.
]=]
function SortedArray:Every(Predicate: GenericPredicate<any, boolean?>)
	for Index, Value in ipairs(self) do
		if not Predicate(Value, Index, self) then
			return false
		end
	end

	return true
end

--[=[
	The Reduce method executes a user-supplied "reducer" callback function on each element of the array, in order, passing in the return value
	from the calculation on the preceding element. The final result of running the reducer across all elements of the array is a single value.

	```lua
	local Array = SortedArray.new({1, 2, 3, 4})
	local function Reducer(PreviousValue, CurrentValue)
		return PreviousValue + CurrentValue
	end

	print(Array:Reduce(Reducer)) -- 10
	print(Array:Reduce(Reducer, 5)) -- 15
	```

	@param Predicate <T>(Accumulator: T, Value: T, Index: int, self: SortedArray<T>) -> T -- The function you are running.
	@param InitialValue T? -- The initial value of the accumulator. Defaults to the first value in the SortedArray.
	@return T -- The final value of the accumulator.
]=]
function SortedArray:Reduce(Predicate: ReducePredicate<any, any>, InitialValue: any?): any
	local First = 1
	local Last = #self
	local Accumulator

	if InitialValue == nil then
		if Last == 0 then
			error("Reduce of empty array with no initial value at SortedArray:Reduce", 2)
		end

		Accumulator = self[First]
		First += 1
	else
		Accumulator = InitialValue
	end

	for Index = First, Last do
		Accumulator = Predicate(Accumulator, self[Index], Index, self)
	end

	return Accumulator
end

--[=[
	The ReduceRight method applies a function against an accumulator and each value of the array (from right-to-left) to reduce it to a single value.

	```lua
	local Array = SortedArray.new({2, 30, 45, 100})
	local function Reducer(PreviousValue, CurrentValue)
		return PreviousValue - CurrentValue
	end

	print(Array:ReduceRight(Reducer)) -- prints 23
	print(Array:ReduceRight(Reducer, 2)) -- prints -175
	```

	@param Predicate <T>(Accumulator: T, Value: T, Index: int, self: SortedArray<T>) -> T -- The function you are running.
	@param InitialValue T? -- The initial value of the accumulator. Defaults to the first value in the SortedArray.
	@return T -- The final value of the accumulator.
]=]
function SortedArray:ReduceRight(Predicate: ReducePredicate<any, any>, InitialValue: any?): any
	local First = #self
	local Last = 1
	local Accumulator

	if InitialValue == nil then
		if First == 0 then
			error("Reduce of empty array with no initial value at SortedArray:ReduceRight", 2)
		end

		Accumulator = self[First]
		First -= 1
	else
		Accumulator = InitialValue
	end

	for Index = First, Last, -1 do
		Accumulator = Predicate(Accumulator, self[Index], Index, self)
	end

	return Accumulator
end

local function Filter(self, Predicate)
	local NewSelf = {}
	local Length = 0

	for Index, Value in ipairs(self) do
		if Predicate(Value, Index, self) == true then
			Length += 1
			NewSelf[Length] = Value
		end
	end

	return NewSelf
end

--[=[
	The Filter method creates a new array with all elements that pass the test implemented by the provided function.

	```lua
	local EvenArray = SortedArray.new({1, 2, 3, 4, 5, 6, 7, 8, 9, 10}):Filter(function(Value)
		return Value % 2 == 0
	end)

	print(EvenArray) -- {2, 4, 6, 8, 10}
	```

	@param Predicate <T>(Value: T, Index: int, self: SortedArray<T>) -> boolean? -- The function you are running.
	@return Array<T> -- The filtered array.
]=]
function SortedArray:Filter(Predicate: GenericPredicate<any, boolean?>)
	local NewSelf = {}
	local Length = 0

	for Index, Value in ipairs(self) do
		if Predicate(Value, Index, self) == true then
			Length += 1
			NewSelf[Length] = Value
		end
	end

	return NewSelf
end

--[=[
	The FilterToSortedArray method creates a new SortedArray with all elements that pass the test implemented by the provided function.

	```lua
	local EvenArray = SortedArray.new({1, 2, 3, 4, 5, 6, 7, 8, 9, 10}):FilterToSortedArray(function(Value)
		return Value % 2 == 0
	end)

	print(EvenArray) -- SortedArray<[2, 4, 6, 8, 10]>
	```

	@param Predicate <T>(Value: T, Index: int, self: SortedArray<T>) -> boolean? -- The function you are running.
	@return SortedArray<T> -- The filtered array.
]=]
function SortedArray:FilterToSortedArray(Predicate: GenericPredicate<any, boolean?>)
	local NewSelf = setmetatable(Filter(self, Predicate), SortedArray)
	NewSelf.Comparison = self.Comparison
	return NewSelf
end

local function Slice(self, StartIndex, EndIndex)
	local Length = #self
	StartIndex = if StartIndex == nil then 0 else StartIndex
	EndIndex = if EndIndex == nil then Length else EndIndex

	if StartIndex < 0 then
		StartIndex += Length
	end

	if EndIndex < 0 then
		EndIndex += Length
	end

	return table.move(
		self,
		StartIndex + 1,
		EndIndex,
		1,
		table.create(if StartIndex > EndIndex then StartIndex - EndIndex else EndIndex - StartIndex)
	)
end

--[=[
	The `Slice()` method returns a shallow copy of a portion of an array into a new SortedArray object selected from `StartIndex` to `EndIndex`
	(`EndIndex` not included) where `StartIndex` and `EndIndex` represent the index of items in that array. The original array will not be modified.

	```lua
	local Array = SortedArray.new({"Ant", "Bison", "Camel", "Duck", "Elephant"})
	print(Array:Slice(2)) -- {Camel, Duck, Elephant}
	print(Array:Slice(2, 4)) -- {Camel, Duck}
	print(Array:Slice(1, 5)) -- {Bison, Camel, Duck, Elephant}
	print(Array:Slice(-2)) -- {Duck, Elephant}
	print(Array:Slice(2, -1)) -- {Camel, Duck}
	```

	@param StartIndex int? -- The zero-based index at which to start extraction. A negative index can be used, indicating an offset from the end of the sequence. `Slice(-2)` extracts the last two elements in the sequence. If this is not provided, it'll default to `0`. If it is greater than the index range of the sequence, an empty array is returned.
	@param EndIndex int? -- Zero-based index before which to end extraction. `Slice` extracts up to but not including `EndIndex`. For example, `Slice(1, 4)` extracts the second element through the fourth element (elements indexed 1, 2, and 3). A negative index can be used, indicating an offset from the end of the sequence. `Slice(2, -1)` extracts the third element through the second-to-last element in the sequence. If `EndIndex` is omitted, `Slice` extracts through the end of the sequence (`#self`). If `EndIndex` is greater than the length of the sequence, slice extracts through to the end of the sequence (`#self`).
	@return Array<T> -- The sliced array.
]=]
function SortedArray:Slice(StartIndex: int?, EndIndex: int?)
	local Length = #self
	StartIndex = if StartIndex == nil then 0 else StartIndex
	EndIndex = if EndIndex == nil then Length else EndIndex

	if StartIndex < 0 then
		StartIndex += Length
	end

	if EndIndex < 0 then
		EndIndex += Length
	end

	return table.move(
		self,
		StartIndex + 1,
		EndIndex,
		1,
		table.create(if StartIndex > EndIndex then StartIndex - EndIndex else EndIndex - StartIndex)
	)
end

--[=[
	The `Slice()` method returns a shallow copy of a portion of an array into a new SortedArray object selected from `StartIndex` to `EndIndex`
	(`EndIndex` not included) where `StartIndex` and `EndIndex` represent the index of items in that array. The original array will not be modified.

	```lua
	local Array = SortedArray.new({"Ant", "Bison", "Camel", "Duck", "Elephant"})
	print(Array:SliceToSortedArray(2)) -- SortedArray<[Camel, Duck, Elephant]>
	print(Array:SliceToSortedArray(2, 4)) -- SortedArray<[Camel, Duck]>
	print(Array:SliceToSortedArray(1, 5)) -- SortedArray<[Bison, Camel, Duck, Elephant]>
	print(Array:SliceToSortedArray(-2)) -- SortedArray<[Duck, Elephant]>
	print(Array:SliceToSortedArray(2, -1)) -- SortedArray<[Camel, Duck]>
	```

	@param StartIndex int? -- The zero-based index at which to start extraction. A negative index can be used, indicating an offset from the end of the sequence. `Slice(-2)` extracts the last two elements in the sequence. If this is not provided, it'll default to `0`. If it is greater than the index range of the sequence, an empty array is returned.
	@param EndIndex int? -- Zero-based index before which to end extraction. `Slice` extracts up to but not including `EndIndex`. For example, `Slice(1, 4)` extracts the second element through the fourth element (elements indexed 1, 2, and 3). A negative index can be used, indicating an offset from the end of the sequence. `Slice(2, -1)` extracts the third element through the second-to-last element in the sequence. If `EndIndex` is omitted, `Slice` extracts through the end of the sequence (`#self`). If `EndIndex` is greater than the length of the sequence, slice extracts through to the end of the sequence (`#self`).
	@return SortedArray<T> -- The sliced array.
]=]
function SortedArray:SliceToSortedArray(StartIndex: int?, EndIndex: int?)
	local NewSelf = setmetatable(Slice(self, StartIndex, EndIndex), SortedArray)
	NewSelf.Comparison = self.Comparison
	NewSelf:Sort()
	return NewSelf
end

local function MapFilter(self, Predicate)
	local NewSelf = {}
	local Length = 0

	for Index, Value in ipairs(self) do
		local Result = Predicate(Value, Index, self)
		if Result ~= nil then
			Length += 1
			NewSelf[Length] = Result
		end
	end

	return NewSelf
end

--[=[
	A combination function of `Filter` and `Map`. If the predicate function returns nil, the value will not be included in the new list. Any other result will add the result value to the new list.

	```lua
	local Array = SortedArray.new({1, 2, 3, 4, 5, 6, 7, 8, 9, 10}):MapFilter(function(Value)
		return if Value % 2 == 0 then if Value % 3 == 0 then nil else Value else nil
	end)

	print(Array) -- {2, 4, 8, 10}
	```

	@param Predicate <T>(Value: T, Index: int, self: SortedArray<T>) -> T? -- The function to map and filter with.
	@return Array<T> -- The mapped and filtered array.
]=]
function SortedArray:MapFilter(Predicate: GenericPredicate<any, any?>)
	local NewSelf = {}
	local Length = 0

	for Index, Value in ipairs(self) do
		local Result = Predicate(Value, Index, self)
		if Result ~= nil then
			Length += 1
			NewSelf[Length] = Result
		end
	end

	return NewSelf
end

--[=[
	A combination function of `Filter` and `Map`. If the predicate function returns nil, the value will not be included in the new list. Any other result will add the result value to the new list.

	```lua
	local Array = SortedArray.new({1, 2, 3, 4, 5, 6, 7, 8, 9, 10}):MapFilterToSortedArray(function(Value)
		return if Value % 2 == 0 then if Value % 3 == 0 then nil else Value else nil
	end)

	print(Array) -- SortedArray<[2, 4, 8, 10]>
	```

	@param Predicate <T>(Value: T, Index: int, self: SortedArray<T>) -> T? -- The function to map and filter with.
	@return SortedArray<T> -- The mapped and filtered array.
]=]
function SortedArray:MapFilterToSortedArray(Predicate: GenericPredicate<any, any?>)
	local NewSelf = setmetatable(MapFilter(self, Predicate), SortedArray)
	NewSelf.Comparison = self.Comparison
	NewSelf:Sort()
	return NewSelf
end

--[=[
	Inserts an element in the proper place which would preserve the array's orderedness. Returns the index the element was inserted.

	```lua
	local Array = SortedArray.new({1, 3, 5})
	print(Array:Insert(2)) -- 2
	print(Array:Insert(6)) -- 5
	print(Array:Insert(4)) -- 4
	print(Array) -- SortedArray<[1, 2, 3, 4, 5, 6]>
	```

	@param Value T -- The value you are inserting.
	@return int -- The index the value was inserted at.
]=]
function SortedArray:Insert(Value: any): int
	-- Inserts a Value into the SortedArray while maintaining its sortedness
	local Position = FindClosest(self, Value, 1, #self)
	local Value2 = self[Position]

	if Value2 then
		local Compare = self.Comparison
		local Bool = if Compare then Compare(Value, Value2) else Value < Value2
		Position = Bool and Position or Position + 1
	else
		Position = 1
	end

	table.insert(self, Position, Value)
	return Position
end

--[=[
	Finds an Element in a SortedArray and returns its position (or nil if non-existant).

	```lua
	local Array = SortedArray.new({1, 2, 3, 4, 5})
	print(Array:Find(3)) -- 3
	print(Array:Find(6)) -- nil
	```

	@param Value T -- The element to find or something that will be matched by the `Eq` function.
	@param Eq (<T>(Value: T, Other: T) -> boolean)? -- An optional function which checks for equality between the passed-in element and the other elements in the SortedArray.
	@param Lt (<T>(Value: T, Other: T) -> boolean)? -- An optional less-than comparison function, which falls back on the comparison passed in from `SortedArray.new`.
	@param Low int? -- The lowest index to search. Defaults to 1.
	@param High int? -- The high index to search. Defaults to the length of the SortedArray.
	@return int? -- The numerical index of the element which was found, else nil.
]=]
function SortedArray:Find(Value: any, Eq: CompareFunction<any>?, Lt: CompareFunction<any>?, Low: int?, High: int?)
	local Position = FindClosest(self, Value, Low or 1, High or #self, Eq, Lt)
	local Bool = if Position then if Eq then Eq(Value, self[Position]) else Value == self[Position] else nil
	return if Bool then Position else nil
end

SortedArray.IndexOf = SortedArray.Find

--[=[
	Makes a shallow copy of the SortedArray.

	```lua
	print(SortedArray.new({1, 2, 3, 4, 5}):Copy()) -- {1, 2, 3, 4, 5}
	```

	@return Array<T> -- The shallow copied array.
]=]
function SortedArray:Copy()
	local Length = #self
	return table.move(self, 1, Length, 1, table.create(Length))
end

--[=[
	Makes a shallow copy of the SortedArray and returns a new SortedArray.

	```lua
	print(SortedArray.new({1, 2, 3, 4, 5}):Clone()) -- SortedArray<[1, 2, 3, 4, 5]>
	```

	@return SortedArray<T> -- The shallow copied array.
]=]
function SortedArray:Clone()
	local Length = #self
	local NewSelf = table.move(self, 1, Length, 1, table.create(Length))
	NewSelf.Comparison = self.Comparison
	NewSelf:Sort()
	return setmetatable(NewSelf, SortedArray)
end

--[=[
	Searches the array via `SortedArray:Find(Signature, Eq, Lt)`. If found, it removes the value and returns the value, otherwise returns nil. Only removes a single occurence.

	```lua
	local Array = SortedArray.new({1, 2, 3, 4, 5})
	print(Array:RemoveElement(3)) -- 3
	print(Array:RemoveElement(6)) -- nil
	```

	@param Signature T -- The value you want to remove.
	@param Eq (<T>(Value: T, Other: T) -> boolean)? -- An optional function which checks for equality between the passed-in element and the other elements in the SortedArray.
	@param Lt (<T>(Value: T, Other: T) -> boolean)? -- An optional less-than comparison function, which falls back on the comparison passed in from `SortedArray.new`.
	@return T? -- The removed value.
]=]
function SortedArray:RemoveElement(Signature: any, Eq: CompareFunction<any>?, Lt: CompareFunction<any>?)
	local Position = self:Find(Signature, Eq, Lt)
	return if Position then self:RemoveIndex(Position) else nil
end

--[=[
	Does `table.sort(self, self.Comparison)` and returns the SortedArray.
	@return SortedArray<T> -- Returns self.
]=]
function SortedArray:Sort()
	table.sort(self, self.Comparison)
	return self
end

--[=[
	Removes the value at Index and re-inserts it. This is useful for when a value may have updated in a way that could change it's position in a SortedArray. Returns Index.
	@param Index int -- The index to resort.
	@return int -- The new position.
]=]
function SortedArray:SortIndex(Index: int)
	-- Sorts a single element at number Index
	-- Useful for when a single element is somehow altered such that it should get a new position in the array

	return self:Insert(self:RemoveIndex(Index))
end

--[=[
	Calls `RemoveElement(Signature, Eq, Lt)` and re-inserts the value. This is useful for when a value may have updated in a way that could change its position in a SortedArray. Returns Index.

	@param Signature T -- The value you want to re-sort.
	@param Eq (<T>(Value: T, Other: T) -> boolean)? -- An optional function which checks for equality between the passed-in element and the other elements in the SortedArray.
	@param Lt (<T>(Value: T, Other: T) -> boolean)? -- An optional less-than comparison function, which falls back on the comparison passed in from `SortedArray.new`.
	@return int -- The new position.
]=]
function SortedArray:SortElement(Signature: any, Eq: CompareFunction<any>?, Lt: CompareFunction<any>?)
	-- Sorts a single element if it exists
	-- Useful for when a single element is somehow altered such that it should get a new position in the array

	return self:Insert(self:RemoveElement(Signature, Eq, Lt))
end

--[=[
	:::warning Performance
	If you care about performance, do not use this function. Just do `for Index, Value in ipairs(SortedArray) do` directly.
	:::

	This returns an iterator for the SortedArray. This only exists for consistency reasons.
	@return IteratorFunction -- The `ipairs` iterator.
]=]
function SortedArray:Iterator()
	return ipairs(self)
end

--[=[
	Calls `table.concat` on the SortedArray.

	@param Separator string? -- The separator of the entries.
	@param StartIndex int? -- The index to start concatenating from.
	@param EndIndex int? -- The index to end concatenating at.
	@return string -- The stringify SortedArray.
]=]
function SortedArray:Concat(Separator: string?, StartIndex: int?, EndIndex: int?)
	return table.concat(self, Separator, StartIndex, EndIndex)
end

--[=[
	Calls `table.remove` on the SortedArray.
	@param Index int? -- The index to remove.
	@return T? -- The removed value.
]=]
function SortedArray:RemoveIndex(Index: int?)
	return table.remove(self, Index)
end

--[=[
	Calls `table.unpack` on the SortedArray.
	@param StartIndex int? -- The index to start unpacking at.
	@param EndIndex int? -- The index to end unpacking at.
	@return ...T -- The unpacked array.
]=]
function SortedArray:Unpack(StartIndex: int?, EndIndex: int?)
	return table.unpack(self, StartIndex, EndIndex)
end

--[=[
	Returns a SortedArray of Commonalities between self and another SortedArray. If applicable, the returned SortedArray will inherit the Comparison function from self.
	@error "InvalidSortedArray" -- Thrown when SortedArray2 is not a SortedArray.

	@param SortedArray2 SortedArray<T> -- The SortedArray to get the intersection with.
	@param Eq (<T>(Value: T, Other: T) -> boolean)? -- An optional function which checks for equality between the passed-in element and the other elements in the SortedArray.
	@param Lt (<T>(Value: T, Other: T) -> boolean)? -- An optional less-than comparison function, which falls back on the comparison passed in from `SortedArray.new`.
	@return SortedArray<T> -- A SortedArray with the common values between self and SortedArray2.
]=]
function SortedArray:GetIntersection(
	SortedArray2: SortedArray<any>,
	Eq: CompareFunction<any>?,
	Lt: CompareFunction<any>?
)
	-- Returns a SortedArray of Commonalities between self and another SortedArray
	-- If applicable, the returned SortedArray will inherit the Comparison function from self
	if SortedArray ~= getmetatable(SortedArray2) then
		error(
			"bad argument #2 to GetIntersection: expected SortedArray, got "
				.. typeof(SortedArray2)
				.. " "
				.. tostring(SortedArray2)
		)
	end

	local Commonalities = SortedArray.new(nil, self.Comparison)
	local Count = 0
	local Position = 1
	local NumSelf = #self
	local NumSortedArray2 = #SortedArray2

	if NumSelf > NumSortedArray2 then -- Iterate through the shorter SortedArray
		NumSelf, NumSortedArray2 = NumSortedArray2, NumSelf
		self, SortedArray2 = SortedArray2, self
	end

	for Index = 1, NumSelf do
		local Current = self[Index]
		local CurrentPosition = SortedArray2:Find(Current, Eq, Lt, Position, NumSortedArray2)

		if CurrentPosition then
			Position = CurrentPosition
			Count += 1
			Commonalities[Count] = Current
		end
	end

	return Commonalities
end

local function GetMedian(self, A, B)
	local C = A + B

	if C % 2 == 0 then
		return self[C / 2]
	else
		local D = (C - 1) / 2
		return (self[D] + self[D + 1]) / 2
	end
end

function SortedArray:GetFront()
	return self[1]
end

function SortedArray:GetBack()
	return self[#self]
end

function SortedArray:GetMedian()
	return GetMedian(self, 1, #self)
end

function SortedArray:GetQuartile1()
	local Length = #self
	return GetMedian(self, 1, (Length - Length % 2) / 2)
end

function SortedArray:GetQuartile3()
	local Length = #self
	return GetMedian(self, 1 + (Length + Length % 2) / 2, Length)
end

function SortedArray:__tostring()
	local Length = #self
	local String = table.move(self, 1, Length, 1, table.create(Length))
	for Index, Value in ipairs(String) do
		String[Index] = tostring(Value)
	end

	return string.format("SortedArray<[%s]>", table.concat(String, ", "))
end

export type SortedArray<T> = typeof(SortedArray.new({1}))
table.freeze(SortedArray)
return SortedArray
