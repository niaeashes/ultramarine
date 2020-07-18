//
//  CombineBehavior.swift
//  Ultramarine
//

public final class CombineBehavior<A, B, R>: Behavior<R> {
    
    private var sourceA: Behavior<A>
    private var sourceB: Behavior<B>
    private var handler: (A, B) -> R
    
    public init(source a: Behavior<A>, source b: Behavior<B>, _ handler: @escaping (A, B) -> R) {
        self.sourceA = a
        self.sourceB = b
        self.handler = handler
        
        super.init(handler(a.value, b.value))
        
        sourceA.chain { [weak self] in self?.run() }
        sourceB.chain { [weak self] in self?.run() }
    }
    
    private func run() {
        update(handler(sourceA.value, sourceB.value))
    }
}
