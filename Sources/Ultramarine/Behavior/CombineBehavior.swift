//
//  CombineBehavior.swift
//  Ultramarine
//

public final class CombineBehavior<A, B, R>: Behavior<R> {
    
    private var sourceA: Behavior<A>
    private var sourceB: Behavior<B>
    private var handler: (A, B) -> R
    
    private var cancellables: Array<Cancellable> = []
    
    public init(source a: Behavior<A>, source b: Behavior<B>, _ handler: @escaping (A, B) -> R) {
        self.sourceA = a
        self.sourceB = b
        self.handler = handler
        
        super.init(handler(a.value, b.value))
        
        cancellables.append(sourceA.sink { [weak self] _ in self?.run() })
        cancellables.append(sourceB.sink { [weak self] _ in self?.run() })
    }
    
    private func run() {
        update(handler(sourceA.value, sourceB.value))
    }
}

extension CombineBehavior: Cancellable {
    
    public func cancel() {
        cancellables.forEach { $0.cancel() }
        cancellables = []
    }
    
    public var isCanceled: Bool { cancellables.count == 0 }
}
