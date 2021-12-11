"use strict";(self.webpackChunkdocs=self.webpackChunkdocs||[]).push([[138],{41196:function(e){e.exports=JSON.parse('{"functions":[{"name":"new","desc":"Creates an empty `LinkedList`.","params":[{"name":"Values","desc":"An optional array that contains the values you want to add.","lua_type":"Array<T>?"}],"returns":[{"desc":"","lua_type":"LinkedList<T>"}],"function_type":"static","source":{"line":38,"path":"src/DataStructures/LinkedList/init.lua"}},{"name":"Is","desc":"Determines whether the passed value is a LinkedList.","params":[{"name":"Value","desc":"The value to check.","lua_type":"any"}],"returns":[{"desc":"Whether or not the passed value is a LinkedList.","lua_type":"boolean"}],"function_type":"static","source":{"line":67,"path":"src/DataStructures/LinkedList/init.lua"}},{"name":"Push","desc":"Adds the element `Value` to the end of the list. This operation should compute in O(1) time and O(1) memory.","params":[{"name":"Value","desc":"The value you are appending.","lua_type":"T"}],"returns":[{"desc":"The appended node.","lua_type":"ListNode"}],"function_type":"method","errors":[{"lua_type":"InvalidValue","desc":"Thrown when the value passed is nil."}],"source":{"line":99,"path":"src/DataStructures/LinkedList/init.lua"}},{"name":"Append","desc":"Adds the elements from `List` to the end of the list. This operation should compute in O(1) time and O(1) memory.","params":[{"name":"List","desc":"The `LinkedList` you are appending from.","lua_type":"LinkedList<T>"}],"returns":[],"function_type":"method","errors":[{"lua_type":"InvalidList","desc":"Thrown when the List passed is not a LinkedList."}],"source":{"line":127,"path":"src/DataStructures/LinkedList/init.lua"}},{"name":"PushFront","desc":"Adds the element `Value` to the start of the list. This operation should compute in O(1) time and O(1) memory.","params":[{"name":"Value","desc":"The value you are prepending.","lua_type":"T"}],"returns":[{"desc":"The prepended node.","lua_type":"ListNode"}],"function_type":"method","errors":[{"lua_type":"InvalidValue","desc":"Thrown when the value passed is nil."}],"source":{"line":144,"path":"src/DataStructures/LinkedList/init.lua"}},{"name":"Prepend","desc":"Adds the elements from `List` to the start of the list. This operation should compute in O(1) time and O(1) memory.","params":[{"name":"List","desc":"The `LinkedList` you are prepending from.","lua_type":"LinkedList<T>"}],"returns":[],"function_type":"method","errors":[{"lua_type":"InvalidList","desc":"Thrown when the List passed is not a LinkedList."}],"source":{"line":173,"path":"src/DataStructures/LinkedList/init.lua"}},{"name":"Pop","desc":"Removes the first element and returns it, or `nil` if the list is empty. This operation should compute in O(1) time.","params":[],"returns":[{"desc":"The popped node, if there was one.","lua_type":"ListNode?"}],"function_type":"method","source":{"line":187,"path":"src/DataStructures/LinkedList/init.lua"}},{"name":"PopBack","desc":"Removes the last element and returns it, or `nil` if the list is empty. This operation should compute in O(1) time.","params":[],"returns":[{"desc":"The popped node, if there was one.","lua_type":"ListNode?"}],"function_type":"method","source":{"line":205,"path":"src/DataStructures/LinkedList/init.lua"}},{"name":"IsEmpty","desc":"Returns `true` if the `LinkedList` is empty. This operation should compute in O(1) time.","params":[],"returns":[{"desc":"","lua_type":"boolean"}],"function_type":"method","source":{"line":223,"path":"src/DataStructures/LinkedList/init.lua"}},{"name":"Clear","desc":"Removes all elements from the `LinkedList`. This operation should compute in O(n) time.","params":[],"returns":[{"desc":"","lua_type":"LinkedList<T>"}],"function_type":"method","source":{"line":231,"path":"src/DataStructures/LinkedList/init.lua"}},{"name":"Contains","desc":"Returns `true` if the `LinkedList` contains an element equal to the given value.","params":[{"name":"Value","desc":"The value you are searching for.","lua_type":"ListNode | any"}],"returns":[{"desc":"","lua_type":"boolean"}],"function_type":"method","source":{"line":247,"path":"src/DataStructures/LinkedList/init.lua"}},{"name":"Iterator","desc":"Provides a forward iterator.","params":[],"returns":[{"desc":"","lua_type":"ListIterator"}],"function_type":"method","source":{"line":287,"path":"src/DataStructures/LinkedList/init.lua"}},{"name":"ReverseIterator","desc":"Provides a reverse iterator.","params":[],"returns":[{"desc":"","lua_type":"ListIterator"}],"function_type":"method","source":{"line":295,"path":"src/DataStructures/LinkedList/init.lua"}},{"name":"ToArray","desc":"Returns an array containing all of the elements in this list in proper sequence (from first to last element).","params":[],"returns":[{"desc":"An array with every element in the `LinkedList`.","lua_type":"Array<T>"}],"function_type":"method","source":{"line":303,"path":"src/DataStructures/LinkedList/init.lua"}},{"name":"Remove","desc":"Removes the element at the given index from the `LinkedList`. This operation should compute in O(n) time.","params":[{"name":"Index","desc":"The index of the node you want to remove.","lua_type":"int"}],"returns":[{"desc":"","lua_type":"LinkedList<T>"}],"function_type":"method","errors":[{"lua_type":"InvalidIndex","desc":"Thrown when the index is out of bounds."}],"source":{"line":321,"path":"src/DataStructures/LinkedList/init.lua"}},{"name":"RemoveValue","desc":"Removes any element with the given value from the `LinkedList`. This operation should compute in O(n) time.","params":[{"name":"Value","desc":"The value you want to remove from the `LinkedList`.","lua_type":"any"}],"returns":[{"desc":"","lua_type":"LinkedList<T>"}],"function_type":"method","source":{"line":357,"path":"src/DataStructures/LinkedList/init.lua"}},{"name":"RemoveNode","desc":"Removes the given `ListNode` from the `LinkedList`. This operation should compute in O(n) time.","params":[{"name":"Node","desc":"The node you want to remove from the `LinkedList`.","lua_type":"ListNode"}],"returns":[{"desc":"","lua_type":"LinkedList<T>"}],"function_type":"method","source":{"line":387,"path":"src/DataStructures/LinkedList/init.lua"}}],"properties":[{"name":"Length","desc":"The length of the LinkedList.","lua_type":"int","source":{"line":32,"path":"src/DataStructures/LinkedList/init.lua"}}],"types":[],"name":"LinkedList","desc":"A LinkedList is a data structure.","source":{"line":8,"path":"src/DataStructures/LinkedList/init.lua"}}')}}]);