//
//  InjectionBehavior.swift
//  Ultramarine
//

public final class InjectionBehavior<S, R>: Behavior<R> {
    
    private var source: Behavior<S>!
    private var handler: ((S) -> R)!
    
    private var cancellables: Array<Cancellable> = []
    
    public init(source: Behavior<S>, _ handler: @escaping (S) -> R) {
        self.source = source
        self.handler = handler
        
        super.init(handler(source.value))
        
        cancellables.append(source.sink { [weak self] _ in self?.run() })
    }
    
    private func run() {
        update(handler(source.value))
    }
}

extension InjectionBehavior: Cancellable {
    
    public func cancel() {
        cancellables.forEach { $0.cancel() }
        cancellables = []
        source = nil
        handler = nil
    }
    
    public var isCanceled: Bool { cancellables.count == 0 }
}
