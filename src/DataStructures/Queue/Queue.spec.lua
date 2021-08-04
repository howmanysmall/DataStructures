return function()
	local Queue = require(script.Parent)

	local function TypeOf(Value)
		local ValueType = typeof(Value)
		if ValueType == "table" then
			local Metatable = getmetatable(Value)
			if type(Metatable) == "table" then
				local CustomType = Metatable.__type or Metatable.ClassName
				if CustomType then
					return CustomType
				end
			end
		end

		return ValueType
	end

	local ThrowawayClass = {}
	ThrowawayClass.ClassName = "ThrowawayClass"
	ThrowawayClass.__index = ThrowawayClass

	function ThrowawayClass.new()
		return setmetatable({}, ThrowawayClass)
	end

	function ThrowawayClass:__tostring()
		return "ThrowawayClass"
	end

	describe("Queue.new", function()
		it("should return a Queue", function()
			expect(TypeOf(Queue.new())).to.equal("Queue")
		end)
	end)

	describe("Queue.Is", function()
		it("should return true for Queues, false for anything else", function()
			expect(Queue.Is(Queue.new())).to.equal(true)
			expect(Queue.Is(ThrowawayClass.new())).to.equal(false)
			expect(Queue.Is(1)).to.equal(false)
		end)
	end)

	describe("Queue:Push", function()
		it("should throw if the passed value is nil", function()
			expect(function()
				Queue.new():Push(nil)
			end).to.throw()
		end)

		it("should return the position", function()
			local TestQueue = Queue.new()
			expect(TestQueue:Push(1)).to.equal(1)
			expect(TestQueue:Push(2)).to.equal(2)
		end)

		it("should push to the end of the queue", function()
			local TestQueue = Queue.new()
			TestQueue:Push(1)
			TestQueue:Push(2)
			expect(TestQueue[TestQueue.Length]).to.equal(2)
		end)
	end)

	describe("Queue:Pop", function()
		it("should return nil if the queue is empty", function()
			expect(Queue.new():Pop()).to.equal(nil)
		end)

		it("should remove and return the first value", function()
			local TestQueue = Queue.new()
			TestQueue:Push(1)
			TestQueue:Push(2)
			TestQueue:Push(3)

			expect(TestQueue[1]).to.equal(1)
			expect(TestQueue:Pop()).to.equal(1)
		end)
	end)

	describe("Queue:Front", function()
		it("should return the first value", function()
			local TestQueue = Queue.new()
			TestQueue:Push(1)
			TestQueue:Push(2)
			expect(TestQueue:Front()).to.equal(1)
		end)
	end)

	describe("Queue:Back", function()
		it("should return the last value", function()
			local TestQueue = Queue.new()
			TestQueue:Push(1)
			TestQueue:Push(2)
			expect(TestQueue:Back()).to.equal(2)
		end)
	end)

	describe("Queue:IsEmpty", function()
		it("should return true iff the queue is empty", function()
			local TestQueue = Queue.new()
			expect(TestQueue:IsEmpty()).to.equal(true)
			TestQueue:Push(1)
			expect(TestQueue:IsEmpty()).to.equal(false)
		end)
	end)

	describe("Queue:Iterator", function()
		it("should return an iterator", function()
			expect(Queue.new():Iterator()).to.be.a("function")
		end)

		-- how do I even test this
		it("should return the index and value", function()
			local TestQueue = Queue.new()
			TestQueue:Push(4)
			TestQueue:Push(3)
			TestQueue:Push(2)
			TestQueue:Push(1)

			local Array = table.create(TestQueue.Length)
			for Index, Value in TestQueue:Iterator() do
				table.insert(Array, string.format("[%d,%d]", Index, Value))
			end

			expect(table.concat(Array, ", ")).to.equal("[1,4], [2,3], [3,2], [4,1]")
		end)
	end)
end
