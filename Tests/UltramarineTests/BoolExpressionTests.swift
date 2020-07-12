//
//  BoolExpressionTests.swift
//  UltramarineTests
//

import XCTest
import Ultramarine

class BoolExpressionTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testAnd() throws {
        let isBird = false.continuous
        let isMale = false.continuous
        
        let isMaleBird = isBird && isMale
        
        XCTAssertFalse(isMaleBird.value!)
        
        isBird <<= true
        XCTAssertTrue(isBird.value)
        XCTAssertFalse(isMale.value)
        XCTAssertFalse(isMaleBird.value!)
        
        isMale <<= true
        XCTAssertTrue(isBird.value)
        XCTAssertTrue(isMale.value)
        XCTAssertTrue(isMaleBird.value!)
    }
}
