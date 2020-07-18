//
//  Optional.swift
//  Ultramarine
//

extension Subject {
    
    public func optional() -> Subject<Optional<Value>> {
        return Subject.transform(source: self) { $0 }
    }
}
