//
//  Bool.swift
//  Ultramarine
//

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
