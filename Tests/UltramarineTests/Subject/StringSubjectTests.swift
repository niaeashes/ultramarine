//
//  StringSubjectTests.swift
//

import XCTest
import Ultramarine

class StringSubjectTests: XCTestCase {
    
    var cancellables = CancellableBag()
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        cancellables.cancel()
    }
    
    class Sample {
        var text: String = ""
    }
    
    func testBasic() {
        let obj = Sample()
        let name = "Alice".subject()
        
        name
            .assign(to: \Sample.text, on: obj)
            .store(to: cancellables)
        
        XCTAssertEqual(obj.text, "Alice")
        
        name <<= "Bob"
        XCTAssertEqual(obj.text, "Bob")
    }
    
    func testCustomStringConvertible() {
        let obj = Sample()
        let number = 0.subject()
        
        number
            .assign(describeTo: \Sample.text, on: obj)
            .store(to: cancellables)
        
        XCTAssertEqual(obj.text, "0")
        
        number <<= 717171
        XCTAssertEqual(obj.text, "717171")
    }
}
