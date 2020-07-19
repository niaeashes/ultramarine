//
//  CollectionBehaviorTests.swift
//  UltramarineTests
//

import XCTest
import Ultramarine

class CollectionBehaviorTests: XCTestCase {

    var cancellables = CancellableBag()
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        cancellables.cancel()
    }
    
    func testSubscript() throws {
        let collection = [Int]().subject()
        
        collection.value.append(1)
        XCTAssertEqual(collection[0], 1)
        
        XCTAssertNil(collection[1])
        
        collection.value.append(2)
        XCTAssertEqual(collection[1], 2)
    }
    
    func testAppendedSignal() throws {
        let collection = [Int]().subject()
        var appendedNumber = 0
        
        collection.appended
            .sink { appendedNumber = $0 }
            .append(to: cancellables)
        
        collection.append(1)
        XCTAssertEqual(appendedNumber, 1)
        
        collection.append(2)
        XCTAssertEqual(appendedNumber, 2)
        
        XCTAssertEqual(collection.value.count, 2)
    }
    
    func testRemovedSignal() throws {
        let collection = [1, 2, 3].subject()
        var removedNumber = 0
        
        collection.removed
            .sink { removedNumber = $0 }
            .append(to: cancellables)
        
        collection.remove(at: 0)
        XCTAssertEqual(removedNumber, 1)
        
        collection.remove(at: 0)
        XCTAssertEqual(removedNumber, 2)
        
        XCTAssertEqual(collection.value.count, 1)
    }
    
    func testCountSubject() throws {
        let collection = [1, 2, 3].subject()
        let count = collection.count()
        
        XCTAssertEqual(count.value, 3)
        
        collection.append(4)
        XCTAssertEqual(count.value, 4)
        
        collection.remove(at: 0)
        collection.remove(at: 0)
        XCTAssertEqual(count.value, 2)
    }
}
