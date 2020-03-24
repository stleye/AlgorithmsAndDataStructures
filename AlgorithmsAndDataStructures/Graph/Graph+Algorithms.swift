//
//  DepthFirstSearch.swift
//  AlgorithmsAndDataStructures
//
//  Created by Sebastian Tleye on 18/03/2020.
//  Copyright © 2020 HumileAnts. All rights reserved.
//

import Foundation

extension Graph {

    public enum TraversalAlgorithm {
        case dfs
        case bfs
    }

    public func path(from: Vertex, to destination: Vertex) -> [Vertex]? {
        var result: [Vertex] = []
        var stack = Stack<Vertex>()
        var source = from.copy()
        self.doForConnectedVertices(startingAt: &source, { vertex in
            stack.push(vertex)
        }, stopIf: { _ in
            stack.top() == destination
        }, directedOnly: true)
        if stack.top() != destination { return nil }
        while !stack.isEmpty() {
            result.insert(stack.pop(), at: 0)
        }
        return result
    }

    public func components() -> [[Vertex]] {
        var result: [[Vertex]] = []
        for var vertex in self.vertices() where !result.flatMap({ $0 }).contains(vertex)  {
            var component: [Vertex] = []
            self.doForConnectedVertices(algorithm: .bfs, startingAt: &vertex, { vertex in
                component.append(vertex)
            })
            result.append(component)
        }
        return result
    }

    public func doForConnectedVertices(algorithm: TraversalAlgorithm = .dfs,
                                startingAt initialVertex: inout Vertex,
                                _ body: (Vertex) -> Void,
                                stopIf: (Vertex) -> Bool = { _ in false },
                                directedOnly: Bool = false) {
        self.markAllVerticesAs(visited: false)
        switch algorithm {
        case .dfs:
            var shouldStop = false
            self.doDFSForConnectedVertices(startingAt: &initialVertex, body, stopIf, &shouldStop, directedOnly: directedOnly)
        case .bfs:
            self.doBFSForConnectedVertices(startingAt: &initialVertex, body, stopIf, directedOnly: directedOnly)
        }
    }

    // Private

    private func doDFSForConnectedVertices(startingAt initialVertex: inout Vertex,
                                           _ block: (Vertex) -> Void,
                                           _ stopIf: (Vertex) -> Bool,
                                           _ shouldStop: inout Bool,
                                           directedOnly: Bool) {
        if initialVertex.visited { return }
        initialVertex.visited = true
        block(initialVertex)
        if stopIf(initialVertex) {
            shouldStop = true
            return
        }
        for var neighbour in self.neighbors(of: initialVertex, directedOnly: directedOnly) {
            if shouldStop { break }
            self.doDFSForConnectedVertices(startingAt: &neighbour, block, stopIf, &shouldStop, directedOnly: directedOnly)
        }
    }

    private func doBFSForConnectedVertices(startingAt initialVertex: inout Vertex,
                                           _ block: (Vertex) -> Void,
                                           _ stopIf: (Vertex) -> Bool,
                                           directedOnly: Bool) {
        var queue = Queue<Vertex>()
        queue.enqueue(initialVertex)
        initialVertex.visited = true
        while !queue.isEmpty() {
            let vertex = queue.dequeue()
            block(vertex)
            if stopIf(vertex) { return }
            for neighbour in self.neighbors(of: vertex, directedOnly: directedOnly) {
                if !neighbour.visited {
                    neighbour.visited = true
                    queue.enqueue(neighbour)
                }
            }
        }
    }

    private func markAllVerticesAs(visited: Bool) {
        for vertex in self.vertices() {
            vertex.visited = visited
        }
    }

}

extension Graph.Vertex {

    private var visitedKey: String { return "@VISITED@" }

    var visited: Bool {
        get {
            return self.userInfo[visitedKey] as? Bool ?? false
        }
        set {
            self.userInfo[visitedKey] = newValue
        }
    }

}
