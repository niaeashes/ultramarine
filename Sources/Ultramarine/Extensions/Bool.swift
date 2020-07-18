//
//  Bool.swift
//  Ultramarine
//

private let SOURCE_KEY = "source"
private let LHS_KEY = "left-hand source"
private let RHS_KEY = "right-hand source"

extension Subject where Value == Bool {
    
    public func toggle() {
        value = !value
    }
    
    public static prefix func ! (target: Subject<Value>) -> Subject<Value> {
        return Subject.transform(source: target) { !$0 }
    }
    
    public static func || (lhs: Subject<Value>, rhs: Subject<Value>) -> Subject<Value> {
        return Subject.combine(source: lhs, source: rhs) { return $0 || $1 }
    }
    
    public static func && (lhs: Subject<Value>, rhs: Subject<Value>) -> Subject<Value> {
        return Subject.combine(source: lhs, source: rhs) { return $0 && $1 }
    }
}
