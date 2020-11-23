local Queue = {ClassName = "Queue"}
Queue.__index = Queue

do
	local Object = setmetatable({
		First = 1;
		Length = 3;
		1, 2, 3;
	}, Queue)

	export type Queue = typeof(Object)
	export type QueueIterator = typeof(Object:Iterator())
end

type Array<Value> = {[number]: Value}
local null = nil

function Queue.new(): Queue
	return setmetatable({
		First = 1;
		Length = 0;
	}, Queue)
end

function Queue:Push(Value: any): number
	local Length: number = self.Length + 1
	self.Length = Length
	Length += self.First - 1

	self[Length] = Value
	return Length
end

function Queue:Pop(): any?
	local Length: number = self.Length
	if Length > 0 then
		local First: number = self.First
		local Value: any = self[First]
		self[First] = null

		self.First = First + 1
		self.Length = Length - 1

		return Value
	end
end

function Queue:Front(): any
	return self[self.First]
end

function Queue:IsEmpty(): boolean
	return self.Length == 0
end

function Queue:_Iterator(Position: number?): (number?, any?)
	local NewPosition: number = 1
	if Position then
		NewPosition = Position + 1
	end

	if NewPosition > self.Length then
		return null, null
	else
		return NewPosition, self[self.First + NewPosition - 1]
	end
end

function Queue:Iterator(): QueueIterator
	return Queue._Iterator, self
end

function Queue:__tostring(): string
	local QueueArray: Array<string> = table.create(self.Length)
	for Index, Value in self:Iterator() do
		QueueArray[Index] = tostring(Value)
	end

	return "[" .. table.concat(QueueArray, ", ") .. "]"
end

return Queue