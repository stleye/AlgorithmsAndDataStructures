struct LinkedList<Element> : Sequence, IteratorProtocol {

    enum LinkedListError: Error {
        case IndexOutOfRange
    }

    var count = 0

    var last: Element? {
        return self.lastNode?.value
    }

    private class LLNode<Element> {
        var value: Element?
        var next: LLNode?
        var previous: LLNode?
    }

    private var rootNode: LLNode<Element>? = nil
    private var lastNode: LLNode<Element>? = nil
    private var currentNode: LLNode<Element>? = nil

    subscript(index: Int) -> Element {
        return try! value(at: index)
    }

    mutating func next() -> Element? {
        if currentNode == nil {
            currentNode = rootNode
        } else {
            currentNode = currentNode?.next
        }
        return currentNode?.value
    }

    mutating func insert(_ value: Element) {
        count = count + 1
        let newNode = LLNode<Element>()
        newNode.value = value
        if rootNode == nil {
            rootNode = newNode
            lastNode = rootNode
            return
        }
        newNode.previous = lastNode
        lastNode?.next = newNode
        lastNode = newNode
    }

    mutating func insert(_ value: Element, at index: Int) {
        if index == count {
            insert(value)
            return
        }
        let newNode = LLNode<Element>()
        if index == 0 {
            newNode.next = rootNode
            rootNode?.previous = newNode
            rootNode = newNode
        } else {
            let node = try! self.node(at: index)
            newNode.next = node
            newNode.previous = node.previous
            node.previous?.next = newNode
            node.previous = newNode
        }
        newNode.value = value
        count = count + 1
    }

    mutating func remove(at index: Int) {
        let node = try! self.node(at: index)
        if count == 1 {
            rootNode = nil
        } else if node.previous == nil {
            rootNode = node.next
            rootNode!.previous = nil
        } else if node.next == nil {
            lastNode = node.previous
            lastNode!.next = nil
        } else {
            node.previous!.next = node.next
            node.next!.previous = node.previous
        }
        count = count - 1
    }

    // Mark - Private

    private func node(at index: Int) throws -> LLNode<Element> {
        if index < 0 || index >= count { throw LinkedListError.IndexOutOfRange  }
        var currentNode = rootNode
        var currentIndex = 0
        while currentIndex < index {
            currentNode = currentNode!.next
            currentIndex = currentIndex + 1
        }
        return currentNode!
    }

    private func value(at index: Int) throws -> Element {
        return try node(at: index).value!
    }

}
