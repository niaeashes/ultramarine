//
//  CollectionBehaviorTests.swift
//  UltramarineTests
//

import XCTest
import Ultramarine

class CollectionBehaviorTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testSubscript() throws {
        let collection = Subject<Array<Int>>([])
        
        collection.value.append(1)
        XCTAssertEqual(collection[0], 1)
        
        XCTAssertNil(collection[1])
        
        collection.value.append(2)
        XCTAssertEqual(collection[1], 2)
    }
    
    func testAppendedSignal() throws {
        let collection = Subject<Array<Int>>([])
        var appendedNumber = 0
        
        collection.appended.sink { appendedNumber = $0 }
        
        collection.append(1)
        XCTAssertEqual(appendedNumber, 1)
        
        collection.append(2)
        XCTAssertEqual(appendedNumber, 2)
        
        XCTAssertEqual(collection.value.count, 2)
    }
    
    func testRemovedSignal() throws {
        let collection = Subject<Array<Int>>([1, 2, 3])
        var removedNumber = 0
        
        collection.removed.sink { removedNumber = $0 }
        
        collection.remove(at: 0)
        XCTAssertEqual(removedNumber, 1)
        
        collection.remove(at: 0)
        XCTAssertEqual(removedNumber, 2)
        
        XCTAssertEqual(collection.value.count, 1)
    }
}
