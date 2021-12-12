local Edge = require(script.Edge)
local Types = require(script.Parent.Types)
local Vertex = require(script.Vertex)

local Graph = {}
Graph.ClassName = "Graph"
Graph.__index = Graph

type Array<Value> = Types.Array<Value>
type int = Types.int
type NonNil = Types.NonNil

export type Edge<T> = Edge.Edge<T>
export type Vertex<T> = Vertex.Vertex<T>

function Graph.new()
	return setmetatable({
		AdjacencyList = {};
		ConnectedComponents = {};
	}, Graph)
end

function Graph.Is(Value)
	return type(Value) == "table" and getmetatable(Value) == Graph
end

local function FindComponent<T>(self, VertexKey: Vertex<T>)
	local CurrentVertex = VertexKey
	while CurrentVertex ~= self.ConnectedComponents[CurrentVertex] do
		CurrentVertex = self.ConnectedComponents[CurrentVertex]
	end

	return CurrentVertex
end

local function GetAllComponents<T>(self)
	local SetOfVertex = {}
	for VertexKey in next, self.ConnectedComponents do
		SetOfVertex[FindComponent(self, VertexKey)] = true
	end

	return SetOfVertex
end

local function PerformBFS<T>(self, RootVertex: Vertex<T>, Element: T)
	if RootVertex == nil then
		error("RootVertex cannot be nil.", 2)
	end

	if Element == nil then
		error("Element cannot be nil.", 2)
	end

	if not self.AdjacencyList[RootVertex] then
		error("RootVertex is not in the graph.", 2)
	end

	for VertexKey in next, self.AdjacencyList do
		VertexKey.Visited = false
	end

	local Queue = {}
	table.insert(Queue, RootVertex)
	RootVertex.Visited = false

	while #Queue ~= 0 do
		local VertexToBeProcessed = table.remove(Queue, 1)
		if VertexToBeProcessed.Data == Element then
			return VertexToBeProcessed
		end
		--https://github.com/deepak-malik/Data-Structures-In-Java/blob/master/src/com/deepak/data/structures/Graph/Graph.java
	end
end

local function FindVertex<T>(self, Element: T)
	if Element == nil then
		error("Element cannot be nil.", 2)
	end

	local VertexSet = {}
	for VertexKey in next, self.ConnectedComponents do
		VertexSet[FindComponent(self, VertexKey)] = true
	end

	for VertexFromSet in next, VertexSet do
		local FoundVertex = PerformBFS(self, VertexFromSet, Element)
	end
end

function Graph:AddVertex(Element)
	if Element == nil then
		error("Element cannot be nil.", 2)
	end

	local NewVertex = 1
	return NewVertex
end

function Graph:__tostring()
	return "Graph"
end

export type Graph<T> = typeof(Graph.new())
table.freeze(Graph)
return Graph
