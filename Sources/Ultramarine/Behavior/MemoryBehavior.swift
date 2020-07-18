//
//  MemoryBehavior.swift
//  Ultramarine
//

public class MemoryBehavior<Value>: Behavior<Value?> {
    
    public typealias Payload = Value
    
    private var cancellable: Cancellable? = nil
    private var source: Signal<Payload>!
    
    public init() {
        super.init(nil)
    }
    
    public func watch(to signal: Signal<Payload>) {
        source = signal
        cancellable?.cancel()
        cancellable = signal.sink { [weak self] value in self?.update(value) }
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
public struct SignalMemory<Value> {
    
    public init() {
        projectedValue = MemoryBehavior<Value>()
    }
    
    public var projectedValue: MemoryBehavior<Value>
    
    public var wrappedValue: Value? {
        get { return projectedValue.value }
    }
}
