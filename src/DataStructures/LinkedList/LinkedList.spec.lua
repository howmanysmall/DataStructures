return function()
	local LinkedList = require(script.Parent)

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

	describe("LinkedList.new", function()
		it("should return a LinkedList", function()
			expect(TypeOf(LinkedList.new())).to.equal("LinkedList")
		end)

		it("should allow an array to be passed", function()
			local List = LinkedList.new {1, 2, 3, 4}
			expect(TypeOf(List)).to.equal("LinkedList")
			expect(List.Length).to.equal(4)
			expect(tostring(List)).to.equal("[1, 2, 3, 4]")
		end)

		it("should throw if anything but an array or nil is passed", function()
			expect(function()
				LinkedList.new(5)
			end).to.throw()
		end)
	end)

	describe("LinkedList:Push", function()
		it("should return a ListNode", function()
			expect(TypeOf(LinkedList.new():Push(1))).to.equal("ListNode")
		end)

		it("should push to the end of the list", function()
			local List = LinkedList.new {1, 2, 3}
			List:Push(4)
			expect(List.Length).to.equal(4)
			expect(tostring(List)).to.equal("[1, 2, 3, 4]")
		end)

		it("should throw if nil is passed", function()
			expect(function()
				LinkedList.new():Push(nil)
			end).to.throw()
		end)
	end)

	describe("LinkedList:Append", function()
		it("should throw if the argument passed is not a LinkedList", function()
			expect(function()
				LinkedList.new():Append(1)
			end).to.throw()
		end)

		it("should push a LinkedList to the end of the list", function()
			local List = LinkedList.new {1, 2}
			List:Append(LinkedList.new {3, 4})
			expect(List.Length).to.equal(4)
			expect(tostring(List)).to.equal("[1, 2, 3, 4]")
		end)
	end)

	describe("LinkedList:PushFront", function()
		it("should return a ListNode", function()
			expect(TypeOf(LinkedList.new():PushFront(1))).to.equal("ListNode")
		end)

		it("should push to the front of the list", function()
			local List = LinkedList.new {2, 3, 4}
			List:PushFront(1)
			expect(List.Length).to.equal(4)
			expect(tostring(List)).to.equal("[1, 2, 3, 4]")
		end)

		it("should throw if nil is passed", function()
			expect(function()
				LinkedList.new():PushFront(nil)
			end).to.throw()
		end)
	end)

	describe("LinkedList:Prepend", function()
		it("should throw if the argument passed is not a LinkedList", function()
			expect(function()
				LinkedList.new():Prepend(1)
			end).to.throw()
		end)

		it("should push a LinkedList to the start of the list", function()
			local List = LinkedList.new {3, 4}
			List:Prepend(LinkedList.new {1, 2})
			expect(List.Length).to.equal(4)
			expect(tostring(List)).to.equal("[1, 2, 3, 4]")
		end)
	end)

	describe("LinkedList:Pop", function()
		it("should return a ListNode", function()
			expect(TypeOf(LinkedList.new {1, 2, 3}:Pop())).to.equal("ListNode")
		end)

		it("should remove the first value", function()
			local List = LinkedList.new {1, 2, 3, 4}
			expect(List:Pop().Value).to.equal(1)
			expect(List.Length).to.equal(3)
			expect(tostring(List)).to.equal("[2, 3, 4]")
		end)
	end)

	describe("LinkedList:PopBack", function()
		it("should return a ListNode", function()
			expect(TypeOf(LinkedList.new {1, 2, 3}:PopBack())).to.equal("ListNode")
		end)

		it("should remove the last value", function()
			local List = LinkedList.new {1, 2, 3, 4}
			expect(List:PopBack().Value).to.equal(4)
			expect(List.Length).to.equal(3)
			expect(tostring(List)).to.equal("[1, 2, 3]")
		end)
	end)

	describe("LinkedList:IsEmpty", function()
		it("should return a boolean", function()
			expect(LinkedList.new():IsEmpty()).to.be.a("boolean")
		end)

		it("should return the correct value", function()
			expect(LinkedList.new():IsEmpty()).to.equal(true)
			expect(LinkedList.new(table.create(1, 1)):IsEmpty()).to.equal(false)
		end)
	end)

	describe("LinkedList:Clear", function()
		it("should return a LinkedList", function()
			expect(TypeOf(LinkedList.new(table.create(4, 1)):Clear())).to.equal("LinkedList")
		end)

		it("should remove everything", function()
			local List = LinkedList.new(table.create(4, 1)):Clear()
			expect(List:IsEmpty()).to.equal(true)
			expect(List.Length).to.equal(0)
			expect(tostring(List)).to.equal("[]")
		end)
	end)
end