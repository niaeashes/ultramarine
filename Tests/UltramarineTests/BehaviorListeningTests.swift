//
//  BehaviorListeningTests.swift
//  UltramarineTests
//

import XCTest
import Ultramarine

class BehaviorListeningTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    class Sample {
        @Sub var text = ""
        
        func mock() {}
    }
    
    func testBindingOperator() throws {
        
        // Binding operator: <>
        
        let sample = Sample()
        let text = "1".continuous
        
        sample.$text <> text
        
        text.value = "2"
        XCTAssertEqual(sample.text, "2")
        
        text.value = "3"
        XCTAssertEqual(sample.text, "3")
    }
    
    func testAssignValueOperator() throws {
        
        // Binding operator: <>
        
        let sample = Sample()
        let text = "1".continuous
        
        sample.$text.watch(to: text)
        
        text <<= "2"
        XCTAssertEqual(sample.text, "2")
        
        text <<= "3"
        XCTAssertEqual(sample.text, "3")
    }
    
    func testMemoryLeak1() {
        
        let text = "1".continuous
        weak var target: Behavior<String>? = nil
        
        do {
            let sample = Sample()
            sample.$text <> text
            target = sample.$text
            
            XCTAssertNotNil(target)
        }

        XCTAssertNil(target)
    }
    
    func testMemoryLeak2() {
        
        let text = "1".continuous
        weak var target: Sample? = nil
        
        do {
            let holder = Sample()
            text.onUpdate { [weak holder] value, cancellable in
                holder?.mock() ?? cancellable.cancel()
            }
            
            target = holder
            
            text.set("2")
            XCTAssertNotNil(target)
        }
        
        XCTAssertNil(target)
    }
}
