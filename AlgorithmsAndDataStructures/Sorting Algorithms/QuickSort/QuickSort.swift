extension Array where Element : Comparable {

    mutating func quickSort(by areInIncreasingOrder: @escaping (Element, Element) -> Bool) {
        if self.count <= 1 { return }
        quickSortAux(0, self.count-1, areInIncreasingOrder)
    }

    private mutating func quickSortAux(_ lo: Int, _ hi: Int, _ areInIncreasingOrder: @escaping (Element, Element) -> Bool) {
        if lo < hi {
            let p = partition(lo, hi, areInIncreasingOrder)
            quickSortAux(lo, p, areInIncreasingOrder)
            quickSortAux(p + 1, hi, areInIncreasingOrder)
        }
    }

    private mutating func partition(_ lo: Int, _ hi: Int, _ areInIncreasingOrder: (Element, Element) -> Bool) -> Int {
        let pivot = self[lo]
        var i = lo-1
        var j = hi + 1
        while true {
            repeat {
                i = i + 1
            } while areInIncreasingOrder(pivot, self[i])
            repeat {
                j = j - 1
            } while areInIncreasingOrder(pivot, self[j])
            if i >= j { return j }
            self.swapAt(i, j)
        }
    }

}
