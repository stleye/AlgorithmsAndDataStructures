extension Array where Element : Comparable {

    mutating func bubbleSort(by areInIncreasingOrder: @escaping (Element, Element) -> Bool) {
        if self.count <= 1 { return }
        for i in stride(from: self.count-1, to: 1, by: -1) {
            for j in 0..<i {
                if areInIncreasingOrder(self[j+1], self[j]) {
                    swapAt(j, j+1)
                }
            }
        }
    }

}
