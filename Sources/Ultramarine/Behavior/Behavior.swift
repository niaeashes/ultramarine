//
//  ContinuousBehavior.swift
//  Ultramarine
//

///
/// Behavior is an object that always has a value.
///
public class Behavior<Value> {
    
    public private(set) var value: Value
    
    private(set) var subscriptions: Array<Subscription<Value>> = []
    
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
    
    @discardableResult
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
    public func connect<S>(to subscriber: S) -> Cancellable where S : Subscriber, Output == S.Input {
        
        return subscribe(Subscription<Output> { [weak subscriber] value, cancellable in
            if let subscriber = subscriber {
                subscriber.notify(value)
            } else {
                cancellable.cancel()
            }
        })
    }
}

// MARK: - Resgister handler.

extension Behavior {
    
    @discardableResult
    public func onUpdate(_ completion: @escaping (Value, Cancellable) -> Void) -> Cancellable {
        return subscribe(Subscription<Value>(completion))
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
        subscribe(sub)
        sub.send(value)
        
        return sub
    }
    
    @discardableResult
    public func assign<Root: AnyObject>(to keyPath: ReferenceWritableKeyPath<Root, Optional<Output>>, on object: Root) -> Cancellable {
        
        let sub = Subscription(to: keyPath, on: object)
        subscribe(sub)
        sub.send(value)
        
        return sub
    }
}
