# LinkedList
Implementation of a linked list in Swift

This is a small implementation of a linked list (a doubly linked list actually). 

It uses generics so it can be used with any type of elements, and it implements Sequence and IteratorProtocol.

Example

```
var ll = LinkedList<Int>()
ll.insert(3)
ll.insert(14)
ll.insert(10)
ll.insert(20)
ll.insert(30)
ll.insert(40)

ll.forEach { (e) in
    print (e)
}
```
