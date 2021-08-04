local Types = require(script.Parent.Types)

local LinkedList = {}
LinkedList.ClassName = "LinkedList"
LinkedList.__index = LinkedList

local ListNode = {}
ListNode.ClassName = "ListNode"
ListNode.__index = ListNode

type Array<Value> = Types.Array<Value>
type Dictionary<Value> = Types.Dictionary<Value>
type int = Types.int

local INVALID_ARGUMENT_ERROR = "Invalid argument #%d to '%s' (%s expected, got %s)"

--[[**
	Creates an empty `LinkedList`.
	@param [t:Array<any>?] Values An optional array that contains the values you want to add.
	@returns [t:LinkedList]
**--]]
function LinkedList.new(Values: Array<any>?)
	if Values then
		local self = setmetatable({
			First = nil;
			Last = nil;
			Length = 0;
		}, LinkedList)

		for _, Value in ipairs(Values) do
			self:Push(Value)
		end

		return self
	else
		return setmetatable({
			First = nil;
			Last = nil;
			Length = 0;
		}, LinkedList)
	end
end

export type LinkedList = typeof(LinkedList.new())

--[[**
	Determines whether the passed value is a LinkedList.
	@param [t:any] Value The value to check.
	@returns [t:boolean] Whether or not the passed value is a LinkedList.
**--]]
function LinkedList.Is(Value)
	return type(Value) == "table" and getmetatable(Value) == LinkedList
end

--- Private function
function ListNode.new()
	return setmetatable({
		List = nil;
		Next = nil;
		Previous = nil;
		Value = nil;
	}, ListNode)
end

export type ListNode = typeof(ListNode.new())

--[[**
	Determines whether the passed value is a ListNode.
	@param [t:any] Value The value to check.
	@returns [t:boolean] Whether or not the passed value is a ListNode.
**--]]
function ListNode.Is(Value)
	return type(Value) == "table" and getmetatable(Value) == ListNode
end

--[[**
	Adds the element `Value` to the end of the list. This operation should compute in O(1) time and O(1) memory.
	@param [t:any] Value The value you are appending.
	@returns [t:ListNode] The appended node.
**--]]
function LinkedList:Push(Value: any): ListNode
	if Value == nil then
		error("Value passed to LinkedList:Push was nil!", 2)
	end

	self.Length += 1
	local Previous: ListNode? = self.Last
	local Node = ListNode.new()
	Node.List = self
	Node.Previous = Previous
	Node.Value = Value

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
	@param [t:LinkedList] List The `LinkedList` you are appending from.
	@returns [t:void]
**--]]
function LinkedList:Append(List: LinkedList)
	if not LinkedList.Is(List) then
		error(string.format(INVALID_ARGUMENT_ERROR, 2, "LinkedList:Append", "LinkedList", Types.TypeOf(List)), 2)
	end

	for _, NodeValue in List:Iterator() do
		self:Push(NodeValue)
	end
end

--[[**
	Adds the element `Value` to the start of the list. This operation should compute in O(1) time and O(1) memory.
	@param [t:any] Value The value you are prepending.
	@returns [t:ListNode] The prepended node.
**--]]
function LinkedList:PushFront(Value: any)
	if Value == nil then
		error("Value passed to LinkedList:PushFront was nil!", 2)
	end

	self.Length += 1
	local Next: ListNode? = self.First
	local Node = ListNode.new()
	Node.List = self
	Node.Next = Next
	Node.Previous = nil
	Node.Value = Value

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
	@param [t:LinkedList] List The `LinkedList` you are prepending from.
	@returns [t:void]
**--]]
function LinkedList:Prepend(List: LinkedList)
	if not LinkedList.Is(List) then
		error(string.format(INVALID_ARGUMENT_ERROR, 2, "LinkedList:Prepend", "LinkedList", Types.TypeOf(List)), 2)
	end

	for _, NodeValue in List:ReverseIterator() do
		self:PushFront(NodeValue)
	end
end

--[[**
	Removes the first element and returns it, or `nil` if the list is empty. This operation should compute in O(1) time.
	@returns [t:ListNode?] The popped node, if there was one.
**--]]
function LinkedList:Pop(): ListNode?
	if self.Length == 0 then
		return nil
	else
		local Node: ListNode? = self.First
		if Node then
			Node:Destroy()
			return Node
		else
			return nil
		end
	end
end

