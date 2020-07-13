//
//  ClosedBehavior.swift
//  Ultramarine
//

public final class ClosedBehavior<Value>: Behavior<Value> {
    
    private var cancellable: Cancellable? = nil
    
    public func watch(to behavior: Behavior<Value>) {
        cancellable?.cancel()
        cancellable = behavior.sink { [weak self] value in self?.update(value) }
    }
    
    public var isNowWatching: Bool { cancellable != nil }
}

extension ClosedBehavior: Cancellable {
    
    public func cancel() {
        cancellable?.cancel()
        cancellable = nil
    }
    
    public var isCanceled: Bool { !isNowWatching }
}
