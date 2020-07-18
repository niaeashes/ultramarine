//
//  Subject+Expression.swift
//  Ultramarine
//

// MARK: - Transform Definition.

infix operator +>: MultiplicationPrecedence

extension Subject {
    
    public static func transform<V, R>(source: Subject<V>, _ transform: @escaping (V) -> R) -> Subject<R> {
        source.transform(transform)
    }
    
    public func transform<R>(_ transform: @escaping (Value) -> R) -> Subject<R> {
        
        let currentValue = transform(value)
        let transformSubject = Subject<R>(currentValue)
        
        sign { [transformSubject, weak self] _ in
            guard let self = self else { return }
            transformSubject.value = transform(self.value)
        }
        
        return transformSubject
    }
}

// MARK: - Combine Definition.

infix operator <+>: MultiplicationPrecedence

extension Subject {
    
    public static func combine<A, B, R>(source a: Subject<A>, source b: Subject<B>, _ combine: @escaping (A, B) -> R) -> Subject<R> {
        
        let currentValue = combine(a.value, b.value)
        let combineSubject = Subject<R>(currentValue)
        
        a.sign { [combineSubject, weak a, weak b] _ in
            guard let a = a, let b = b else { return }
            combineSubject.value = combine(a.value, b.value)
        }
        
        b.sign { [combineSubject, weak a, weak b] _ in
            guard let a = a, let b = b else { return }
            combineSubject.value = combine(a.value, b.value)
        }
        
        return combineSubject
    }
}
