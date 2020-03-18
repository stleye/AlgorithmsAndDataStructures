//
//  AlgorithmsAndDataStructuresTests.swift
//  AlgorithmsAndDataStructuresTests
//
//  Created by Sebastian Tleye on 18/03/2020.
//  Copyright © 2020 HumileAnts. All rights reserved.
//

import XCTest
@testable import AlgorithmsAndDataStructures

class GraphTests: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testGraphWith3VerticesShouldContain3Vertices() {
        let graph = Graph<Int>()
        let vertex1 = graph.createVertex(data: 3)
        let vertex2 = graph.createVertex(data: 5)
        let vertex3 = graph.createVertex(data: 10)
        XCTAssertEqual(graph.vertices().count, 3)
        XCTAssert(graph.vertices().contains(vertex1))
        XCTAssert(graph.vertices().contains(vertex2))
        XCTAssert(graph.vertices().contains(vertex3))
    }

    func testComponentsOfConnectedGraphShouldContainOnlyOneComponent() {
        let graph = Graph<Int>()
        let vertex3 = graph.createVertex(data: 3)
        let vertex5 = graph.createVertex(data: 5)
        let vertex10 = graph.createVertex(data: 10)
        let vertex12 = graph.createVertex(data: 12)
        let vertex13 = graph.createVertex(data: 13)
        graph.addDirectedEdge(from: vertex3, to: vertex13)
        graph.addDirectedEdge(from: vertex3, to: vertex5)
        graph.addDirectedEdge(from: vertex13, to: vertex5)
        graph.addDirectedEdge(from: vertex5, to: vertex10)
        graph.addDirectedEdge(from: vertex10, to: vertex12)
        graph.addDirectedEdge(from: vertex12, to: vertex5)
        let components = graph.getComponents()
        XCTAssertEqual(components.count, 1)
        XCTAssert(components.first!.contains(vertex3))
        XCTAssert(components.first!.contains(vertex5))
        XCTAssert(components.first!.contains(vertex10))
        XCTAssert(components.first!.contains(vertex12))
        XCTAssert(components.first!.contains(vertex13))
        XCTAssertEqual(components.first!.filter( { $0 == vertex3 }).count, 1)
        XCTAssertEqual(components.first!.filter( { $0 == vertex5 }).count, 1)
        XCTAssertEqual(components.first!.filter( { $0 == vertex10 }).count, 1)
        XCTAssertEqual(components.first!.filter( { $0 == vertex12 }).count, 1)
        XCTAssertEqual(components.first!.filter( { $0 == vertex13 }).count, 1)
    }

    func testGraphWithTwoComponentsShouldReturnTwoComponents() {
        let graph = Graph<Int>()
        let vertex3 = graph.createVertex(data: 3)
        let vertex5 = graph.createVertex(data: 5)
        let vertex10 = graph.createVertex(data: 10)
        let vertex12 = graph.createVertex(data: 12)
        let vertex13 = graph.createVertex(data: 13)
        graph.addDirectedEdge(from: vertex3, to: vertex13)
        graph.addDirectedEdge(from: vertex3, to: vertex5)
        graph.addDirectedEdge(from: vertex12, to: vertex10)
        graph.addDirectedEdge(from: vertex13, to: vertex5)
        let components = graph.getComponents()
        XCTAssertEqual(components.count, 2)
        let componentWith3 = components.first(where: { $0.contains(vertex3) })!
        let componentWith12 = components.first(where: { $0.contains(vertex12) })!
        XCTAssert(componentWith3.contains(vertex3))
        XCTAssert(componentWith3.contains(vertex5))
        XCTAssert(componentWith3.contains(vertex13))
        XCTAssert(componentWith12.contains(vertex12))
        XCTAssert(componentWith12.contains(vertex10))
        XCTAssertEqual(componentWith3.filter( { $0 == vertex3 }).count, 1)
        XCTAssertEqual(componentWith3.filter( { $0 == vertex5 }).count, 1)
        XCTAssertEqual(componentWith3.filter( { $0 == vertex13 }).count, 1)
        XCTAssertEqual(componentWith12.filter( { $0 == vertex10 }).count, 1)
        XCTAssertEqual(componentWith12.filter( { $0 == vertex12 }).count, 1)
    }

}
