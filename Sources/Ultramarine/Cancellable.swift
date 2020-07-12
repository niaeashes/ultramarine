//
//  Cancellable.swift
//  Ultramarine
//

public protocol Cancellable {
    
    func cancel()
}

public final class NullCancellable: Cancellable {
    public func cancel() {}
}
