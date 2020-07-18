//
//  SignalTests.swift
//  Ultramarine
//

import XCTest
import Ultramarine

class SignalTests: XCTestCase {
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testBasic() throws {
        let signal = Signal<Void>()
        var counter = 0
        
        signal.sink { counter += 1 }
        signal.fire(())
        signal.fire(())
        signal.fire(())
        XCTAssertEqual(counter, 3)
    }
    
    func testFilter() throws {
        let signal = Signal<Int>()
        var counter = 0
        
        let sub = signal
            .filter { ($0 % 2) == 0 }
            .sink { _ in counter += 1 }
        
        signal.fire(1)
        signal.fire(2)
        signal.fire(3)
        XCTAssertEqual(counter, 1)
        
        sub.cancel()
        
        signal.fire(2)
        XCTAssertEqual(counter, 1)
    }
    
    func testMap() throws {
        let signal = Signal<Int>()
        var counter = ""
        
        let sub = signal
            .map { "\($0)" }
            .sink { counter += $0 }
        
        signal.fire(1)
        signal.fire(2)
        signal.fire(3)
        XCTAssertEqual(counter, "123")
        
        sub.cancel()
        
        signal.fire(4)
        XCTAssertEqual(counter, "123")
    }
    
    func testMemoryLeak() {
        
        do { //Filter
            var counter = 0
            weak var checker: SignalStream<Int>? = nil
            
            do {
                let signal = Signal<Int>()
                let filter = signal.filter { $0 % 2 == 0 }
                _ = filter.sink { _ in counter += 1 }
                checker = filter
                
                signal.fire(2)
                XCTAssertEqual(counter, 1)
                
                XCTAssertNotNil(checker)
            }
            
            XCTAssertNil(checker)
        }
        
        do { // Map
            var counter = ""
            weak var checker: SignalStream<String>? = nil
            
            do {
                let signal = Signal<Int>()
                let map = signal.map { "\($0)" }
                _ = map.sink { counter += $0 }
                checker = map
                
                signal.fire(2)
                XCTAssertEqual(counter, "2")
                
                XCTAssertNotNil(checker)
            }
            
            XCTAssertNil(checker)
        }
    }
}
