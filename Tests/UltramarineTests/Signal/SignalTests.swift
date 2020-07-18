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
        let signal = Int.signal()
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
        let signal = Int.signal()
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
    
    func testActionRedister() {
        
        class Receiver {
            var last: Int = 0
            func update(_ value: Int) {
                self.last = value
            }
        }
        
        let signal = Int.signal()
        weak var checker: AnyObject? = nil
        
        do {
            let receiver = Receiver()
            
            signal.action(Receiver.update, on: receiver)
            checker = receiver
            
            XCTAssertNotEqual(receiver.last, 321321)
            signal.fire(321321)
            XCTAssertEqual(receiver.last, 321321)
        }
        
        XCTAssertNil(checker)
    }
    
    func testMemoryLeak() {
        
        do { //Filter
            var counter = 0
            weak var checker: Transmit<Int>? = nil
            
            do {
                let signal = Int.signal()
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
            weak var checker: Transmit<String>? = nil
            
            do {
                let signal = Int.signal()
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
