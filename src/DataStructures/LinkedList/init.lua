local TypeOf = require(script.Parent.TypeOf)

local LinkedList = {ClassName = "LinkedList"}
LinkedList.__index = LinkedList

local ListNode = {ClassName = "ListNode"}
ListNode.__index = ListNode

type Map<Index, Value> = {[Index]: Value}
type Array<Value> = Map<number, Value>
type Dictionary<Value> = Map<string, Value>

local null = nil

do
	local List = setmetatable({
		First = null;
		Last = null;
		Length = 0;
	}, LinkedList)

	export type LinkedList = typeof(List)
	export type LinkedListIterator = typeof(List:Iterator())
	export type ListNode = typeof(setmetatable({
		Previous = null;
		Next = null;
		List = List;
		Value = 1;
	}, ListNode))
end

--[[**
	Creates an empty `LinkedList`.
	@param [Array<any>?] Values An optional array that contains the values you want to add.
	@returns [LinkedList]
**--]]
function LinkedList.new(Values: Array<any>?): LinkedList
	if Values then
		local self = setmetatable({
			First = null;
			Last = null;
			Length = 0;
		}, LinkedList)

		for _, Value in ipairs(Values) do
			self:Push(Value)
		end

		return self
	else
		return setmetatable({
			First = null;
			Last = null;
			Length = 0;
		}, LinkedList)
	end
end

--[[**
	Adds the element `Value` to the end of the list. This operation should compute in O(1) time and O(1) memory.
	@param [any] Value The value you are appending.
	@returns [ListNode?] The appended node.
**--]]
function LinkedList:Push(Value: any): ListNode?
	if Value == null then
		error("Value passed to LinkedList:Push was nil!", 2)
	end

	self.Length += 1
	local Previous: ListNode? = self.Last
	local Node: ListNode = setmetatable({
		Previous = Previous;
		Next = nil;
		Value = Value;
		List = self;
	}, ListNode)

	if Previous then
		Previous.Next = Node
	else
		self.First = Node
	end

	self.Last = Node
	return Node
end

--[[**
	Adds the elements from `List` to the end of the list. This operation should compute in O(1) time and O(1) memory.
	@param [LinkedList] List The `LinkedList` you are appending from.
	@returns [nil]
**--]]
function LinkedList:Append(List: LinkedList)
	assert(TypeOf(List) == "LinkedList", string.format("Invalid type for LinkedList:Append (LinkedList expected, got %s)", TypeOf(List)))
	for _, NodeValue in List:Iterator() do
		self:Push(NodeValue)
	end
end

--[[**
	Adds the element `Value` to the start of the list. This operation should compute in O(1) time and O(1) memory.
	@param [any] Value The value you are prepending.
	@returns [ListNode?] The prepended node.
**--]]
function LinkedList:PushFront(Value: any): ListNode?
	if Value == nil then
		error("Value passed to LinkedList:PushFront was nil!", 2)
	end

	self.Length += 1
	local Next: ListNode? = self.First
	local Node: ListNode = setmetatable({
		Previous = nil;
		Next = Next;
		Value = Value;
		List = self;
	}, ListNode)

	if Next then
		Next.Previous = Node
	else
		self.Last = Node
	end

	self.First = Node
	return Node
end

--[[**
	Adds the elements from `List` to the start of the list. This operation should compute in O(1) time and O(1) memory.
	@param [LinkedList] List The `LinkedList` you are prepending from.
	@returns [nil]
**--]]
function LinkedList:Prepend(List: LinkedList)
	assert(TypeOf(List) == "LinkedList", string.format("Invalid type for LinkedList:Prepend (LinkedList expected, got %s)", TypeOf(List)))
	for _, NodeValue in List:ReverseIterator() do
		self:PushFront(NodeValue)
	end
end

--[[**
	Removes the first element and returns it, or `nil` if the list is empty. This operation should compute in O(1) time.
	@returns [ListNode?] The popped node, if there was one.
**--]]
function LinkedList:Pop(): ListNode?
	if self.Length == 0 then
		return null
	else
		local Node: ListNode? = self.First
		if Node then
			Node:Destroy()
			return Node
		else
			return null
		end
	end
end

--[[**
	Removes the last element and returns it, or `null` if the list is empty. This operation should compute in O(1) time.
	@returns [ListNode?] The popped node, if there was one.
**--]]
function LinkedList:PopBack(): ListNode?
	if self.Length == 0 then
		return null
	else
		local Node: ListNode? = self.Last
		if Node then
			Node:Destroy()
			return Node
		else
			return null
		end
	end
end

--[[**
	Returns `true` if the `LinkedList` is empty. This operation should compute in O(1) time.
	@returns [boolean]
**--]]
function LinkedList:IsEmpty(): boolean
	return self.Length <= 0
end

--[[**
	Removes all elements from the `LinkedList`. This operation should compute in O(n) time.
	@returns [LinkedList]
**--]]
function LinkedList:Clear(): LinkedList
	while self.Length > 0 do
		local Node: ListNode? = self.First
		if Node then
			Node:Destroy()
		end
	end

	return self
end

--[[**
	Returns `true` if the `LinkedList` contains an element equal to the given value.
	@param [ListNode | any] Value The value you are searching for.
	@returns [boolean]
**--]]
function LinkedList:Contains(Value: ListNode | any): boolean
	if TypeOf(Value) == "ListNode" then
		for Node in self:Iterator() do
			if Node == Value then
				return true
			end
		end
	else
		for _, NodeValue in self:Iterator() do
			if NodeValue == Value then
				return true
			end
		end
	end

	return false
end

