return function()
	local SortedArray = require(script.Parent)

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

	local function SortReverse(A, B)
		return A > B
	end

	describe("SortedArray.new", function()
		it("should return a SortedArray", function()
			expect(TypeOf(SortedArray.new({1, 2, 3}))).to.equal("SortedArray")
		end)

		it("should be sorted", function()
			expect(tostring(SortedArray.new({4, 3, 1, 2}))).to.equal("SortedArray<[1, 2, 3, 4]>")
			expect(tostring(SortedArray.new({4, 3, 1, 2}, SortReverse))).to.equal("SortedArray<[4, 3, 2, 1]>")
		end)
	end)

	describe("SortedArray:FilterToSortedArray", function()
		it("should return a SortedArray", function()
			local Array = SortedArray.new({1, 2, 3, 4, 5, 6, 7, 8, 9, 10})
			expect(TypeOf(Array:FilterToSortedArray(function(Value)
				return Value % 2 == 0
			end))).to.equal("SortedArray")
		end)

		it("should filter based on a function", function()
			local Array = SortedArray.new({1, 2, 3, 4, 5, 6, 7, 8, 9, 10})
			expect(tostring(Array:FilterToSortedArray(function(Value)
				return Value % 2 == 0
			end))).to.equal("SortedArray<[2, 4, 6, 8, 10]>")
		end)
	end)

	describe("SortedArray:SliceToSortedArray", function()
		it("should return a SortedArray", function()
			expect(TypeOf(SortedArray.new({1, 2, 3, 4, 5, 6, 7, 8, 9, 10}):SliceToSortedArray(4, 8))).to.equal(
				"SortedArray"
			)
		end)

		it("should slice properly for positive indices", function()
			expect(tostring(SortedArray.new({1, 2, 3, 4, 5, 6, 7, 8, 9, 10}):SliceToSortedArray(4, 8))).to.equal(
				"SortedArray<[5, 6, 7, 8]>"
			)
		end)

		it("should slice properly for negative indices", function()
			expect(tostring(SortedArray.new({1, 2, 3, 4, 5, 6, 7, 8, 9, 10}):SliceToSortedArray(-6, 8))).to.equal(
				"SortedArray<[5, 6, 7, 8]>"
			)
		end)
	end)

	describe("SortedArray:MapFilterToSortedArray", function()
		it("should return a SortedArray", function()
			expect(TypeOf(SortedArray.new({1, 2, 3, 4, 5, 6, 7, 8, 9, 10}):MapFilterToSortedArray(function(Value)
				return if Value % 2 == 0 then Value * 2 else nil
			end))).to.equal("SortedArray")
		end)

		it("should filter based on a function", function()
			expect(tostring(SortedArray.new({1, 2, 3, 4, 5, 6, 7, 8, 9, 10}):MapFilterToSortedArray(function(Value)
				return if Value % 2 == 0 then Value * 2 else nil
			end))).to.equal("SortedArray<[4, 8, 12, 16, 20]>")
		end)
	end)

	describe("SortedArray:Insert", function()
		it("should insert at the right position", function()
			expect(SortedArray.new({1, 2, 4}):Insert(3)).to.equal(3)
		end)

		it("should insert at the right position with a custom compare function", function()
			expect(SortedArray.new({1, 2, 4}, SortReverse):Insert(3)).to.equal(2)
		end)
	end)

	describe("SortedArray:Find", function()
		it("should find the correct index", function()
			expect(SortedArray.new({1, 2, 3, 4}):Find(3)).to.equal(3)
		end)

		it("should return nil if the value does not exist", function()
			expect(SortedArray.new({1, 2, 3, 4}):Find(5)).to.equal(nil)
		end)
	end)
end
