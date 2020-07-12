//
//  ViewModelTests.swift
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
        
        let tapEvent = Event<Void, Never>()
        
        func subscribe(_ button: Button) {
            $text.assign(to: \Button.text, on: button)
            button.delegate = self
        }
        
        func onTap() {
            tapEvent.notify(Void())
        }
    }
    
    class Counter: Subscriber {
        typealias Input = Void
        
        private(set) var count = 0
        
        func notify(_ input: Void) {
            count += 1
        }
    }
    
    func testBasicAssign() throws {
        let viewModel = ButtonViewModel()
        let button = Button()
        
        viewModel.subscribe(button)
        
        viewModel.text = "Button Title"
        XCTAssertEqual(button.text, "Button Title")
        
        let counter = Counter()
        viewModel.tapEvent.connect(postTo: counter)
        
        XCTAssertEqual(counter.count, 0)
        
        button.tap()
        XCTAssertEqual(counter.count, 1)
        
        button.tap()
        button.tap()
        button.tap()
        XCTAssertEqual(counter.count, 4)
    }
}
