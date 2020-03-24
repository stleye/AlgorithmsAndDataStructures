//
//  BinaryHeap.swift
//  AlgorithmsAndDataStructures
//
//  Created by Sebastian Tleye on 20/03/2020.
//  Copyright © 2020 HumileAnts. All rights reserved.
//

import Foundation

public class BinaryHeap<T: Comparable> {

    private var elements: [T] = []
    private var areInIncreasingOrder: (T, T) -> Bool

    public init(ofType: T.Type, by areInIncreasingOrder: @escaping (T, T) -> Bool) {
        self.elements = []
        self.areInIncreasingOrder = areInIncreasingOrder
    }

    public init(from array: [T], by areInIncreasingOrder: @escaping (T, T) -> Bool) {
        self.areInIncreasingOrder = areInIncreasingOrder
        for elem in array {
            insert(elem)
        }
    }

    public func insert(_ element: T) {
        elements.append(element)
        var elementIndex = elements.count - 1
        while true {
            let parentIndex = (elementIndex - 1) / 2
            if parentIndex >= 0 && areInIncreasingOrder(elements[elementIndex], elements[parentIndex]) {
                elements.swapAt(elementIndex, parentIndex)
                elementIndex = parentIndex
            } else {
                break
            }
        }
    }

    public func removeTop() {
        if elements.count <= 0 { return }
        var parentIndex = 0
        elements[parentIndex] = elements.last!
        elements.removeLast()
        while true {
            let indexLeftSon = 2*parentIndex + 1
            var indexRightSon = 2*parentIndex + 2
            if indexLeftSon >= elements.count { break }
            if indexRightSon >= elements.count { indexRightSon = indexLeftSon }
            let swapingIndex = areInIncreasingOrder(elements[indexLeftSon] , elements[indexRightSon]) ? indexLeftSon : indexRightSon
            if areInIncreasingOrder(elements[swapingIndex], elements[parentIndex]) {
                elements.swapAt(swapingIndex, parentIndex)
                parentIndex = swapingIndex
            } else {
                break
            }
        }
    }

    public func size() -> Int {
        return elements.count
    }

    public func top() -> T? {
        return elements.first
    }

    public func extractTop() -> T? {
        let res = elements.first
        removeTop()
        return res
    }
}
