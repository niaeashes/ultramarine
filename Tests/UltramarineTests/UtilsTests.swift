//
//  UtilsTests.swift
//  UltramarineTests
//

import XCTest
@testable import Ultramarine

class UtilsTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testBasic() throws {
        
         // [!] Void is not Equatable.
        XCTAssertFalse(isEquals((), ()))
        
         // [!] Int is Equatable.
        XCTAssertTrue(isEquals(1, 1))
        XCTAssertFalse(isEquals(1, 2))
        
    }
}
