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

// MARK: - The Behavior is a Publisher.

extension Behavior: Publisher {
    
    public typealias Output = Value
    
    @discardableResult
    public func connect<S>(to subscriber: S) -> Cancellable where S : Subscriber, Output == S.Input {
        
        return subscribe(Subscription<Output> { [weak subscriber] value, cancellable in
            if let subscriber = subscriber {
                subscriber.receive(value)
            } else {
                cancellable.cancel()
            }
        })
    }
}

// MARK: - Resgister handler.

extension Behavior {
    
    public func onUpdate(_ completion: @escaping (Value, Cancellable) -> Void) -> Cancellable {
        return subscribe(Subscription<Value>(completion))
    }
}
