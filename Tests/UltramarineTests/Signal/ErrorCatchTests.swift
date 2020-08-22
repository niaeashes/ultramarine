//
//  ErrorCatchTests.swift
//  Ultramarine
//

import XCTest
import Ultramarine

class ErrorCatchTests: XCTestCase {
    
    class TestError: Error {}
    
    func testErrorCatch() {
        let signal = ResultSignal<Void, Error>()
        var error: Error? = nil
        
        let sub = signal
            .do { _ in XCTFail() }
            .catch { error = $0 }
        
        signal.fire(error: TestError())
        
        XCTAssert(error is TestError)
        
        sub.cancel()
        error = nil
        
        signal.fire(error: TestError())
        
        XCTAssertNil(error)
    }
}
