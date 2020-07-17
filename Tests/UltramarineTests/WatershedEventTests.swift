//
//  WatershedEventTests.swift
//  UltramarineTests
//

import XCTest
import Ultramarine

class WatershedEventTests: XCTestCase {
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    class SampleError: Error {}
    
    func testBasic() throws {
        let event = WatershedEvent<Int, SampleError>()
        var successCounter = 0
        var failureCounter = 0
        
        event.succeed
            .sink { _ in successCounter += 1 }
        
        event.failed
            .sink { _ in failureCounter += 1 }
        
        event.success(10)
        event.success(10)
        event.failure(SampleError())
        
        XCTAssertEqual(successCounter, 2)
        XCTAssertEqual(failureCounter, 1)
    }
}
