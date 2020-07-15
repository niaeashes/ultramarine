//
//  MemoryBehaviorTests.swift
//  Ultramarine
//

import XCTest
import Ultramarine

class MemoryBehaviorTests: XCTestCase {
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testBasic() throws {
        let numberMemory = MemoryBehavior<Int>()
        let ticketEvent = Event<Int>()
        
        XCTAssertNil(numberMemory.value)
        
        ticketEvent.trigger(101010)
        XCTAssertNil(numberMemory.value)
        
        numberMemory.watch(to: ticketEvent)
        
        ticketEvent.trigger(484848)
        XCTAssertEqual(numberMemory.value, 484848)
        
        numberMemory.cancel()
        ticketEvent.trigger(818181)
        XCTAssertEqual(numberMemory.value, 484848)
    }
    
    func testCancel() throws {
        let numberMemory = MemoryBehavior<Int>()
        weak var checker: AnyObject? = nil
        
        do {
            let ticketEvent = Event<Int>()
            checker = ticketEvent
            
            numberMemory.watch(to: ticketEvent)
            
            XCTAssertNotNil(checker)
        }

        XCTAssertNotNil(checker)
        numberMemory.cancel()
        XCTAssertNil(checker)
    }
    
    func testMemoryLeak() throws {
        weak var checker: AnyObject? = nil
        
        do {
            let numberMemory = MemoryBehavior<Int>()
            let ticketEvent = Event<Int>()
            checker = ticketEvent
            
            numberMemory.watch(to: ticketEvent)
            
            XCTAssertNotNil(checker)
        }
        
        XCTAssertNil(checker)
    }
}
