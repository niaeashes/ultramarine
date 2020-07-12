//
//  Bool.swift
//  Ultramarine
//

private let SOURCE_KEY = "source"
private let LHS_KEY = "left-hand source"
private let RHS_KEY = "right-hand source"

extension Behavior where Value == Bool {
    
    public static prefix func ! (target: Behavior<Value>) -> FunctionalBehavior<Value> {
        
        let result = FunctionalBehavior<Value>() { computingSpace in
            let source: Bool = try computingSpace.find(SOURCE_KEY)
            return !source
        }
        result.assign(SOURCE_KEY, member: target)
        
        return result
    }
    
    public static func || (lhs: Behavior<Value>, rhs: Behavior<Value>) -> FunctionalBehavior<Value> {
        
        let result = FunctionalBehavior<Value>() { computingSpace in
            let lhs: Bool = try computingSpace.find(LHS_KEY)
            let rhs: Bool = try computingSpace.find(RHS_KEY)
            return lhs || rhs
        }
        result.assign(LHS_KEY, member: lhs)
        result.assign(RHS_KEY, member: rhs)
        
        return result
    }
    
    public static func && (lhs: Behavior<Value>, rhs: Behavior<Value>) -> FunctionalBehavior<Value> {
        
        let result = FunctionalBehavior<Value>() { computingSpace in
            let lhs: Bool = try computingSpace.find(LHS_KEY)
            let rhs: Bool = try computingSpace.find(RHS_KEY)
            return lhs && rhs
        }
        result.assign(LHS_KEY, member: lhs)
        result.assign(RHS_KEY, member: rhs)
        
        return result
    }
}
