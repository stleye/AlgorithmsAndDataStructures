public struct Stack<T> {

    public var count: Int {
        return list.count
    }

    private var list = LinkedList<T>()

    public init() {}

    mutating public func push(_ value: T) {
        list.insert(value)
    }

    @discardableResult
    public mutating func pop() -> T {
        let result = list.last
        list.remove(at: list.count - 1)
        return result!
    }

    public func top() -> T? {
        return list.last
    }

    public func isEmpty() -> Bool {
        return list.count == 0
    }
}
