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
        }
    }
    
    public func watch(to behavior: Behavior<Value>) {
        cancellable?.cancel()
        cancellable = behavior.connect(to: subscriber)
    }
}

extension ClosedBehavior: Cancellable {
    
    public func cancel() {
        cancellable?.cancel()
        cancellable = nil
    }
    
    public var isCanceled: Bool { cancellable == nil }
}

// MARK: - Utilities.

extension ClosedBehavior {
    
    public var nowWatching: Bool {
        return cancellable != nil
    }
}
