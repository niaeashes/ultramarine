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
        cancellable = behavior.sink { [weak self] value in self?.update(value) }
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
