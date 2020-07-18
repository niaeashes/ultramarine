//
//  Subject+Expression.swift
//  Ultramarine
//

// MARK: - Transform Definition.

extension Subject {
    
    public static func transform<V, R>(source: Subject<V>, _ transform: @escaping (V) -> R) -> Subject<R> {
        
        let currentValue = transform(source.value)
        let transformSubject = Subject<R>(currentValue)
        
        source.sign { [transformSubject, weak source] _ in
            guard let source = source else { return }
            transformSubject.value = transform(source.value)
        }
        
        return transformSubject
    }
}

// MARK: - Combine Definition.

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
