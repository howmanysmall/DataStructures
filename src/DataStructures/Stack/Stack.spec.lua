return function()
	local Stack = require(script.Parent)

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

	describe("Stack.new", function()
		it("should return a Stack", function()
			expect(TypeOf(Stack.new())).to.equal("Stack")
		end)
	end)

	describe("Stack.Is", function()
		it("should return true for Stacks, false for anything else", function()
			expect(Stack.Is(Stack.new())).to.equal(true)
			expect(Stack.Is(ThrowawayClass.new())).to.equal(false)
			expect(Stack.Is(1)).to.equal(false)
		end)
	end)

	describe("Stack:Push", function()
		it("should throw if the passed value is nil", function()
			expect(function()
				Stack.new():Push(nil)
			end).to.throw()
		end)

		it("should return the position", function()
			local TestStack = Stack.new()
			expect(TestStack:Push(1)).to.equal(1)
			expect(TestStack:Push(2)).to.equal(2)
		end)

		it("should push to the end of the stack", function()
			local TestStack = Stack.new()
			TestStack:Push(1)
			TestStack:Push(2)
			expect(TestStack[TestStack.Length]).to.equal(2)
		end)
	end)

	describe("Stack:Pop", function()
		it("should return nil if the stack is empty", function()
			expect(Stack.new():Pop()).to.equal(nil)
		end)

		it("should remove and return the last value", function()
			local TestStack = Stack.new()
			TestStack:Push(1)
			TestStack:Push(2)
			TestStack:Push(3)

			expect(TestStack[1]).to.equal(1)
			expect(TestStack[TestStack.Length]).to.equal(3)
			expect(TestStack:Pop()).to.equal(3)
		end)
	end)

	describe("Stack:Bottom", function()
		it("should return the first value", function()
			local TestStack = Stack.new()
			TestStack:Push(1)
			TestStack:Push(2)
			expect(TestStack:Bottom()).to.equal(1)
		end)
	end)

	describe("Stack:Top", function()
		it("should return the last value", function()
			local TestStack = Stack.new()
			TestStack:Push(1)
			TestStack:Push(2)
			expect(TestStack:Top()).to.equal(2)
		end)
	end)

	describe("Stack:IsEmpty", function()
		it("should return true iff the queue is empty", function()
			local TestStack = Stack.new()
			expect(TestStack:IsEmpty()).to.equal(true)
			TestStack:Push(1)
			expect(TestStack:IsEmpty()).to.equal(false)
		end)
	end)

	describe("Stack:Iterator", function()
		it("should return an iterator", function()
			expect(Stack.new():Iterator()).to.be.a("function")
		end)

		-- how do I even test this
		it("should return the index and value", function()
			local TestStack = Stack.new()
			TestStack:Push(4)
			TestStack:Push(3)
			TestStack:Push(2)
			TestStack:Push(1)

			local Array = table.create(TestStack.Length)
			for Index, Value in TestStack:Iterator() do
				table.insert(Array, string.format("[%d,%d]", Index, Value))
			end

			expect(table.concat(Array, ", ")).to.equal("[1,4], [2,3], [3,2], [4,1]")
		end)
	end)
end
