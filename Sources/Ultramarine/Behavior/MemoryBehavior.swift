//
//  MemoryBehavior.swift
//  Ultramarine
//

public class MemoryBehavior<Value>: Behavior<Value?> {
    
    public typealias Payload = Value
    
    private var cancellable: Cancellable? = nil
    private var source: Event<Payload>!
    
    public init() {
        super.init(nil)
    }
    
    public func watch(to event: Event<Payload>) {
        source = event
        cancellable?.cancel()
        cancellable = event.subscribe(Subscription<Value>() { [weak self] value, cancellable in
            if let self = self {
                self.update(value)
            } else {
                cancellable.cancel()
            }
        })
    }
    
    public var isNowWatching: Bool { cancellable != nil }
}

extension MemoryBehavior: Cancellable {
    
    public func cancel() {
        source = nil
        cancellable?.cancel()
        cancellable = nil
    }
    
    public var isCanceled: Bool { !isNowWatching }
}

@propertyWrapper
public struct EventMemory<Value> {
    
    public init() {
        projectedValue = MemoryBehavior<Value>()
    }
    
    public var projectedValue: MemoryBehavior<Value>
    
    public var wrappedValue: Value? {
        get { return projectedValue.value }
    }
}
