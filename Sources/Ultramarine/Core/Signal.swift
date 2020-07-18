//
//  Signal.swift
//  Ultramarine
//

public class Signal<Payload> {
    
    private(set) var subscriptions: Array<Subscription<Payload>> = []
    private var inProcess = false
    
    func fire(_ payload: Payload) {
        if inProcess == true { return }
        defer { inProcess = false }
        inProcess = true
        
        let subscriptions = self.subscriptions
        subscriptions.forEach { $0.execute(payload) }
    }
    
    @discardableResult
    func subscribe(_ subscription: Subscription<Payload>) -> Cancellable {
        subscriptions.append(subscription)
        return subscription
    }
}

extension Signal {
    
    public typealias Output = Payload
    
    public func map<Value>(_ handler: @escaping (Output) -> Value) -> Signal<Value> {
        let nextSignal = Signal<Value>()
        subscribe(Subscription<Output>() { [nextSignal] value, _ in nextSignal.fire(handler(value)) })
        return nextSignal
    }
    
    public func filter(_ handler: @escaping (Output) -> Bool) -> Signal<Output> {
        let nextSignal = Signal<Output>()
        subscribe(Subscription<Output>() { [nextSignal] value, _ in
            if handler(value) { nextSignal.fire(value) }
        })
        return nextSignal
    }
    
    @discardableResult
    public func sink(_ completion: @escaping (Output) -> Void) -> Cancellable {
        return subscribe(Subscription<Output>() { value, _ in completion(value) })
    }
}

// MARK: - Plug.

public final class Plug<Payload>: Signal<Payload> {
    
    public override init() {}
    
    public override func fire(_ payload: Payload) {
        super.fire(payload)
    }
}

extension Signal {
    
    public static var plug: Plug<Payload> { Plug<Payload>() }
}
