extension Array where Element : Comparable {

    mutating public func heapSort(by areInIncreasingOrder: @escaping (Element, Element) -> Bool) {
        let heap = BinaryHeap(from: self, by: areInIncreasingOrder)
        var index = 0
        while heap.size() > 0 {
            self[index] = heap.extractTop()!
            index = index + 1
        }
    }

}
