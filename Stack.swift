struct Stack<T> {
    var count: Int {
        return list.count
    }

    private var list = LinkedList<T>()

    mutating func push(_ value: T) {
        list.insert(value)
    }

    @discardableResult mutating func pop() -> T {
        let result = list.last
        list.remove(at: list.count - 1)
        return result!
    }

    func top() -> T? {
        return list.last
    }

    func isEmpty() -> Bool {
        return list.count == 0
    }
}
