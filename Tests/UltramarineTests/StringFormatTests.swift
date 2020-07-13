//
//  StringFormatTests.swift
//

import XCTest
import Ultramarine

class StringFormatTests: XCTestCase {
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testBasic() {
        let a = "Hello".continuous
        let b = "World".continuous
        
        let format = "\(%a), \(%b).".format
        
        XCTAssertEqual(format.value, "Hello, World.")
        
        b <<= "Alice"
        XCTAssertEqual(format.value, "Hello, Alice.")
        
        a <<= "Goodbye"
        XCTAssertEqual(format.value, "Goodbye, Alice.")
    }
    
    func testCustomStringConvertible() {
        let count = 0.continuous
        let label = "Tap: \(%count)".format
        
        XCTAssertEqual(label.value, "Tap: 0")
        
        count += 1
        XCTAssertEqual(label.value, "Tap: 1")
    }
    
    func testPerformance() {
        let a = "Hello".continuous
        let b = "World".continuous
        
        let format = "\(%a), \(%b).".format
        
        measure {
            (0...1000).forEach {
                a.value = "Hello \($0)"
                b.value = "Mr.\(Int.random(in: Int.zero...Int.max))"
                _ = format.value
            }
        }
    }
    
    func testReplace() {
        let name = "World".continuous
        let format = "Hello, \(%name).".format
        
        XCTAssertEqual(format.value, "Hello, World.")
        
        name <<= "Alice"
        XCTAssertEqual(format.value, "Hello, Alice.")
        
        format.replace(format: "Goodbye, \(%name).")
        XCTAssertEqual(format.value, "Goodbye, Alice.")
    }
    
    func testDefinitionOperator() {
        let name = "World".continuous
        let format = "Hello, \(%name).".format
        
        XCTAssertEqual(format.value, "Hello, World.")
        
        name <<= "Alice"
        XCTAssertEqual(format.value, "Hello, Alice.")
        
        format <> "Goodbye, \(%name)."
        XCTAssertEqual(format.value, "Goodbye, Alice.")
    }
    
    func testMemoryLeak() {
        weak var checker: AnyObject! = nil
        
        do {
            let name = "World".continuous
            let format = "Hello, \(%name).".format
            checker = name
            XCTAssertEqual(format.value, "Hello, World.")
            XCTAssertNotNil(checker)
        }
        
        XCTAssertNil(checker)
        
        do {
            let name = "World".continuous
            let format = "Hello, \(%name).".format
            checker = name
            format.replace(format: "Goodbye, \(%name).")
            XCTAssertEqual(format.value, "Goodbye, World.")
            XCTAssertNotNil(checker)
        }
        
        XCTAssertNil(checker)
        
        do {
            let name = "World".continuous
            let format = "Hello, \(%name).".format
            checker = name
            format.replace(format: "Goodbye, \(%name).".format)
            XCTAssertEqual(format.value, "Goodbye, World.")
            XCTAssertNotNil(checker)
        }
        
        XCTAssertNil(checker)
    }
}
