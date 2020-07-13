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
