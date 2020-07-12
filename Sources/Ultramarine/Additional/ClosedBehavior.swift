//
//  ClosedBehavior.swift
//  Ultramarine
//

public final class ClosedBehavior<Value>: Behavior<Value> {
    
    private lazy var subscriber: PrivateSubscriber<Value> = {
        return PrivateSubscriber(self)
    }()
    private var cancellable: Cancellable? = nil
    
    private class PrivateSubscriber<Value>: Subscriber {
        typealias Input = Value
        
        weak var root: ClosedBehavior<Value>?
        
        init(_ root: ClosedBehavior<Value>) {
            self.root = root
        }
        
        func notify(_ input: Value) {
            root?.update(input)
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

// MARK: - Utilities.

extension ClosedBehavior {
    
    public var nowWatching: Bool {
        return cancellable != nil
    }
}
