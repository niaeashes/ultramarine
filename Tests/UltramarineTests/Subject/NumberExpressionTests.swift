//
//  NumberExpressionTests.swift
//  UltramarineTests
//

import XCTest
import Ultramarine

class NumberExpressionTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testAdditionOperator() throws {
        let a = 1.subject()
        
        let b = a + 10
        
        do {
            XCTAssertEqual(a.value, 1)
            XCTAssertEqual(b.value, 11)
        }
        
        a += 10
        
        do {
            XCTAssertEqual(a.value, 11)
            XCTAssertEqual(b.value, 21)
        }
        
        a -= 6
        
        do {
            XCTAssertEqual(a.value, 5)
            XCTAssertEqual(b.value, 15)
        }
    }
    
    func testSubtractionOperator() throws {
        let a = 1.subject()
        
        let b = a - 10
        
        do {
            XCTAssertEqual(a.value, 1)
            XCTAssertEqual(b.value, -9)
        }
        
        a += 10
        
        do {
            XCTAssertEqual(a.value, 11)
            XCTAssertEqual(b.value, 1)
        }
        
        a -= 6
        
        do {
            XCTAssertEqual(a.value, 5)
            XCTAssertEqual(b.value, -5)
        }
    }
    
    func testMultiplicationOperator() throws {
        let a = 1.subject()
        
        let b = a * 2
        
        do {
            XCTAssertEqual(a.value, 1)
            XCTAssertEqual(b.value, 2)
        }
        
        a += 10
        
        do {
            XCTAssertEqual(a.value, 11)
            XCTAssertEqual(b.value, 22)
        }
        
        a -= 6
        
        do {
            XCTAssertEqual(a.value, 5)
            XCTAssertEqual(b.value, 10)
        }
    }
    
}
