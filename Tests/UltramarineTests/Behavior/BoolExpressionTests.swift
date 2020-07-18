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
        let isBird = false.subject()
        let isMale = false.subject()
        
        let isMaleBird = isBird && isMale
        
        XCTAssertFalse(isMaleBird.value)
        
        isBird <<= true
        XCTAssertTrue(isBird.value)
        XCTAssertFalse(isMale.value)
        XCTAssertFalse(isMaleBird.value)
        
        isMale <<= true
        XCTAssertTrue(isBird.value)
        XCTAssertTrue(isMale.value)
        XCTAssertTrue(isMaleBird.value)
    }
    
    func testOr() throws {
        let isLoadingA = false.subject()
        let isLoadingB = false.subject()
        
        let isNowLoading = isLoadingA || isLoadingB
        
        XCTAssertFalse(isNowLoading.value)
        
        isLoadingA <<= true
        isLoadingB <<= false
        XCTAssertTrue(isLoadingA.value)
        XCTAssertFalse(isLoadingB.value)
        XCTAssertTrue(isNowLoading.value)
        
        isLoadingA <<= false
        isLoadingB <<= true
        XCTAssertFalse(isLoadingA.value)
        XCTAssertTrue(isLoadingB.value)
        XCTAssertTrue(isNowLoading.value)
    }
    
    func testNot() throws {
        let isHead = true.subject()
        let isTail = !isHead
        
        XCTAssertTrue(isHead.value)
        XCTAssertFalse(isTail.value)
        
        isHead <<= false
        
        XCTAssertFalse(isHead.value)
        XCTAssertTrue(isTail.value)
    }
}
