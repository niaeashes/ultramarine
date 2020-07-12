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
        
        init() {
            recoginizer = UITapGestureRecognizer(target: $tapEvent, action: $tapEvent.selector)
        }
        
        @Selectable var tapEvent: Event<UITapGestureRecognizer>
        var recoginizer: UITapGestureRecognizer! = nil
        
        func subscribe(_ label: UILabel) {
            $text.assign(to: \UILabel.text, on: label)
            label.addGestureRecognizer(recoginizer)
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
    
    func testTapEvent() {
        let viewModel = LabelViewModel()
        let label = UILabel()
        let sub = RecordSubscriber<UITapGestureRecognizer>()

        label.isUserInteractionEnabled = true
        
        viewModel.subscribe(label)
        
        viewModel.tapEvent.connect(to: sub)
        
        label.text = "updated 1"
        
        do {
            XCTAssertNil(sub.last)
            viewModel.recoginizer.execute()
            XCTAssertEqual(sub.last, viewModel.recoginizer)
        }
    }
}

// Return type alias
private typealias TargetActionInfo = [(target: AnyObject, action: Selector)]

// UIGestureRecognizer extension
private extension UIGestureRecognizer {
    
    func getTargetInfo() -> TargetActionInfo {
        var targetsInfo: TargetActionInfo = []
        
        if let targets = self.value(forKeyPath: "_targets") as? [NSObject] {
            for target in targets {
                // Getting selector by parsing the description string of a UIGestureRecognizerTarget
                let selectorString = String.init(describing: target).components(separatedBy: ", ").first!.replacingOccurrences(of: "(action=", with: "")
                let selector = NSSelectorFromString(selectorString)
                
                // Getting target from iVars
                let targetActionPairClass: AnyClass = NSClassFromString("UIGestureRecognizerTarget")!
                let targetIvar: Ivar = class_getInstanceVariable(targetActionPairClass, "_target")!
                let targetObject: AnyObject = object_getIvar(target, targetIvar) as AnyObject
                
                targetsInfo.append((target: targetObject, action: selector))
            }
        }
        
        return targetsInfo
    }
    
    func execute() {
        let targetsInfo = self.getTargetInfo()
        for info in targetsInfo {
            info.target.performSelector(onMainThread: info.action, with: self, waitUntilDone: true)
        }
    }
}

#endif
