//
//  ClosedBehavior.swift
//  Ultramarine
//

public final class ClosedBehavior<Value> {
    
    public private(set) var value: Value
    
    private lazy var subscriber: PrivateSubscriber<Value> = {
        return PrivateSubscriber(self)
    }()
    private var cancellable: Cancellable? = nil
    private var subscriptions: Array<Subscription<Value>> = []
    
    init(_ initialValue: Value) {
        self.value = initialValue
    }
    
    private class PrivateSubscriber<Value>: Subscriber {
        typealias Input = Value
        
        weak var root: ClosedBehavior<Value>?
        
        init(_ root: ClosedBehavior<Value>) {
            self.root = root
        }
        
        func receive(_ input: Value) {
            root?.value = input
            root?.relay()
        }
    }
    
    private func relay() {
        do {
            let subscriptions = self.subscriptions
            let value = self.value
            subscriptions.forEach { $0.send(value) }
        }
    }
    
    public func watch(to behavior: Behavior<Value>) {
        cancellable?.cancel()
        cancellable = behavior.connect(to: subscriber)
    }
}

extension ClosedBehavior: Publisher {
    
    public typealias Output = Value
    
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

// MARK: - Utilities.

extension ClosedBehavior {
    
    public var nowReceivingValue: Bool {
        return cancellable != nil
    }
}
