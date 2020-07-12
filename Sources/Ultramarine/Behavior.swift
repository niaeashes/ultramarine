//
//  ContinuousBehavior.swift
//  Ultramarine
//

///
/// Behavior is an object that always has a value.
///
public class Behavior<Value> {
    
    public private(set) var value: Value
    
    private var subscriptions: Array<Subscription<Value>> = []
    
    public init(_ initialValue: Value) {
        self.value = initialValue
    }
    
    func set(_ value: Value) {
        self.value = value
        do {
            let subscriptions = self.subscriptions
            subscriptions.forEach { $0.send(value) }
        }
    }
    
    func subscribe(_ subscription: Subscription<Value>) {
        subscriptions.append(subscription)
    }
}

extension Behavior where Value: Equatable {
    
    func set(_ value: Value) {
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
        
        let sub = Subscription<Output> { [weak subscriber] value, cancellable in
            if let subscriber = subscriber {
                subscriber.receive(value)
            } else {
                cancellable.cancel()
            }
        }
        subscriptions.append(sub)
        sub.send(self.value)
        
        return sub
    }
}

// MARK: - The Behavior is a Subscriber.

extension Behavior: Subscriber {
    
    public typealias Input = Value
    
    public func receive(_ input: Input) {
        set(input)
    }
}

// MARK: - Resgister handler.

extension Behavior {
    
    public func onUpdate(_ completion: @escaping (Value, Cancellable) -> Void) -> Cancellable {
        
        let sub = Subscription<Value>(completion)
        subscriptions.append(sub)
        
        return sub
    }
}
