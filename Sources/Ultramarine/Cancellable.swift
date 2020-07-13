//
//  CoreProtocol.swift
//  Ultramarine
//

public protocol Cancellable {
    
    var isCanceled: Bool { get }
    
    func cancel()
}

extension Cancellable {
    
    public func append(to collection: inout Array<Cancellable>) {
        collection.append(self)
    }
}
