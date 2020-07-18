//
//  ResultSignal.swift
//  Ultramarine
//

public final class ResultSignal<Success, Failure: Error>: Transmit<Result<Success, Failure>> {
    
    public func fire(_ value: Success) {
        relay(.success(value))
    }
    
    public func fire(_ value: Failure) {
        relay(.failure(value))
    }
}
