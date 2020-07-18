//
//  Subject.swift
//  Ultramarine
//  

private let MODIFY_SIGNAL_KEY = "modify"

public class Subject<Value>: Transmit<Value> {
    
    public init(_ initialValue: Value) {
        self.value = initialValue
    }
    
    public var value: Value {
        didSet { relay(value) }
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

// MARK: - Collection.

private let APPENDED_SIGNAL_KEY = "appended"
private let REMOVED_SIGNAL_KEY = "removed"

extension Subject where Value: RangeReplaceableCollection {
    
    public var appended: Signal<Value.Element>! { signal.get(name: APPENDED_SIGNAL_KEY) }
    public var removed: Signal<Value.Element>! { signal.get(name: REMOVED_SIGNAL_KEY) }
    
    public func append(_ newElement: Value.Element) {
        defer {
            appended?.fire(newElement)
            relay(value)
        }
        value.append(newElement)
    }
    
    @discardableResult
    public func remove(at i: Value.Index) -> Value.Element {
        let element = value.remove(at: i)
        
        removed?.fire(element)
        relay(value)
        
        return element
    }
    
    public subscript(index: Value.Index) -> Value.Element? {
        value.indices.contains(index) ? value[index] : nil
    }
    
    public func count() -> Subject<Int> {
        Subject.transform(source: self) { $0.count }
    }
}

// MARK: - Assign value operator.

infix operator <<=: AssignmentPrecedence

extension Subject {
    
    public static func <<= (subject: Subject, value: Value) {
        subject.value = value
    }
}
