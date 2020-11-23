return function()
	local MinPriorityQueue = require(script.Parent)

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

	describe("MinPriorityQueue.new", function()
		it("should return a MinPriorityQueue", function()
			expect(TypeOf(MinPriorityQueue.new())).to.equal("MinPriorityQueue")
		end)
	end)

	describe("MinPriorityQueue:IsEmpty", function()
		it("should return a boolean", function()
			expect(MinPriorityQueue.new():IsEmpty()).to.be.a("boolean")
		end)

		it("should return true if empty", function()
			expect(MinPriorityQueue.new():IsEmpty()).to.equal(true)
		end)

		it("should return false if not empty", function()
			local PriorityQueue = MinPriorityQueue.new()
			PriorityQueue:InsertWithPriority("Value", 1)
			expect(PriorityQueue:IsEmpty()).to.equal(false)
		end)
	end)

	describe("MinPriorityQueue:InsertWithPriority", function()
		it("should return a number", function()
			expect(MinPriorityQueue.new():InsertWithPriority("1", 1)).to.be.a("number")
		end)

		it("should insert into the proper location", function()
			local PriorityQueue = MinPriorityQueue.new()
			PriorityQueue:InsertWithPriority("2", 2)
			PriorityQueue:InsertWithPriority("3", 3)
			expect(PriorityQueue:InsertWithPriority("1", 1)).to.equal(1)
		end)
	end)

	describe("MinPriorityQueue:ChangePriority", function()
		it("should return a number", function()
			local PriorityQueue = MinPriorityQueue.new()
			PriorityQueue:InsertWithPriority("1", 4)
			PriorityQueue:InsertWithPriority("2", 2)
			PriorityQueue:InsertWithPriority("3", 3)
			expect(PriorityQueue:ChangePriority("1", 1)).to.be.a("number")
		end)

		it("should return the correct position", function()
			local PriorityQueue = MinPriorityQueue.new()
			PriorityQueue:InsertWithPriority("1", 4)
			PriorityQueue:InsertWithPriority("2", 2)
			PriorityQueue:InsertWithPriority("3", 3)
			expect(PriorityQueue:ChangePriority("1", 1)).to.equal(1)
		end)

		it("should throw if the passed value is null", function()
			expect(function()
				MinPriorityQueue.new():ChangePriority("1", 1)
			end).to.throw()
		end)
	end)

	-- describe("LinkedList::Prepend", function()
	-- 	it("should throw if the argument passed is not a LinkedList", function()
	-- 		expect(function()
	-- 			MinPriorityQueue.new():Prepend(1)
	-- 		end).to.throw()
	-- 	end)

	-- 	it("should push a LinkedList to the start of the list", function()
	-- 		local List = MinPriorityQueue.new {3, 4}
	-- 		List:Prepend(MinPriorityQueue.new {1, 2})
	-- 		expect(List.Length).to.equal(4)
	-- 		expect(tostring(List)).to.equal("[1, 2, 3, 4]")
	-- 	end)
	-- end)
end