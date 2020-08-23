//
//  Signal.swift
//  Ultramarine
//

public final class Signal<Value>: Transmit<Value> {
    
    public override init() {}
    
    public func fire(_ value: Value) {
        relay(value)
    }
    
    public typealias Pipe = Transmit<Value>
}

extension Signal where Value == Void {
    
    public func fire() {
        relay(Void())
    }
}

// MARK: - Result.

public final class ResultSignal<Success, Failure: Error>: Transmit<Result<Success, Failure>> {
    
    public override init() {}
    
    public func fire(value: Success) {
        relay(.success(value))
    }
    
    public func fire(error value: Failure) {
        relay(.failure(value))
    }
    
    public typealias Pipe = Transmit<Result<Success, Failure>>
}
