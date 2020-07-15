//
//  ClosedBehavior.swift
//  Ultramarine
//

public final class ClosedBehavior<Value>: Behavior<Value> {
    
    private var cancellable: Cancellable? = nil
    private var source: Behavior<Value>!
    
    public func watch(to behavior: Behavior<Value>) {
        source = behavior
        cancellable?.cancel()
        cancellable = behavior.subscribe(Subscription<Value>() { [weak self] value, cancellable in
            if let self = self {
                self.update(value)
            } else {
                cancellable.cancel()
            }
        })
    }
    
    public var isNowWatching: Bool { cancellable != nil }
}

extension ClosedBehavior: Cancellable {
    
    public func cancel() {
        source = nil
        cancellable?.cancel()
        cancellable = nil
    }
    
    public var isCanceled: Bool { !isNowWatching }
}

@propertyWrapper
public struct Sub<Value> {
    
    public init(wrappedValue value: Value) {
        projectedValue = ClosedBehavior<Value>(value)
    }
    
    public var projectedValue: ClosedBehavior<Value>
    
    public var wrappedValue: Value {
        get { return projectedValue.value }
    }
}
