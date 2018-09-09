struct Queue<T> {
    var count: Int {
        return list.count
    }

    private var list = LinkedList<T>()

    mutating func enqueue(_ value: T) {
        list.insert(value, at: 0)
    }

    @discardableResult mutating func dequeue() -> T {
        let result = list.last
        list.remove(at: list.count - 1)
        return result!
    }

    func isEmpty() -> Bool {
        return list.count == 0
    }

    func front() -> T? {
        return list.last
    }
}
