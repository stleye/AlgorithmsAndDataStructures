import XCTest
@testable import LinkedList

class LinkedListTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testEmptyListHasNoElements() {
        let linkedListInt = LinkedList<Int>()
        let linkedListString = LinkedList<String>()
        XCTAssertEqual(linkedListInt.count, 0)
        XCTAssertEqual(linkedListString.count, 0)
    }

    func testInsertingOneElementIncrementsTheCount() {
        var linkedListInt = LinkedList<Int>()
        linkedListInt.insert(1)
        XCTAssertEqual(linkedListInt.count, 1)
        linkedListInt.insert(10)
        XCTAssertEqual(linkedListInt.count, 2)
    }

    func testLastElementInsertedIsCorrect() {
        var linkedListInt = LinkedList<Int>()
        linkedListInt.insert(1)
        linkedListInt.insert(2)
        linkedListInt.insert(3)
        XCTAssertEqual(linkedListInt.last!, 3)
    }

    func testAccessingWithIndexWorksCorrectly() {
        var linkedListInt = LinkedList<Int>()
        linkedListInt.insert(1)
        linkedListInt.insert(2)
        linkedListInt.insert(3)
        XCTAssertEqual(linkedListInt[0], 1)
        XCTAssertEqual(linkedListInt[1], 2)
        XCTAssertEqual(linkedListInt[2], 3)
    }

    func testRemoveElementWorksCorrectly() {
        var linkedListString = LinkedList<String>()
        linkedListString.insert("one")
        linkedListString.insert("two")
        linkedListString.insert("three")
        XCTAssertEqual(linkedListString.count, 3)
        XCTAssertEqual(linkedListString.last!, "three")
        linkedListString.remove(at: 0)
        XCTAssertEqual(linkedListString.count, 2)
        XCTAssertEqual(linkedListString.last!, "three")
        XCTAssertEqual(linkedListString[0], "two")
    }

}