--[[**
	Removes the last element and returns it, or `nil` if the list is empty. This operation should compute in O(1) time.
	@returns [t:ListNode?] The popped node, if there was one.
**--]]
function LinkedList:PopBack(): ListNode?
	if self.Length == 0 then
		return nil
	else
		local Node: ListNode? = self.Last
		if Node then
			Node:Destroy()
			return Node
		else
			return nil
		end
	end
end

--[[**
	Returns `true` if the `LinkedList` is empty. This operation should compute in O(1) time.
	@returns [t:boolean]
**--]]
function LinkedList:IsEmpty(): boolean
	return self.Length <= 0
end

--[[**
	Removes all elements from the `LinkedList`. This operation should compute in O(n) time.
	@returns [t:LinkedList]
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
	@param [t:ListNode|any] Value The value you are searching for.
	@returns [t:boolean]
**--]]
function LinkedList:Contains(Value: ListNode | any): boolean
	if ListNode.Is(Value) then
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
		return nil, nil
	else
		return Node, Node.Value
	end
end

function LinkedList:_ReverseIterator(Node: ListNode?): (ListNode?, any?)
	Node = not Node and self.Last or Node and Node.Previous
	if not Node then
		return nil, nil
	else
		return Node, Node.Value
	end
end

--[[**
	Provides a forward iterator.
	@returns [t:ListIterator]
**--]]
function LinkedList:Iterator()
	return LinkedList._Iterator, self
end

--[[**
	Provides a reverse iterator.
	@returns [t:ListIterator]
**--]]
function LinkedList:ReverseIterator()
	return LinkedList._ReverseIterator, self
end

--[[**
	Returns an array containing all of the elements in this list in proper sequence (from first to last element).
	@returns [t:Array<any>] An array with every element in the `LinkedList`.
**--]]
function LinkedList:ToArray(): Array<any>
	local Array = table.create(self.Length)
	local Length = 0
	for _, Value in self:Iterator() do
		Length += 1
		Array[Length] = Value
	end

	return Array
end

--[[**
	Removes the element at the given index from the `LinkedList`. This operation should compute in O(n) time.
	@param [t:int] Index The index of the node you want to remove.
	@returns [t:LinkedList]
**--]]
function LinkedList:Remove(Index: int): LinkedList
	local Length = self.Length
	if Index > Length or Index < 1 then
		error(string.format("Index %d is out of the range of [1, %d]", Index, Length), 2)
	end

	local CurrentNode: ListNode? = self.First
	local CurrentIndex = 0

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

			self.Length = Length - 1
			break
		end

		CurrentNode = CurrentNode.Next
	end

	return self
end

--[[**
	Removes any element with the given value from the `LinkedList`. This operation should compute in O(n) time.
	@param [t:any] Value The value you want to remove from the `LinkedList`.
	@returns [t:LinkedList]
**--]]
function LinkedList:RemoveValue(Value: any): LinkedList
	local CurrentNode: ListNode? = self.First
	local Length = self.Length

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

			Length -= 1
		end

		CurrentNode = CurrentNode.Next
	end

	self.Length = Length
	return self
end

--[[**
	Removes the given `ListNode` from the `LinkedList`. This operation should compute in O(n) time.
	@param [t:ListNode] Node The node you want to remove from the `LinkedList`.
	@returns [t:LinkedList]
**--]]
function LinkedList:RemoveNode(Node: ListNode): LinkedList
	local CurrentNode: ListNode? = self.First
	local Length = self.Length

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

			Length -= 1
		end

		CurrentNode = CurrentNode.Next
	end

	self.Length = Length
	return self
end

function ListNode:After(Value: any): ListNode?
	local List: LinkedList? = self.List
	if List then
		List.Length += 1
		local Node = ListNode.new()
		Node.Previous = self
		Node.Next = self.Next
		Node.Value = Value

		if List.Last == self then
			List.Last = Node
		else
			self.Next.Previous = Node
		end

		self.Next = Node
		return Node
	end

	return nil
end

function ListNode:Before(Value: any): ListNode?
	local List: LinkedList? = self.List
	if List then
		List.Length += 1
		local Node = ListNode.new()
		Node.Previous = self.Previous
		Node.Next = self
		Node.Value = Value

		if List.First == self then
			List.First = Node
		else
			self.Previous.Next = Node
		end

		self.Previous = Node
		return Node
	end

	return nil
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
	end

	return false
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
	local ListArray = table.create(self.Length)
	for _, Value in self:Iterator() do
		table.insert(ListArray, tostring(Value))
	end

	return "LinkedList<[" .. table.concat(ListArray, ", ") .. "]>"
end

function ListNode:__tostring(): string
	return tostring(self.Value)
end

return LinkedList
