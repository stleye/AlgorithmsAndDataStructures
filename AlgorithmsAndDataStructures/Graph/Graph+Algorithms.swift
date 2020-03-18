//
//  DepthFirstSearch.swift
//  AlgorithmsAndDataStructures
//
//  Created by Sebastian Tleye on 18/03/2020.
//  Copyright © 2020 HumileAnts. All rights reserved.
//

import Foundation

extension Graph {

    enum TraversalAlgorithm {
        case dfs
        case bfs
    }

    func getComponents() -> [[Vertex]] {
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

    func doForConnectedVertices(algorithm: TraversalAlgorithm = .dfs,
                                startingAt initialVertex: inout Vertex,
                                _ block: (Vertex) -> Void) {
        self.markAllVerticesAs(visited: false)
        switch algorithm {
        case .dfs:
            self.doDFSForConnectedVertices(startingAt: &initialVertex, block)
        case .bfs:
            self.doBFSForConnectedVertices(startingAt: &initialVertex, block)
        }
    }

    // Private

    private func doDFSForConnectedVertices(startingAt initialVertex: inout Vertex, _ block: (Vertex) -> Void) {
        if initialVertex.visited { return }
        initialVertex.visited = true
        block(initialVertex)
        for var neighbour in self.neighbors(of: initialVertex) {
            self.doDFSForConnectedVertices(startingAt: &neighbour, block)
        }
    }

    private func doBFSForConnectedVertices(startingAt initialVertex: inout Vertex, _ block: (Vertex) -> Void) {
        var queue = Queue<Vertex>()
        queue.enqueue(initialVertex)
        initialVertex.visited = true
        while !queue.isEmpty() {
            let vertex = queue.dequeue()
            block(vertex)
            for neighbour in self.neighbors(of: vertex) {
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
