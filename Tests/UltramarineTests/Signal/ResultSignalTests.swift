//
//  WatershedSignalTests.swift
//  UltramarineTests
//

import XCTest
import Ultramarine

class WatershedSignalTests: XCTestCase {
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    class SampleError: Error {}
    
    func testBasic() throws {
        let signal = ResultSignal<Int, SampleError>()
        var successCounter = 0
        var failureCounter = 0
        
        signal.succeed
            .sink { _ in successCounter += 1 }
        
        signal.failed
            .sink { _ in failureCounter += 1 }
        
        signal.success(10)
        signal.success(10)
        signal.failure(SampleError())
        
        XCTAssertEqual(successCounter, 2)
        XCTAssertEqual(failureCounter, 1)
    }
}
