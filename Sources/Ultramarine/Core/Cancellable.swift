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
    
    public func append(to bag: CancellableBag) {
        bag.cancellables.append(self)
    }
}

public final class CancellableBag: Cancellable {
    
    var cancellables: Array<Cancellable> = []
    
    public init() {}
    
    public func cancel() {
        cancellables.forEach { $0.cancel() }
        cancellables = []
    }
    
    public var isCanceled: Bool { cancellables.count == 0 }
}
