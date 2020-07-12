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
    }
    
    func testBindingOperator() throws {
        
        // Binding operator: <>
        
        let sample = Sample()
        let text = "1".continuous
        
        sample.$text <> text
        
        text.receive("2")
        XCTAssertEqual(sample.text, "2")
        
        text.receive("3")
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
}
