//
//  ContinuousBehavior.swift
//

///
/// Behavior is an object that always has a value.
///
public class Behavior<Value> {
    
    public private(set) var value: Value
    
    init(_ initialValue: Value) {
        self.value = initialValue
    }
    
    func update(_ value: Value) {
        self.value = value
        do {
            let subscriptions = self.subscriptions
            subscriptions.forEach { $0.send(value) }
        }
    }
    
    private(set) var subscriptions: Array<Subscription<Value>> = []
    
    func subscribe(_ subscription: Subscription<Value>) -> Cancellable {
        subscriptions.append(subscription)
        return subscription
    }
}

extension Behavior where Value: Equatable {
    
    func update(_ value: Value) {
        guard value != self.value else { return }
        self.value = value
        do {
            let subscriptions = self.subscriptions
            subscriptions.forEach { $0.send(value) }
        }
    }
}

// MARK: - The Behavior is always a Publisher.

extension Behavior: Publisher {
    
    public typealias Output = Value
    
    @discardableResult
    public func sink(_ completion: @escaping (Output) -> Void) -> Cancellable {
        return subscribe(Subscription<Output>() { value, _ in completion(value) })
    }
}

// MARK - CustomStringConvertible Behavior.

extension Behavior: CustomStringConvertible where Value: CustomStringConvertible {
    
    public var description: String {
        value.description
    }
}

// MARK - Assignable Behavior.

extension Behavior where Output: Continuous {
    
    @discardableResult
    public func assign<Root: AnyObject>(to keyPath: ReferenceWritableKeyPath<Root, Output>, on object: Root) -> Cancellable {
        
        let sub = Subscription(to: keyPath, on: object)
        sub.send(value)
        
        return subscribe(sub)
    }
    
    @discardableResult
    public func assign<Root: AnyObject>(to keyPath: ReferenceWritableKeyPath<Root, Optional<Output>>, on object: Root) -> Cancellable {
        
        let sub = Subscription(to: keyPath, on: object)
        sub.send(value)
        
        return subscribe(sub)
    }
}

extension Behavior: CustomDebugStringConvertible {
    
    public var debugDescription: String {
        (["[\(type(of: self))] = \"\(value)\" with \(subscriptions.count) subscriptions"] + subscriptions.map { "  " + $0.debugDescription }).joined(separator: "\n")
    }
}
