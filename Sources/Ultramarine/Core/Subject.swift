//
//  Subject.swift
//  Ultramarine
//

import Foundation

private let MODIFY_SIGNAL_KEY = "modify"

protocol Publisher {
    func publish()
}

public final class Subject<Value>: Transmit<Value>, Publisher {
    
    public init(_ initialValue: Value) {
        self.value = initialValue
    }
    
    public var value: Value {
        didSet {
            // [!] If Value is not Equatable, isEquals always return false.
            if isEquals(value, oldValue) { return }
            relay(value)
        }
    }
    
    public func async(update value: Value, in dispatch: DispatchQueue? = nil) {
        (dispatch ?? DispatchQueue.global(qos: .background)).async { [weak self] in
            self?.value = value
        }
    }
    
    public func publish() {
        relay(value)
    }
    
    override func relay(_ value: Value) {
        if signal.has(name: MODIFY_SIGNAL_KEY) {
            modifySignal?.fire(value)
        }
        super.relay(value)
    }
    
    let signal = SignalBox()
    
    public var modifySignal: Signal<Value>! { signal.get(name: MODIFY_SIGNAL_KEY) }
}

final class SignalBox {
    
    private var holder: Dictionary<String, AnyObject> = [:]
    
    func has(name: String) -> Bool {
        return holder[name] != nil
    }
    
    func get<Value>(name: String) -> Signal<Value>? {
        if let obj = holder[name] {
            return obj as? Signal<Value>
        } else {
            let publisher = Signal<Value>()
            holder[name] = publisher
            return publisher
        }
    }
}

// MARK: - Assign value operator.

infix operator <<=: AssignmentPrecedence

extension Subject {
    
    public static func <<= (subject: Subject, value: Value) {
        subject.value = value
    }
}
