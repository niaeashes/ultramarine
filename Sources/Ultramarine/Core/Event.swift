//
//  Event.swift
//  Ultramarine
//

public class Event<Payload> {
    
    private(set) var subscriptions: Array<Subscription<Payload>> = []
    private var inProcess = false
    
    public init() {}
    
    public func trigger(_ payload: Payload) {
        if inProcess == true { return }
        defer { inProcess = false }
        inProcess = true
        
        let subscriptions = self.subscriptions
        subscriptions.forEach { $0.send(payload) }
    }
    
    public func map<Value>(_ handler: @escaping (Output) -> Value) -> Event<Value> {
        let nextEvent = Event<Value>()
        _ = subscribe(Subscription<Output>() { [nextEvent] value, _ in nextEvent.trigger(handler(value)) })
        return nextEvent
    }
    
    public func filter(_ handler: @escaping (Output) -> Bool) -> Event<Output> {
        let nextEvent = Event<Output>()
        _ = subscribe(Subscription<Output>() { [nextEvent] value, _ in
            if handler(value) { nextEvent.trigger(value) }
        })
        return nextEvent
    }
    
    func subscribe(_ subscription: Subscription<Payload>) -> Cancellable {
        subscriptions.append(subscription)
        return subscription
    }
}

extension Event: Publisher {
    
    public typealias Output = Payload
    
    @discardableResult
    public func sink(_ completion: @escaping (Output) -> Void) -> Cancellable {
        return subscribe(Subscription<Output>() { value, _ in completion(value) })
    }
}
