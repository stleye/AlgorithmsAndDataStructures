extension Array where Element : Comparable {

    mutating func insertionSort(by areInIncreasingOrder: @escaping (Element, Element) -> Bool) {
        if self.count <= 1 { return }
        for i in 1..<self.count {
            for j in stride(from: i, through: 1, by: -1) {
                if areInIncreasingOrder(self[j], self[j-1]) {
                    self.swapAt(j, j-1)
                } else {
                    break
                }
            }
        }
    }

}
