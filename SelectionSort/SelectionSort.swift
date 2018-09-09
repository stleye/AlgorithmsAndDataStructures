extension Array where Element : Comparable {

    mutating func selectionSort(by areInIncreasingOrder: @escaping (Element, Element) -> Bool) {
        if self.count <= 1 { return }
        for i in 0..<self.count-1 {
            var minIndex = i
            for j in i+1..<self.count {
                if areInIncreasingOrder(self[j], self[minIndex]) {
                    minIndex = j
                }
            }
            swapAt(i, minIndex)
        }
    }

}
