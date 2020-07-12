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
    
    func testAddOperator() throws {
        let a = 1.continuous
        
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
    
    func testMinusOperator() throws {
        let a = 1.continuous
        
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
}
