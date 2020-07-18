//
//  CoreProtocol.swift
//  Ultramarine
//

public protocol Cancellable: AnyObject {
    
    var isCanceled: Bool { get }
    
    func cancel()
}

protocol CancellableOwner: AnyObject {
    
    func cancel(target: Cancellable)
}

extension Cancellable {
    
    public func append(to collection: inout Array<Cancellable>) {
        collection.append(self)
    }
}
