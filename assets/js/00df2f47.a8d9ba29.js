"use strict";(self.webpackChunkdocs=self.webpackChunkdocs||[]).push([[417],{16593:function(e){e.exports=JSON.parse('{"functions":[{"name":"new","desc":"Creates an empty `Queue`.","params":[],"returns":[{"desc":"","lua_type":"Queue<T>"}],"function_type":"static","source":{"line":32,"path":"src/DataStructures/Queue/init.lua"}},{"name":"Is","desc":"Determines whether the passed value is a Queue.","params":[{"name":"Value","desc":"The value to check.","lua_type":"any"}],"returns":[{"desc":"Whether or not the passed value is a Queue.","lua_type":"boolean"}],"function_type":"static","source":{"line":44,"path":"src/DataStructures/Queue/init.lua"}},{"name":"Push","desc":"Pushes the passed value to the end of the Queue.","params":[{"name":"Value","desc":"The value you are pushing.","lua_type":"T"}],"returns":[{"desc":"The passed value\'s location.","lua_type":"int"}],"function_type":"method","errors":[{"lua_type":"\\"InvalidValue\\"","desc":"Thrown when the value is nil."}],"source":{"line":55,"path":"src/DataStructures/Queue/init.lua"}},{"name":"Pop","desc":"Removes the first value from the Queue.","params":[],"returns":[{"desc":"The first value from the Queue, if it exists.","lua_type":"T?"}],"function_type":"method","source":{"line":72,"path":"src/DataStructures/Queue/init.lua"}},{"name":"GetFront","desc":"Gets the front value of the Queue.","params":[],"returns":[{"desc":"The first value.","lua_type":"T?"}],"function_type":"method","source":{"line":92,"path":"src/DataStructures/Queue/init.lua"}},{"name":"GetBack","desc":"Gets the last value of the Queue.","params":[],"returns":[{"desc":"The last value.","lua_type":"T?"}],"function_type":"method","source":{"line":100,"path":"src/DataStructures/Queue/init.lua"}},{"name":"IsEmpty","desc":"Determines if the Queue is empty.","params":[],"returns":[{"desc":"Whether or not the Queue is empty.","lua_type":"boolean"}],"function_type":"method","source":{"line":111,"path":"src/DataStructures/Queue/init.lua"}},{"name":"Iterator","desc":"Returns an iterator that can be used to iterate through the Queue.","params":[],"returns":[{"desc":"The iterator, which is used in a for loop.","lua_type":"QueueIterator"}],"function_type":"method","source":{"line":132,"path":"src/DataStructures/Queue/init.lua"}}],"properties":[{"name":"First","desc":"The index of the first element in the queue.","lua_type":"int","source":{"line":21,"path":"src/DataStructures/Queue/init.lua"}},{"name":"Length","desc":"The length of the queue.","lua_type":"int","source":{"line":27,"path":"src/DataStructures/Queue/init.lua"}}],"types":[],"name":"Queue","desc":"A Queue is a data structure that follows the first-in, first-out (FIFO).","source":{"line":8,"path":"src/DataStructures/Queue/init.lua"}}')}}]);