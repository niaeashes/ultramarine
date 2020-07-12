//
//  Bool.swift
//  Ultramarine
//

private let SOURCE_KEY = "source"
private let LHS_KEY = "left-hand source"
private let RHS_KEY = "right-hand source"

extension Behavior where Value == Bool {
    
    public static prefix func ! (target: Behavior<Value>) -> Behavior<Value> {
        
        return InjectionBehavior(source: target) { return !$0 }
    }
    
    public static func || (lhs: Behavior<Value>, rhs: Behavior<Value>) -> Behavior<Value> {
        
        return CombineBehavior(source: lhs, source: rhs) { return $0 || $1 }
    }
    
    public static func && (lhs: Behavior<Value>, rhs: Behavior<Value>) -> Behavior<Value> {
        
        return CombineBehavior(source: lhs, source: rhs) { return $0 && $1 }
    }
}
