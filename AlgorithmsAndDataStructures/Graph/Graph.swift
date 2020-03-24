//
//  Graph.swift
//  Graph
//
//  Created by Sebastian Tleye on 16/03/2020.
//  Copyright © 2020 HumileAnts. All rights reserved.
//

import Foundation

public class Graph<T: Hashable> {

    public typealias Element = T
    
    public init() {}

    public var description: CustomStringConvertible {
        var result = ""
        for (vertex, edges) in adjacencyDict {
            var edgeString = ""
            for (index, edge) in edges.enumerated() {
                if index != edges.count - 1 {
                    edgeString.append("\(edge.destination), ")
                } else {
                    edgeString.append("\(edge.destination)")
                }
            }
            result.append("\(vertex) ---> [ \(edgeString) ] \n ")
        }
        return result
    }

    private var adjacencyDict: [Vertex: [Edge]] = [:]
    private var lastId = 0

    public class Edge {

        public enum EdgeType {
            case directed, undirected
        }

        public var source: Vertex
        public var destination: Vertex
        public var type: EdgeType
        public var weight: Double?

        public init(source: Vertex, destination: Vertex, type: EdgeType, weight: Double? = nil) {
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

        fileprivate init(data: T, id: Int) {
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
    public func createVertex(data: Element) -> Vertex {
        self.lastId = self.lastId + 1
        let vertex = Vertex(data: data, id: lastId)
        if adjacencyDict[vertex] == nil {
            adjacencyDict[vertex] = []
        }
        return vertex
    }

    public func addDirectedEdge(from source: Vertex, to destination: Vertex, weight: Double? = nil) {
        let edge = Edge(source: source, destination: destination, type: .directed, weight: weight)
        adjacencyDict[source]?.append(edge)
    }

    public func addUndirectedEdge(vertices: (Vertex, Vertex), weight: Double? = nil) {
        let (source, destination) = vertices
        let edge = Edge(source: source, destination: destination, type: .undirected, weight: weight)
        adjacencyDict[source]?.append(edge)
        adjacencyDict[destination]?.append(edge)
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
        guard let edges = adjacencyDict[source] else {
            return nil
        }
        for edge in edges {
            if edge.destination == destination {
                return edge.weight
            }
        }
        return nil
    }

    public func edges(from source: Vertex) -> [Edge] {
        return adjacencyDict[source] ?? []
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
        return Array(adjacencyDict.keys)
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
