//
//  CoreProtocol.swift
//  Ultramarine
//

public protocol Publisher {
    
    associatedtype Output
    
    func connect<S: Subscriber>(to subscriber: S) -> Cancellable where S.Input == Output
}

public protocol Subscriber: AnyObject {
    
    associatedtype Input
    
    func notify(_ input: Input)
}

public protocol Cancellable {
    
    func cancel()
}
