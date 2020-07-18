//
//  ContinuousBehavior.swift
//

private let SINGLE_SIGNAL_KEY = "single"

///
/// Behavior is an object that always has a value.
///
public class Behavior<Value> {
    
    public private(set) var value: Value
    public var signal: Signal<Value> {
        singleSignal = singleSignal ?? Signal<Value>()
        return singleSignal!
    }
    
    var signalHolder: Dictionary<String, AnyObject> = [:]
    private var singleSignal: Signal<Value>? {
        get { signalHolder[SINGLE_SIGNAL_KEY] as? Signal<Value> }
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
        
        singleSignal?.fire(value)
        
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
    
    public var appended: Signal<Value.Element> {
        appendedSignal = appendedSignal ?? Signal<Value.Element>()
        return appendedSignal!
    }
    
    private var appendedSignal: Signal<Value.Element>? {
        get { signalHolder[APPENDED_SIGNAL_KEY] as? Signal<Value.Element> }
        set { signalHolder[APPENDED_SIGNAL_KEY] = newValue }
    }
    
    public var removed: Signal<Value.Element> {
        removedSignal = removedSignal ?? Signal<Value.Element>()
        return removedSignal!
    }
    
    private var removedSignal: Signal<Value.Element>? {
        get { signalHolder[REMOVED_SIGNAL_KEY] as? Signal<Value.Element> }
        set { signalHolder[REMOVED_SIGNAL_KEY] = newValue }
    }
    
    public func append(_ newElement: Value.Element) {
        defer {
            appendedSignal?.fire(newElement)
            updated()
        }
        value.append(newElement)
    }
    
    @discardableResult
    public func remove(at i: Value.Index) -> Value.Element {
        let element = value.remove(at: i)
        
        removedSignal?.fire(element)
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
