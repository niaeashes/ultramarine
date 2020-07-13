//
//  ViewModelTests.swift
//  UltramarineTests
//

import XCTest
import Ultramarine

#if !os(macOS)
import UIKit

class UIKitViewModelTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    class LabelViewModel {
        
        typealias Input = String
        
        @Pub var text = ""
        
        let tapLabelEvent = UITapEvent<UILabel>()
        let tapButtonEvent = UITapEvent<UIButton>()
        
        func subscribe(_ label: UILabel) {
            $text.assign(to: \UILabel.text, on: label)
            tapLabelEvent.watch(label)
        }
        
        func subscribe(_ button: UIButton) {
            if let label = button.titleLabel {
                $text.assign(to: \UILabel.text, on: label)
            }
            tapButtonEvent.watch(button)
        }
    }
    
    class RecordSubscriber<Input>: Subscriber {
        
        typealias Input = Input
        
        private(set) var last: Input? = nil
        
        func notify(_ input: Input) {
            last = input
        }
    }
    
    func testBasicAssign() throws {
        let viewModel = LabelViewModel()
        let label = UILabel()
        
        viewModel.subscribe(label)
        
        viewModel.text = "updated 1"
        XCTAssertEqual(label.text, "updated 1")
        
        viewModel.$text <<= "updated 2"
        XCTAssertEqual(label.text, "updated 2")
    }
    
    func testAssignTargetHoldWeakRef() throws {
        let viewModel = LabelViewModel()
        weak var weakLabel: UILabel? = nil
        
        do {
            let label = UILabel()
            weakLabel = label
            
            viewModel.subscribe(label)
            
            viewModel.$text <<= "updated 1"
            XCTAssertEqual(label.text, "updated 1")
            
            XCTAssertNotNil(weakLabel)
        }
        
        XCTAssertNil(weakLabel)
    }
}

#endif
