# LinkedList
Implementation of a linked list in Swift

This is a small implementation of a linked list (a doubly linked list actually). 

It uses generics so it can be used with any type of elements, and it implements Sequence and IteratorProtocol.

Example

```var ll = LinkedList<Int>()
ll.insert(value: 3)
ll.insert(value: 14)
ll.insert(value: 10)
ll.insert(value: 20)
ll.insert(value: 30)
ll.insert(value: 40)

ll.forEach { (e) in
    print (e)
}
```
