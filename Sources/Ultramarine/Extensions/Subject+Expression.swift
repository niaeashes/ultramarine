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
        
        let sub = sign { [weak transformSubject] in
            guard let transformSubject = transformSubject else { return $1.cancel() }
            transformSubject.value = transform($0)
        }
        
        transformSubject.bind(source: sub)
        
        return transformSubject
    }
}

// MARK: - Combine Definition.

infix operator <+>: MultiplicationPrecedence

extension Subject {
    
    public static func combine<A, B, R>(source a: Subject<A>, source b: Subject<B>, _ combine: @escaping (A, B) -> R) -> Subject<R> {
        
        let currentValue = combine(a.value, b.value)
        let combineSubject = Subject<R>(currentValue)
        
        let subA = a.sign { [weak combineSubject, a, b] _, cancellable in
            guard let combineSubject = combineSubject else { return cancellable.cancel() }
            combineSubject.value = combine(a.value, b.value)
        }
        
        let subB = b.sign { [weak combineSubject, a, b] _, cancellable in
            guard let combineSubject = combineSubject else { return cancellable.cancel() }
            combineSubject.value = combine(a.value, b.value)
        }
        
        combineSubject.bind(source: subA)
        combineSubject.bind(source: subB)
        
        return combineSubject
    }
}