function LinkedList:_Iterator(Node: ListNode?): (ListNode?, any?)
	Node = not Node and self.First or Node and Node.Next
	if not Node then
		return null, null
	else
		return Node, Node.Value
	end
end

function LinkedList:_ReverseIterator(Node: ListNode?): (ListNode?, any?)
	Node = not Node and self.Last or Node and Node.Previous
	if not Node then
		return null, null
	else
		return Node, Node.Value
	end
end

--[[**
	Provides a forward iterator.
	@returns [LinkedListIterator]
**--]]
function LinkedList:Iterator(): LinkedListIterator
	return LinkedList._Iterator, self
end

--[[**
	Provides a reverse iterator.
	@returns [LinkedListIterator]
**--]]
function LinkedList:ReverseIterator(): LinkedListIterator
	return LinkedList._ReverseIterator, self
end

--[[**
	Returns an array containing all of the elements in this list in proper sequence (from first to last element).
	@returns [Array<any>] An array with every element in the `LinkedList`.
**--]]
function LinkedList:ToArray(): Array<any>
	local Array: Array<any> = {}
	local Length: number = 0
	for _, Value in self:Iterator() do
		Length += 1
		Array[Length] = Value
	end

	return Array
end

--[[**
	Removes the element at the given index from the `LinkedList`. This operation should compute in O(n) time.
	@param [number] Index The index of the node you want to remove.
	@returns [LinkedList]
**--]]
function LinkedList:Remove(Index: number): LinkedList
	if Index > self.Length or Index < 1 then
		error(string.format("Index %d is out of the range of [1, %d]", Index, self.Length), 2)
	end

	local CurrentNode: ListNode? = self.First
	local CurrentIndex: number = 0

	while CurrentNode do
		CurrentIndex += 1
		if CurrentIndex == Index then
			if CurrentNode == self.First then
				self.First = CurrentNode.Next
			elseif CurrentNode == self.Last then
				self.Last = CurrentNode.Previous
			else
				CurrentNode.Previous.Next = CurrentNode.Next
				CurrentNode.Next.Previous = CurrentNode.Previous
			end

			self.Length -= 1
			break
		end

		CurrentNode = CurrentNode.Next
	end

	return self
end

--[[**
	Removes any element with the given value from the `LinkedList`. This operation should compute in O(n) time.
	@param [any] Value The value you want to remove from the `LinkedList`.
	@returns [LinkedList]
**--]]
function LinkedList:RemoveValue(Value: any): LinkedList
	local CurrentNode: ListNode? = self.First
	while CurrentNode do
		if CurrentNode.Value == Value then
			if CurrentNode == self.First then
				self.First = CurrentNode.Next
			elseif CurrentNode == self.Last then
				self.Last = CurrentNode.Previous
			else
				CurrentNode.Previous.Next = CurrentNode.Next
				CurrentNode.Next.Previous = CurrentNode.Previous
			end

			self.Length -= 1
		end

		CurrentNode = CurrentNode.Next
	end

	return self
end

--[[**
	Removes the given `ListNode` from the `LinkedList`. This operation should compute in O(n) time.
	@param [ListNode] Node The node you want to remove from the `LinkedList`.
	@returns [LinkedList]
**--]]
function LinkedList:RemoveNode(Node: ListNode): LinkedList
	local CurrentNode: ListNode? = self.First
	while CurrentNode do
		if CurrentNode == Node then
			if CurrentNode == self.First then
				self.First = CurrentNode.Next
			elseif CurrentNode == self.Last then
				self.Last = CurrentNode.Previous
			else
				CurrentNode.Previous.Next = CurrentNode.Next
				CurrentNode.Next.Previous = CurrentNode.Previous
			end

			self.Length -= 1
		end

		CurrentNode = CurrentNode.Next
	end

	return self
end

function ListNode:After(Value: any): ListNode?
	local List: LinkedList? = self.List
	if List then
		List.Length += 1
		local Node: ListNode = setmetatable({
			Previous = self;
			Next = self.Next;
			Value = Value;
		}, ListNode)

		if List.Last == self then
			List.Last = Node
		else
			self.Next.Previous = Node
		end

		self.Next = Node
		return Node
	end
end

function ListNode:Before(Value: any): ListNode?
	local List: LinkedList? = self.List
	if List then
		List.Length += 1
		local Node: ListNode = setmetatable({
			Previous = self.Previous;
			Next = self;
			Value = Value;
		}, ListNode)

		if List.First == self then
			List.First = Node
		else
			self.Previous.Next = Node
		end

		self.Previous = Node
		return Node
	end
end

function ListNode:Destroy(): boolean
	local List: LinkedList = self.List
	if List then
		self.List = nil
		List.Length -= 1

		local Previous: ListNode? = self.Previous
		local Next: ListNode? = self.Next

		if self == List.Last then
			List.Last = Previous
		end

		if self == List.First then
			List.First = Next
		end

		if Previous then
			Previous.Next = Next
		end

		if Next then
			Next.Previous = Previous
		end

		return true
	else
		return false
	end
end

function ListNode:Iterator()
	local List: LinkedList? = self.List
	if List then
		return LinkedList._Iterator, List, self
	end
end

function ListNode:ReverseIterator()
	local List: LinkedList? = self.List
	if List then
		return LinkedList._ReverseIterator, List, self
	end
end

function LinkedList:__tostring(): string
	local ListArray: Array<string> = table.create(self.Length)
	local Length: number = 0

	for _, Value in self:Iterator() do
		Length += 1
		ListArray[Length] = tostring(Value)
	end

	return "[" .. table.concat(ListArray, ", ") .. "]"
end

function ListNode:__tostring(): string
	return tostring(self.Value)
end

return LinkedList