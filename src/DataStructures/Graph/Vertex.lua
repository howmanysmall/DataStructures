--[=[
	@class Vertex
]=]
local Vertex = {}
Vertex.ClassName = "Vertex"
Vertex.__index = Vertex

--[=[
	@within Vertex
	@prop Data T
	The data of the vertex.
]=]

--[=[
	@within Vertex
	@prop Visited boolean
	Whether the vertex has been visited.
]=]

--[=[
	@within Vertex
	@prop Parent Vertex<T>?
	The parent vertex.
]=]

function Vertex.new<T>(Data: T)
	return setmetatable({
		Data = Data;
		Parent = nil;
		Visited = false;
	}, Vertex)
end

function Vertex.Is(Value)
	return type(Value) == "table" and getmetatable(Value) == Vertex
end

function Vertex:__eq(Other)
	if type(self) ~= "table" or getmetatable(self) ~= Vertex then
		error("self is not a Vertex", 2)
	end

	if type(Other) ~= "table" or getmetatable(Other) ~= Vertex then
		error("Other is not a Vertex", 2)
	end

	return self.Data == Other.Data
end

function Vertex:__tostring()
	return string.format("Vertex<%s>", tostring(self.Data))
end

export type Vertex<T> = typeof(Vertex.new(1))
table.freeze(Vertex)
return Vertex
