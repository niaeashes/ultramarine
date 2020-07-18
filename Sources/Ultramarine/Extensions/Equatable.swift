//
//  Equatable.swift
//  Ultramarine
//

extension Subject where Value: Equatable {
    
    public static func == (lhs: Subject<Value>, rhs: Subject<Value>) -> Subject<Bool> {
        return Subject.combine(source: lhs, source: rhs) { $0 == $1 }
    }
}
