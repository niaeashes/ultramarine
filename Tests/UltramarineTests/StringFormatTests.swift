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
        
        let format = "\(%a), \(%b).".formated
        
        XCTAssertEqual(format.value, "Hello, World.")
    }
    
    func testPerformance() {
        measure {
            let a = "Hello".continuous
            let b = "World".continuous
            
            let format = "\(%a), \(%b).".formated
            
            (0...1000).forEach {
                a.set("Hello \($0)")
                b.set("Mr.\(Int.random(in: Int.zero...Int.max))")
                _ = format.value
            }
        }
    }
}
