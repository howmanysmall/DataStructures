return function()
	local CircularBuffer = require(script.Parent)

	local function TypeOf(Value)
		local ValueType = typeof(Value)
		if ValueType == "table" then
			local Metatable = getmetatable(Value)
			if type(Metatable) == "table" then
				local CustomType = Metatable.__type or Metatable.ClassName
				if CustomType then
					return CustomType
				else
					return ValueType
				end
			else
				return ValueType
			end
		else
			return ValueType
		end
	end

	describe("CircularBuffer.new", function()
		it("should return a CircularBuffer", function()
			expect(TypeOf(CircularBuffer.new(1))).to.equal("CircularBuffer")
		end)

		it("should throw if the MaxCapacity isn't a number", function()
			expect(function()
				CircularBuffer.new("")
			end).to.throw()
		end)

		it("should throw if the MaxCapacity is less than 1", function()
			expect(function()
				CircularBuffer.new(0)
			end).to.throw()
		end)
	end)

	describe("CircularBuffer:Push", function()
		it("should return the removed value", function()
			local Buffer = CircularBuffer.new(1)
			Buffer:Push(1)
			expect(Buffer:Push(2)).to.equal(1)
		end)

		it("should push to the start", function()
			local Buffer = CircularBuffer.new(2)
			Buffer:Push(1)
			Buffer:Push(2)
			expect(Buffer:PeekAt()).to.equal(2)
		end)

		it("should throw if the data is nil", function()
			expect(function()
				CircularBuffer.new(1):Push(nil)
			end).to.throw()
		end)
	end)

	describe("CircularBuffer:Replace", function()
		it("should return the removed value", function()
			local Buffer = CircularBuffer.new(2)
			Buffer:Push(1)
			Buffer:Push(2)
			expect(Buffer:Replace(1, 3)).to.equal(2)
		end)

		it("should throw if the index isn't a number", function()
			expect(function()
				CircularBuffer.new(1):Insert("", {})
			end).to.throw()
		end)

		it("should throw if the value is nil", function()
			expect(function()
				local Buffer = CircularBuffer.new(2)
				Buffer:Push(1)
				Buffer:Replace(1, nil)
			end).to.throw()
		end)

		it("should throw if the index didn't exist", function()
			expect(function()
				CircularBuffer.new(2):Replace(1, true)
			end).to.throw()
		end)
	end)

	describe("CircularBuffer:Insert", function()
		it("should return the replaced value", function()
			local Buffer = CircularBuffer.new(2)
			Buffer:Push(1)
			Buffer:Push(2)
			expect(Buffer:Insert(1, 3)).to.equal(1)
		end)

		it("should throw if the index isn't a number", function()
			expect(function()
				CircularBuffer.new(2):Insert("", {})
			end).to.throw()
		end)

		it("should throw if the value is nil", function()
			expect(function()
				CircularBuffer.new(2):Insert(1, nil)
			end).to.throw()
		end)
	end)

	describe("CircularBuffer:IsEmpty", function()
		it("should return a boolean", function()
			expect(CircularBuffer.new(1):IsEmpty()).to.be.a("boolean")
		end)

		it("should return the correct value", function()
			local Buffer = CircularBuffer.new(2)
			expect(Buffer:IsEmpty()).to.equal(true)
			Buffer:Push(1)
			expect(Buffer:IsEmpty()).to.equal(false)
		end)
	end)

	describe("CircularBuffer:IsFull", function()
		it("should return a boolean", function()
			expect(CircularBuffer.new(1):IsFull()).to.be.a("boolean")
		end)

		it("should return the correct value", function()
			local Buffer = CircularBuffer.new(1)
			expect(Buffer:IsFull()).to.equal(false)
			Buffer:Push(1)
			expect(Buffer:IsFull()).to.equal(true)
		end)
	end)

	describe("CircularBuffer:Clear", function()
		it("should return a LinkedList", function()
			expect(TypeOf(CircularBuffer.new(5):Clear())).to.equal("CircularBuffer")
		end)

		it("should remove everything", function()
			local Buffer = CircularBuffer.new(2)
			Buffer:Push(1)
			Buffer:Clear()
			expect(Buffer:IsEmpty()).to.equal(true)
		end)
	end)
end
