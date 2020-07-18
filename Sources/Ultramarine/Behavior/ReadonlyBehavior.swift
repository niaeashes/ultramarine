//
//  ReadonlyBehavior.swift
//  Ultramarine
//

public final class ReadonlyBehavior<Value>: Behavior<Value> {
    
    private var cancellable: Cancellable? = nil
    private var source: Behavior<Value>!
    
    public func watch(to behavior: Behavior<Value>) {
        source = behavior
        cancellable?.cancel()
        cancellable = behavior.chain { [weak self] in self?.refresh() }
    }
    
    func refresh() {
        update(source.value)
    }
    
    public var isNowWatching: Bool { cancellable != nil }
}

extension ReadonlyBehavior: Cancellable {
    
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
        projectedValue = ReadonlyBehavior<Value>(value)
    }
    
    public var projectedValue: ReadonlyBehavior<Value>
    
    public var wrappedValue: Value {
        get { return projectedValue.value }
    }
}
