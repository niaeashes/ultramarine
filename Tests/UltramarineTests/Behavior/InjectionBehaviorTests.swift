//
//  InjectionBehaviorTests.swift
//  Ultramarine
//

import XCTest
import Ultramarine

class InjectionBehaviorTests: XCTestCase {
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testChain() throws {
        let a = 1.continuous
        let b = InjectionBehavior(source: a) { $0 + 10 }
        
        XCTAssertEqual(b.value, 11)
    }
    
    func testMemoryLeak() throws {
        weak var source: Behavior<Int>! = nil
        
        do {
            var target: InjectionBehavior<Int, Int>! = nil
            
            do {
                let a = 1.continuous
                source = a
                target = InjectionBehavior(source: a) { $0 - 10 }
            }
            
            XCTAssertNotNil(source)
            XCTAssertNotNil(target) // [!] for ignore warning.
        }
        
        XCTAssertNil(source)
    }
}
