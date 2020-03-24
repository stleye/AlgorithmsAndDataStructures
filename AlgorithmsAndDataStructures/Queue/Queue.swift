public struct Queue<T> {
    
    public var count: Int {
        return list.count
    }

    private var list = LinkedList<T>()

    public init() {}

    public mutating func enqueue(_ value: T) {
        list.insert(value, at: 0)
    }

    @discardableResult
    public mutating func dequeue() -> T {
        let result = list.last
        list.remove(at: list.count - 1)
        return result!
    }

    public func isEmpty() -> Bool {
        return list.count == 0
    }

    public func front() -> T? {
        return list.last
    }
}
