//
//  CoreProtocol.swift
//  Ultramarine
//

public protocol Cancellable: AnyObject {
    
    var isCanceled: Bool { get }
    
    func cancel()
}

extension Cancellable {
    
    public func store(to collection: inout Array<Cancellable>) {
        collection.append(self)
    }
    
    public func store(to bag: CancellableBag) {
        bag.cancellables.append(self)
    }
}

protocol CancellableOwner: AnyObject {
    
    func cancel(target: Cancellable)
}

public final class CancellableBag {
    
    var cancellables: Array<Cancellable> = []
    
    public init() {}
    
    public func cancel() {
        cancellables.forEach { $0.cancel() }
        cancellables = []
    }
    
    deinit {
        cancel()
    }
}
