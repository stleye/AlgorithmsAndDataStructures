extension Array where Element : Comparable {

    mutating func mergeSort(by areInIncreasingOrder: @escaping (Element, Element) -> Bool) {
        if self.count <= 1 { return }
        mergeSortAux(0, self.count-1, areInIncreasingOrder)
    }

    private mutating func mergeSortAux(_ leftIndex: Int, _ rightIndex: Int, _ areInIncreasingOrder: @escaping (Element, Element) -> Bool) {
        if rightIndex <= leftIndex { return }
        let middleIndex = (leftIndex+rightIndex)/2
        mergeSortAux(leftIndex, middleIndex, areInIncreasingOrder)
        mergeSortAux(middleIndex+1, rightIndex, areInIncreasingOrder)
        merge(leftIndex, middleIndex, rightIndex, areInIncreasingOrder)
    }

    private mutating func merge(_ leftIndex: Int, _ middleIndex: Int, _ rightIndex: Int, _ areInIncreasingOrder: @escaping (Element, Element) -> Bool) {
        var leftArray = Array(self[leftIndex...middleIndex])
        var rightArray = Array(self[middleIndex+1...rightIndex])
        var i = 0
        var j = 0
        var k = leftIndex
        while k <= rightIndex && i < leftArray.count && j < rightArray.count {
            if areInIncreasingOrder(leftArray[i], rightArray[j]) {
                self[k] = leftArray[i]
                i = i+1
            } else {
                self[k] = rightArray[j]
                j = j+1
            }
            k = k+1
        }
        while i < leftArray.count {
            self[k] = leftArray[i]
            i = i+1
            k = k+1
        }
        while j < rightArray.count {
            self[k] = rightArray[j]
            j = j+1
            k = k+1
        }
    }

}
