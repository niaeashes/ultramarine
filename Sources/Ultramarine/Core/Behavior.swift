//
//  ContinuousBehavior.swift
//

private let SINGLE_SIGNAL_KEY = "single"

///
/// Behavior is an object that always has a value.
///
public class Behavior<Value> {
    
    public private(set) var value: Value
    public var signal: SignalStream<Value> {
        singleStream = singleStream ?? SignalStream<Value>()
        return singleStream!
    }
    
    var signalHolder: Dictionary<String, AnyObject> = [:]
    private var singleStream: SignalStream<Value>? {
        get { signalHolder[SINGLE_SIGNAL_KEY] as? SignalStream<Value> }
        set { signalHolder[SINGLE_SIGNAL_KEY] = newValue }
    }
    
    init(_ initialValue: Value) {
        self.value = initialValue
    }
    
    func update(_ value: Value) {
        self.value = value
        updated()
    }
    
    func updated() {
        
        singleStream?.fire(value)
        
        do {
            let subscriptions = self.subscriptions
            subscriptions.forEach { $0.execute(value) }
        }
    }
    
    private(set) var subscriptions: Array<Subscription<Value>> = []
    
    func subscribe(_ subscription: Subscription<Value>) -> Subscription<Value> {
        subscriptions.append(subscription)
        return subscription
    }
    
    @discardableResult
    func chain(_ handler: @escaping () -> Void) -> Cancellable {
        return subscribe(Subscription<Value>() { _, _ in handler() })
    }
}

// MARK: - CustomStringConvertible Behavior.

extension Behavior: CustomStringConvertible where Value: CustomStringConvertible {
    
    public var description: String {
        value.description
    }
}

// MARK: - Collection Behavior.

private let APPENDED_SIGNAL_KEY = "appended"
private let REMOVED_SIGNAL_KEY = "removed"

extension Behavior where Value: Collection {
    
    public subscript(_ position: Value.Index) -> Value.Element? {
        value.indices.contains(position) ? value[position] : nil
    }
}

extension Behavior where Value: RangeReplaceableCollection {
    
    public var appended: SignalStream<Value.Element> {
        appendedStream = appendedStream ?? SignalStream<Value.Element>()
        return appendedStream!
    }
    
    private var appendedStream: SignalStream<Value.Element>? {
        get { signalHolder[APPENDED_SIGNAL_KEY] as? SignalStream<Value.Element> }
        set { signalHolder[APPENDED_SIGNAL_KEY] = newValue }
    }
    
    public var removed: SignalStream<Value.Element> {
        removedStream = removedStream ?? SignalStream<Value.Element>()
        return removedStream!
    }
    
    private var removedStream: SignalStream<Value.Element>? {
        get { signalHolder[REMOVED_SIGNAL_KEY] as? SignalStream<Value.Element> }
        set { signalHolder[REMOVED_SIGNAL_KEY] = newValue }
    }
    
    public func append(_ newElement: Value.Element) {
        defer {
            appendedStream?.fire(newElement)
            updated()
        }
        value.append(newElement)
    }
    
    @discardableResult
    public func remove(at i: Value.Index) -> Value.Element {
        let element = value.remove(at: i)
        
        removedStream?.fire(element)
        updated()
        
        return element
    }
    
    public func filter(_ isIncluded: @escaping (Value.Element) -> Bool) -> Behavior<Value> {
        InjectionBehavior<Value, Value>(source: self) { $0.filter(isIncluded) }
    }
}

// MARK - Assignable Behavior.

extension Behavior {
    
    @discardableResult
    public func assign<Root: AnyObject>(to keyPath: ReferenceWritableKeyPath<Root, Value>, on object: Root) -> Cancellable {
        
        return subscribe(Subscription(to: keyPath, on: object)).execute(value)
    }
    
    @discardableResult
    public func assign<Root: AnyObject>(to keyPath: ReferenceWritableKeyPath<Root, Optional<Value>>, on object: Root) -> Cancellable {
        
        return subscribe(Subscription(to: keyPath, on: object)).execute(value)
    }
}

extension Behavior: CustomDebugStringConvertible {
    
    public var debugDescription: String {
        (["[\(type(of: self))] = \"\(value)\" with \(subscriptions.count) subscriptions"] + subscriptions.map { "  -> " + $0.debugDescription }).joined(separator: "\n")
    }
}
