"use strict";(self.webpackChunkdocs=self.webpackChunkdocs||[]).push([[65],{25562:function(e){e.exports=JSON.parse('{"functions":[{"name":"new","desc":"Creates a new `MinPriorityQueue`.","params":[],"returns":[{"desc":"","lua_type":"MinPriorityQueue<T>"}],"function_type":"static","source":{"line":37,"path":"src/DataStructures/PriorityQueues/MinPriorityQueue/init.lua"}},{"name":"Is","desc":"Determines whether the passed value is a MinPriorityQueue.","params":[{"name":"Value","desc":"The value to check.","lua_type":"any"}],"returns":[{"desc":"Whether or not the passed value is a MinPriorityQueue.","lua_type":"boolean"}],"function_type":"static","source":{"line":49,"path":"src/DataStructures/PriorityQueues/MinPriorityQueue/init.lua"}},{"name":"IsEmpty","desc":"Check whether the `MinPriorityQueue` has no elements.","params":[],"returns":[{"desc":"This will be true iff the queue is empty.","lua_type":"boolean"}],"function_type":"method","source":{"line":57,"path":"src/DataStructures/PriorityQueues/MinPriorityQueue/init.lua"}},{"name":"InsertWithPriority","desc":"Add an element to the `MinPriorityQueue` with an associated priority.","params":[{"name":"Value","desc":"The value of the element.","lua_type":"T"},{"name":"Priority","desc":"The priority of the element.","lua_type":"number"}],"returns":[{"desc":"The inserted position.","lua_type":"int"}],"function_type":"method","errors":[{"lua_type":"\\"InvalidValue\\"","desc":"Thrown when the value is nil."}],"source":{"line":104,"path":"src/DataStructures/PriorityQueues/MinPriorityQueue/init.lua"}},{"name":"ChangePriority","desc":"Changes the priority of the given value in the `MinPriorityQueue`.","params":[{"name":"Value","desc":"The value you are updating the priority of.","lua_type":"T"},{"name":"NewPriority","desc":"The new priority of the value.","lua_type":"number"}],"returns":[{"desc":"The new position of the HeapEntry if it was found. This function will error if it couldn\'t find the value.","lua_type":"int?"}],"function_type":"method","errors":[{"lua_type":"\\"InvalidValue\\"","desc":"Thrown when the value is nil."},{"lua_type":"\\"CouldNotFind\\"","desc":"Thrown when the value couldn\'t be found."}],"source":{"line":136,"path":"src/DataStructures/PriorityQueues/MinPriorityQueue/init.lua"}},{"name":"GetFirstPriority","desc":"Gets the priority of the first value in the `MinPriorityQueue`. This is the value that will be removed last.","params":[],"returns":[{"desc":"The priority of the first value.","lua_type":"number?"}],"function_type":"method","source":{"line":157,"path":"src/DataStructures/PriorityQueues/MinPriorityQueue/init.lua"}},{"name":"GetLastPriority","desc":"Gets the priority of the last value in the `MinPriorityQueue`. This is the value that will be removed first.","params":[],"returns":[{"desc":"The priority of the last value.","lua_type":"number?"}],"function_type":"method","source":{"line":169,"path":"src/DataStructures/PriorityQueues/MinPriorityQueue/init.lua"}},{"name":"PopElement","desc":"Remove the element from the `MinPriorityQueue` that has the highest priority, and return it.","params":[{"name":"OnlyValue","desc":"Whether or not to return only the value or the entire entry.","lua_type":"boolean?"}],"returns":[{"desc":"The removed element.","lua_type":"T | HeapEntry?"}],"function_type":"method","source":{"line":183,"path":"src/DataStructures/PriorityQueues/MinPriorityQueue/init.lua"}},{"name":"ToArray","desc":"Converts the entire `MinPriorityQueue` to an array.","params":[{"name":"OnlyValues","desc":"Whether or not the array is just the values or the priorities as well.","lua_type":"boolean?"}],"returns":[{"desc":"The `MinPriorityQueue`\'s array.","lua_type":"Array<T> | Array<HeapEntry<T>>"}],"function_type":"method","source":{"line":201,"path":"src/DataStructures/PriorityQueues/MinPriorityQueue/init.lua"}},{"name":"Iterator","desc":"Returns an iterator function for iterating over the `MinPriorityQueue`.\\n\\n:::warning Performance\\nIf you care about performance, do not use this function. Just do `for Index, Value in ipairs(MinPriorityQueue.Heap) do` directly.\\n:::","params":[{"name":"OnlyValues","desc":"","lua_type":"boolean? Whether or not the iterator returns just the values or the priorities as well."}],"returns":[{"desc":"The iterator function. Usage is `for Index, Value in MinPriorityQueue:Iterator(OnlyValues) do`.","lua_type":"IteratorFunction"}],"function_type":"method","source":{"line":230,"path":"src/DataStructures/PriorityQueues/MinPriorityQueue/init.lua"}},{"name":"ReverseIterator","desc":"Returns an iterator function for iterating over the `MinPriorityQueue` in reverse.","params":[{"name":"OnlyValues","desc":"Whether or not the iterator returns just the values or the priorities as well.","lua_type":"boolean?"}],"returns":[{"desc":"The iterator function. Usage is `for Index, Value in MinPriorityQueue:ReverseIterator(OnlyValues) do`.","lua_type":"IteratorFunction"}],"function_type":"method","source":{"line":248,"path":"src/DataStructures/PriorityQueues/MinPriorityQueue/init.lua"}},{"name":"Clear","desc":"Clears the entire `MinPriorityQueue`.","params":[],"returns":[{"desc":"The same `MinPriorityQueue`.","lua_type":"MinPriorityQueue<T>"}],"function_type":"method","source":{"line":276,"path":"src/DataStructures/PriorityQueues/MinPriorityQueue/init.lua"}},{"name":"Contains","desc":"Determines if the `MinPriorityQueue` contains the given value.","params":[{"name":"Value","desc":"The value you are searching for.","lua_type":"T"}],"returns":[{"desc":"Whether or not the value was found.","lua_type":"boolean"}],"function_type":"method","errors":[{"lua_type":"\\"InvalidValue\\"","desc":"Thrown when the value is nil."}],"source":{"line":289,"path":"src/DataStructures/PriorityQueues/MinPriorityQueue/init.lua"}},{"name":"RemovePriority","desc":"Removes the `HeapEntry` with the given priority, if it exists.","params":[{"name":"Priority","desc":"The priority you are removing from the `MinPriorityQueue`.","lua_type":"number"}],"returns":[],"function_type":"method","source":{"line":307,"path":"src/DataStructures/PriorityQueues/MinPriorityQueue/init.lua"}},{"name":"RemoveValue","desc":"Removes the `HeapEntry` with the given value, if it exists.","params":[{"name":"Value","desc":"The value you are removing from the `MinPriorityQueue`.","lua_type":"T"}],"returns":[],"function_type":"method","errors":[{"lua_type":"\\"InvalidValue\\"","desc":"Thrown when the value is nil."}],"source":{"line":323,"path":"src/DataStructures/PriorityQueues/MinPriorityQueue/init.lua"}}],"properties":[{"name":"Length","desc":"The length of the MinPriorityQueue.","lua_type":"int","source":{"line":26,"path":"src/DataStructures/PriorityQueues/MinPriorityQueue/init.lua"}},{"name":"Heap","desc":"The heap data of the MinPriorityQueue.","lua_type":"Array<T>","source":{"line":32,"path":"src/DataStructures/PriorityQueues/MinPriorityQueue/init.lua"}}],"types":[],"name":"MinPriorityQueue","desc":"In a min priority queue, elements are inserted in the order in which they arrive the queue and the smallest value is always removed first from the queue.","source":{"line":8,"path":"src/DataStructures/PriorityQueues/MinPriorityQueue/init.lua"}}')}}]);