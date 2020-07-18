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
        let ticketSignal = Signal<Int>()
        
        XCTAssertNil(numberMemory.value)
        
        ticketSignal.fire(101010)
        XCTAssertNil(numberMemory.value)
        
        numberMemory.watch(to: ticketSignal)
        
        ticketSignal.fire(484848)
        XCTAssertEqual(numberMemory.value, 484848)
        
        numberMemory.cancel()
        ticketSignal.fire(818181)
        XCTAssertEqual(numberMemory.value, 484848)
    }
    
    func testCancel() throws {
        let numberMemory = MemoryBehavior<Int>()
        weak var checker: AnyObject? = nil
        
        do {
            let ticketSignal = Signal<Int>()
            checker = ticketSignal
            
            numberMemory.watch(to: ticketSignal)
            
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
            let ticketSignal = Signal<Int>()
            checker = ticketSignal
            
            numberMemory.watch(to: ticketSignal)
            
            XCTAssertNotNil(checker)
        }
        
        XCTAssertNil(checker)
    }
}
