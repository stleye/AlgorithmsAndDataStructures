//
//  GraphRepresentation.swift
//  AlgorithmsAndDataStructures
//
//  Created by Sebastian Tleye on 29/03/2020.
//  Copyright © 2020 HumileAnts. All rights reserved.
//

import Foundation

class GraphRepresentation<T: Hashable> {

    public init() {}
    
    @discardableResult
    func createVertex(data: T) -> Graph<T>.Vertex {
        fatalError("Should Override")
    }

    public func addDirectedEdge(from source: Graph<T>.Vertex,
                                to destination: Graph<T>.Vertex,
                                weight: Double? = nil) {
        fatalError("Should Override")
    }

    public func addUndirectedEdge(vertices: (Graph<T>.Vertex, Graph<T>.Vertex), weight: Double? = nil) {
        fatalError("Should Override")
    }

    public func edges(from source: Graph<T>.Vertex) -> [Graph<T>.Edge] {
        fatalError("Should Override")
    }
    
    public func vertices() -> [Graph<T>.Vertex] {
        fatalError("Should Override")
    }
    
    public func removeVertex(_ vertex: Graph<T>.Vertex) {
        fatalError("Should Override")
    }

}
