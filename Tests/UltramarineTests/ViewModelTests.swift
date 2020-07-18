//
//  ViewModelTests.swift
//  UltramarineTests
//

import XCTest
import Ultramarine

private class Button {
    weak var delegate: ButtonDelegate? = nil
    var text: String = ""
    
    func tap() {
        delegate?.onTap()
    }
}

private protocol ButtonDelegate: AnyObject {
    func onTap()
}

class ViewModelTests: XCTestCase {
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    private class ButtonViewModel: ButtonDelegate {
        
        typealias Input = String
        
        @Pub var text = ""
        
        let tapSignal = Signal<Void>.plug
        
        func subscribe(_ button: Button) {
            $text.assign(to: \Button.text, on: button)
            button.delegate = self
        }
        
        func onTap() {
            tapSignal.fire(Void())
        }
    }
    
    func testBasicAssign() throws {
        let viewModel = ButtonViewModel()
        let button = Button()
        var count = 0
        
        viewModel.subscribe(button)
        
        viewModel.text = "Button Title"
        XCTAssertEqual(button.text, "Button Title")
        
        _ = viewModel.tapSignal.sink { count += 1 }
        
        XCTAssertEqual(count, 0)
        
        button.tap()
        XCTAssertEqual(count, 1)
        
        button.tap()
        button.tap()
        button.tap()
        XCTAssertEqual(count, 4)
    }
}
