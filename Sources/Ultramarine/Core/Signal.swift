//
//  Signal.swift
//  Ultramarine
//

public class Signal<Payload> {
    
    private(set) var subscriptions: Array<Subscription<Payload>> = []
    private var inProcess = false
    
    public init() {}
    
    public func fire(_ payload: Payload) {
        if inProcess == true { return }
        defer { inProcess = false }
        inProcess = true
        
        let subscriptions = self.subscriptions
        subscriptions.forEach { $0.send(payload) }
    }
    
    public func map<Value>(_ handler: @escaping (Output) -> Value) -> Signal<Value> {
        let nextSignal = Signal<Value>()
        _ = subscribe(Subscription<Output>() { [nextSignal] value, _ in nextSignal.fire(handler(value)) })
        return nextSignal
    }
    
    public func filter(_ handler: @escaping (Output) -> Bool) -> Signal<Output> {
        let nextSignal = Signal<Output>()
        _ = subscribe(Subscription<Output>() { [nextSignal] value, _ in
            if handler(value) { nextSignal.fire(value) }
        })
        return nextSignal
    }
    
    func subscribe(_ subscription: Subscription<Payload>) -> Cancellable {
        subscriptions.append(subscription)
        return subscription
    }
}

extension Signal: Publisher {
    
    public typealias Output = Payload
    
    @discardableResult
    public func sink(_ completion: @escaping (Output) -> Void) -> Cancellable {
        return subscribe(Subscription<Output>() { value, _ in completion(value) })
    }
}
