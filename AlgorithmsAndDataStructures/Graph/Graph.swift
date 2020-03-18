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

    var description: CustomStringConvertible {
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

    class Edge {

        enum EdgeType {
            case directed, undirected
        }

        public var source: Vertex
        public var destination: Vertex
        public var type: EdgeType
        public var weight: Double?

        init(source: Vertex, destination: Vertex, type: EdgeType, weight: Double? = nil) {
            self.type = type
            self.source = source
            self.destination = destination
            self.weight = weight
        }
    }

    class Vertex {
        var data: T
        var userInfo: [String: Any]

        fileprivate var id: Int

        fileprivate init(data: T, id: Int) {
            self.data = data
            self.id = id
            self.userInfo = [:]
        }
    }

    @discardableResult func createVertex(data: Element) -> Vertex {
        self.lastId = self.lastId + 1
        let vertex = Vertex(data: data, id: lastId)
        if adjacencyDict[vertex] == nil {
            adjacencyDict[vertex] = []
        }
        return vertex
    }

    func addDirectedEdge(from source: Vertex, to destination: Vertex, weight: Double? = nil) {
        let edge = Edge(source: source, destination: destination, type: .directed, weight: weight)
        adjacencyDict[source]?.append(edge)
    }

    func addUndirectedEdge(vertices: (Vertex, Vertex), weight: Double? = nil) {
        let (source, destination) = vertices
        let edge = Edge(source: source, destination: destination, type: .undirected, weight: weight)
        adjacencyDict[source]?.append(edge)
        adjacencyDict[destination]?.append(edge)
    }

    func add(_ type: Edge.EdgeType, from source: Vertex, to destination: Vertex, weight: Double? = nil) {
        switch type {
        case .directed:
            addDirectedEdge(from: source, to: destination, weight: weight)
        case .undirected:
            addUndirectedEdge(vertices: (source, destination), weight: weight)
        }
    }

    func weight(from source: Vertex, to destination: Vertex) -> Double? {
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

    func edges(from source: Vertex) -> [Edge] {
        return adjacencyDict[source] ?? []
    }

    func edges(to destination: Vertex) -> [Edge] {
        return self.edges().filter({ $0.destination == destination })
    }

    func edges() -> [Edge] {
        var result: Set<Edge> = []
        for vertex in self.vertices() {
            for edge in self.edges(from: vertex) {
                result.insert(edge)
            }
        }
        return Array(result)
    }

    func vertices() -> [Vertex] {
        return Array(adjacencyDict.keys)
    }

    func neighbors(of vertex: Vertex) -> [Vertex] {
        var result: Set<Vertex> = []
        let touchingVertices = self.edges().filter({ $0.source == vertex || $0.destination == vertex })
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

    func hash(into hasher: inout Hasher) {
        return hasher.combine("\(source)\(destination)\(String(describing: weight))")
    }

    static public func ==(lhs: Graph.Edge, rhs: Graph.Edge) -> Bool {
      return lhs.source == rhs.source &&
        lhs.destination == rhs.destination &&
        lhs.weight == rhs.weight
    }

}

extension Graph.Vertex: Hashable, CustomStringConvertible {

    func hash(into hasher: inout Hasher) {
        return hasher.combine("\(data)\(id)")
    }

    static public func ==(lhs: Graph.Vertex, rhs: Graph.Vertex) -> Bool { // 2
        return lhs.data == rhs.data && lhs.id == rhs.id
    }

    public var description: String {
        return "\(data)"
    }

}
