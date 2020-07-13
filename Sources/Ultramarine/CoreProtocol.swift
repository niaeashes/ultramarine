//
//  CoreProtocol.swift
//  Ultramarine
//

public protocol Subscriber: AnyObject {
    
    associatedtype Input
    
    func notify(_ input: Input)
}

public protocol Cancellable {
    
    var isCanceled: Bool { get }
    
    func cancel()
}
