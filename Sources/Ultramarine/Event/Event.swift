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
    
    public func sink(_ completion: @escaping (Output) -> Void) -> Cancellable {
        return subscribe(Subscription<Output>() { value, _ in completion(value) })
    }
}
