//
//  Equatable.swift
//  Ultramarine
//

extension Behavior where Value: Equatable {
    
    public static func == (lhs: Behavior<Value>, rhs: Behavior<Value>) -> Behavior<Bool> {
        return CombineBehavior(source: lhs, source: rhs) { $0 == $1 }
    }
}
