//
//  EventTests.swift
//  Ultramarine
//

import XCTest
import Ultramarine

class EventTests: XCTestCase {
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testBasic() throws {
        let event = Event<Void>()
        var counter = 0
        
        event.sink { counter += 1 }
        event.trigger(())
        event.trigger(())
        event.trigger(())
        XCTAssertEqual(counter, 3)
    }
    
    func testFilter() throws {
        let event = Event<Int>()
        var counter = 0
        
        let sub = event
            .filter { ($0 % 2) == 0 }
            .sink { _ in counter += 1 }
        
        event.trigger(1)
        event.trigger(2)
        event.trigger(3)
        XCTAssertEqual(counter, 1)
        
        sub.cancel()
        
        event.trigger(2)
        XCTAssertEqual(counter, 1)
    }
    
    func testMap() throws {
        let event = Event<Int>()
        var counter = ""
        
        let sub = event
            .map { "\($0)" }
            .sink { counter += $0 }
        
        event.trigger(1)
        event.trigger(2)
        event.trigger(3)
        XCTAssertEqual(counter, "123")
        
        sub.cancel()
        
        event.trigger(4)
        XCTAssertEqual(counter, "123")
    }
    
    func testMemoryLeak() {
        
        do { //Filter
            var counter = 0
            weak var checker: Event<Int>? = nil
            
            do {
                let event = Event<Int>()
                let filter = event.filter { $0 % 2 == 0 }
                _ = filter.sink { _ in counter += 1 }
                checker = filter
                
                event.trigger(2)
                XCTAssertEqual(counter, 1)
                
                XCTAssertNotNil(checker)
            }
            
            XCTAssertNil(checker)
        }
        
        do { // Map
            var counter = ""
            weak var checker: Event<String>? = nil
            
            do {
                let event = Event<Int>()
                let map = event.map { "\($0)" }
                _ = map.sink { counter += $0 }
                checker = map
                
                event.trigger(2)
                XCTAssertEqual(counter, "2")
                
                XCTAssertNotNil(checker)
            }
            
            XCTAssertNil(checker)
        }
    }
}
