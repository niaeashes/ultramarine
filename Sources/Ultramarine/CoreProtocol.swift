//
//  CoreProtocol.swift
//  Ultramarine
//

public protocol Cancellable {
    
    var isCanceled: Bool { get }
    
    func cancel()
}
