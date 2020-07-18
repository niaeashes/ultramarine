//
//  Signal.swift
//  Ultramarine
//

// MARK: - SignalStream.

public class SignalStream<Payload> {
    
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

extension SignalStream {
    
    public typealias Output = Payload
    
    public func map<Value>(_ handler: @escaping (Output) -> Value) -> SignalStream<Value> {
        let nextStream = SignalStream<Value>()
        subscribe(Subscription<Output>() { [nextStream] value, _ in nextStream.fire(handler(value)) })
        return nextStream
    }
    
    public func filter(_ handler: @escaping (Output) -> Bool) -> SignalStream<Output> {
        let nextStream = SignalStream<Output>()
        subscribe(Subscription<Output>() { [nextStream] value, _ in
            if handler(value) { nextStream.fire(value) }
        })
        return nextStream
    }
    
    @discardableResult
    public func sink(_ completion: @escaping (Output) -> Void) -> Cancellable {
        return subscribe(Subscription<Output>() { value, _ in completion(value) })
    }
}

// MARK: - Signal.

public class Signal<Payload>: SignalStream<Payload> {
    
    public override init() {}
    
    public override func fire(_ payload: Payload) {
        super.fire(payload)
    }
}
