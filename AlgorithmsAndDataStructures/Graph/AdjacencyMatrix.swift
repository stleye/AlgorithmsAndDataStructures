//
//  AdjacencyMatrix.swift
//  AlgorithmsAndDataStructures
//
//  Created by Sebastian Tleye on 26/03/2020.
//  Copyright © 2020 HumileAnts. All rights reserved.
//

import Foundation

class AdjacencMatrix<T: Hashable>: GraphRepresentation<T> {

    private var matrix: [Graph<T>.Vertex: [Graph<T>.Vertex: Graph<T>.Edge?]] = [:]
    private var lastId = 0

    @discardableResult
    override func createVertex(data: T) -> Graph<T>.Vertex {
        self.lastId = self.lastId + 1
        let vertex = Graph<T>.Vertex(data: data, id: lastId)
        if self.matrix[vertex] == nil {
            self.matrix[vertex] = [vertex: nil]
        }
        return vertex
    }

    override func addDirectedEdge(from source: Graph<T>.Vertex,
                                to destination: Graph<T>.Vertex,
                                weight: Double? = nil) {
        let edge = Graph<T>.Edge(source: source,
                                       destination: destination,
                                       type: .directed,
                                       weight: weight)
        self.matrix[source]?[destination] = edge
        //self.matrix[destination]?[source] = edge
    }

    override func addUndirectedEdge(vertices: (Graph<T>.Vertex, Graph<T>.Vertex), weight: Double? = nil) {
        let edge = Graph<T>.Edge(source: vertices.0,
                                       destination: vertices.1,
                                       type: .undirected,
                                       weight: weight)
        self.matrix[vertices.0]?[vertices.1] = edge
        self.matrix[vertices.1]?[vertices.0] = edge
    }

    override func edges(from source: Graph<T>.Vertex) -> [Graph<T>.Edge] {
        if let values = self.matrix[source]?.values.filter({ $0 != nil }) {
            return values as! [Graph<T>.Edge]
        }
        return []
    }

    override func vertices() -> [Graph<T>.Vertex] {
        return Array(self.matrix.keys)
    }

    override func removeVertex(_ vertex: Graph<T>.Vertex) {
        self.matrix.removeValue(forKey: vertex)
    }

}
