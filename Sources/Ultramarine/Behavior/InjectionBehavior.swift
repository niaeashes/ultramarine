//
//  InjectionBehavior.swift
//  Ultramarine
//

public final class InjectionBehavior<S, R>: Behavior<R> {
    
    private var source: Behavior<S>
    private var handler: ((S) -> R)
    
    public init(source: Behavior<S>, _ handler: @escaping (S) -> R) {
        self.source = source
        self.handler = handler
        
        super.init(handler(source.value))
        
        source.chain { [weak self] in self?.run() }
    }
    
    private func run() {
        update(handler(source.value))
    }
}
