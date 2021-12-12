local Vertex = require(script.Parent.Vertex)
local Types = require(script.Parent.Parent.Types)

local Edge = {}
Edge.ClassName = "Edge"
Edge.__index = Edge

type Array<Value> = Types.Array<Value>
type int = Types.int
type NonNil = Types.NonNil

type Vertex<T> = Vertex.Vertex<T>

function Edge.new<T>(FirstVertex: Vertex<T>, SecondVertex: Vertex<T>)
	if FirstVertex == nil then
		error("invalid argument #1 to 'Edge.new' (expected Vertex<T>, got nil)", 2)
	end

	if SecondVertex == nil then
		error("invalid argument #2 to 'Edge.new' (expected Vertex<T>, got nil)", 2)
	end

	return setmetatable({
		FirstVertex = FirstVertex;
		SecondVertex = SecondVertex;
	}, Edge)
end

function Edge.Is(Value)
	return type(Value) == "table" and getmetatable(Value) == Edge
end

function Edge:GetAdjacentVertex(UseVertex: Vertex<any>)
	if UseVertex == self.FirstVertex then
		return self.SecondVertex
	elseif UseVertex == self.SecondVertex then
		return self.FirstVertex
	else
		return nil
	end
end

function Edge:__eq(Other)
	if type(self) ~= "table" or getmetatable(self) ~= Edge then
		error("self is not an Edge", 2)
	end

	if type(Other) ~= "table" or getmetatable(Other) ~= Edge then
		error("Other is not an Edge", 2)
	end

	return self.FirstVertex == Other.FirstVertex and self.SecondVertex == Other.SecondVertex
		or self.FirstVertex == Other.SecondVertex and self.SecondVertex == Other.FirstVertex
end

function Edge:__tostring()
	return string.format("Edge<%s, %s>", tostring(self.FirstVertex), tostring(self.SecondVertex))
end

export type Edge<T> = typeof(Edge.new(Vertex.new(1), Vertex.new(2)))
table.freeze(Edge)
return Edge
