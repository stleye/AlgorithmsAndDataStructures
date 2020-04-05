//
//  Graph.swift
//  Graph
//
//  Created by Sebastian Tleye on 16/03/2020.
//  Copyright © 2020 HumileAnts. All rights reserved.
//

import Foundation

public class Graph<T: Hashable> {
    
    public enum GraphRepresentationType {
        case adjacencyList
        case matrix
    }

    public init(graphRepresentation: GraphRepresentationType = .matrix) {
        switch graphRepresentation {
        case .adjacencyList:
            self.graphRepresentation = AdjacencyList<T>()
        case .matrix:
            self.graphRepresentation = AdjacencMatrix<T>()
        }
    }

    public var description: CustomStringConvertible {
        var result = ""
        for vertex in self.vertices() {
            var edgeString = ""
            for edge in self.edges(from: vertex) {
                edgeString.append("\(edge.destination), ")
            }
            result.append("\(vertex) ---> [ \(edgeString) ] \n ")
        }
        return result
    }

    private var graphRepresentation: GraphRepresentation<T>

    public class Edge {
        
        public typealias Weight = Double

        public enum EdgeType {
            case directed, undirected
        }

        public var source: Vertex
        public var destination: Vertex
        public var type: EdgeType
        public var weight: Weight?

        public init(source: Vertex, destination: Vertex, type: EdgeType, weight: Weight? = nil) {
            self.type = type
            self.source = source
            self.destination = destination
            self.weight = weight
        }
    }

    public class Vertex {
        public var data: T
        var userInfo: [String: Any]

        fileprivate var id: Int

        init(data: T, id: Int) {
            self.data = data
            self.id = id
            self.userInfo = [:]
        }

        public func copy() -> Vertex {
            let copy = Vertex(data: data, id: id)
            copy.userInfo = self.userInfo
            return copy
        }
    }

    @discardableResult
    public func createVertex(data: T) -> Vertex {
        return self.graphRepresentation.createVertex(data: data)
    }

    public func addDirectedEdge(from source: Vertex, to destination: Vertex, weight: Double? = nil) {
        self.graphRepresentation.addDirectedEdge(from: source, to: destination, weight: weight)
    }

    public func addUndirectedEdge(vertices: (Vertex, Vertex), weight: Double? = nil) {
        self.graphRepresentation.addUndirectedEdge(vertices: vertices, weight: weight)
    }

    public func add(_ type: Edge.EdgeType, from source: Vertex, to destination: Vertex, weight: Double? = nil) {
        switch type {
        case .directed:
            addDirectedEdge(from: source, to: destination, weight: weight)
        case .undirected:
            addUndirectedEdge(vertices: (source, destination), weight: weight)
        }
    }

    public func weight(from source: Vertex, to destination: Vertex) -> Double? {
        for edge in self.edges(from: source) {
            if edge.destination == destination {
                return edge.weight
            }
        }
        return nil
    }

    public func edges(from source: Vertex) -> [Edge] {
        return self.graphRepresentation.edges(from: source)
    }

    public func edges(to destination: Vertex) -> [Edge] {
        return self.edges().filter({ $0.destination == destination })
    }

    public func edges() -> [Edge] {
        var result: Set<Edge> = []
        for vertex in self.vertices() {
            for edge in self.edges(from: vertex) {
                result.insert(edge)
            }
        }
        return Array(result)
    }

    public func vertices() -> [Vertex] {
        return self.graphRepresentation.vertices()
    }

    public func neighbors(of vertex: Vertex, directedOnly: Bool = false) -> [Vertex] {
        var result: Set<Vertex> = []
        var touchingVertices: [Edge] = []
        if directedOnly {
            touchingVertices = self.edges(from: vertex)
        } else {
            touchingVertices = self.edges().filter({ $0.source == vertex || $0.destination == vertex })
        }
        touchingVertices.forEach { (edge) in
            if edge.source != vertex {
                result.insert(edge.source)
            }
            if edge.destination != vertex {
                result.insert(edge.destination)
            }
        }
        return Array(result)
    }

    public func removeVertex(_ vertex: Vertex) {
        self.graphRepresentation.removeVertex(vertex)
    }

}

extension Graph.Edge: Hashable {

    public func hash(into hasher: inout Hasher) {
        return hasher.combine("\(source)\(destination)\(String(describing: weight))")
    }

    static public func ==(lhs: Graph.Edge, rhs: Graph.Edge) -> Bool {
      return lhs.source == rhs.source &&
        lhs.destination == rhs.destination &&
        lhs.weight == rhs.weight
    }

}

extension Graph.Vertex: Hashable, CustomStringConvertible {

    public func hash(into hasher: inout Hasher) {
        return hasher.combine("\(data)\(id)")
    }

    static public func ==(lhs: Graph.Vertex, rhs: Graph.Vertex) -> Bool { // 2
        return lhs.data == rhs.data && lhs.id == rhs.id
    }

    public var description: String {
        return "\(data)"
    }

}
