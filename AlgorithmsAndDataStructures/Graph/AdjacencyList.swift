//
//  AdjacencyList.swift
//  AlgorithmsAndDataStructures
//
//  Created by Sebastian Tleye on 26/03/2020.
//  Copyright © 2020 HumileAnts. All rights reserved.
//

import Foundation

class AdjacencyList<T: Hashable>: GraphRepresentation<T> {

    private var adjacencyDict: [Graph<T>.Vertex: [Graph<T>.Edge]] = [:]
    private var lastId = 0

    @discardableResult
    override func createVertex(data: T) -> Graph<T>.Vertex {
        self.lastId = self.lastId + 1
        let vertex = Graph<T>.Vertex(data: data, id: lastId)
        if adjacencyDict[vertex] == nil {
            adjacencyDict[vertex] = []
        }
        return vertex
    }

    override func addDirectedEdge(from source: Graph<T>.Vertex,
                                to destination: Graph<T>.Vertex,
                                weight: Double? = nil) {
        let edge = Graph<T>.Edge(source: source, destination: destination, type: .directed, weight: weight)
        adjacencyDict[source]?.append(edge)
    }

    override func addUndirectedEdge(vertices: (Graph<T>.Vertex, Graph<T>.Vertex), weight: Double? = nil) {
        let (source, destination) = vertices
        let edge = Graph<T>.Edge(source: source, destination: destination, type: .undirected, weight: weight)
        adjacencyDict[source]?.append(edge)
        adjacencyDict[destination]?.append(edge)
    }

    override func edges(from source: Graph<T>.Vertex) -> [Graph<T>.Edge] {
        return adjacencyDict[source] ?? []
    }

    override func vertices() -> [Graph<T>.Vertex] {
        return Array(adjacencyDict.keys)
    }

    override func removeVertex(_ vertex: Graph<T>.Vertex) {
        adjacencyDict.removeValue(forKey: vertex)
    }

}
