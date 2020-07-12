//
//  Event.swift
//  Ultramarine
//

public class Event<Payload> {
    
    private(set) var subscriptions: Array<Subscription<Payload>> = []
    
    public init() {}
    
    public func trigger(_ payload: Payload) {
        let subscriptions = self.subscriptions
        subscriptions.forEach { $0.send(payload) }
    }
    
    @discardableResult
    func subscribe(_ subscription: Subscription<Payload>) -> Cancellable {
        subscriptions.append(subscription)
        return subscription
    }
}

extension Event: Publisher {
    
    public typealias Output = Payload
    
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
