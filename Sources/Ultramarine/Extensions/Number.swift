//
//  Number.swift
//  Ultramarine
//

private let SOURCE_KEY = "source"
private let LHS_KEY = "left-hand source"
private let RHS_KEY = "right-hand source"

extension Behavior where Value: AdditiveArithmetic {
    
    typealias RuntimeError = FunctionalBehavior<Value>.FunctionRuntimeError
    
    public static func += (source: Behavior<Value>, value: Value) {
        source.update(source.value + value)
    }
    
    public static func -= (source: Behavior<Value>, value: Value) {
        source.update(source.value - value)
    }
    
    public static func + (source: Behavior<Value>, value: Value) -> FunctionalBehavior<Value> {
        let result = FunctionalBehavior<Value>() { computingSpace in
            let source: Value = try computingSpace.find(SOURCE_KEY)
            return source + value
        }
        result.assign(SOURCE_KEY, member: source)
        return result
    }
    
    public static func - (source: Behavior<Value>, value: Value) -> FunctionalBehavior<Value> {
        let result = FunctionalBehavior<Value>() { computingSpace in
            let source: Value = try computingSpace.find(SOURCE_KEY)
            return source - value
        }
        result.assign(SOURCE_KEY, member: source)
        return result
    }
    
    public static func + (lhs: Behavior<Value>, rhs: Behavior<Value>) -> FunctionalBehavior<Value> {
        let result = FunctionalBehavior<Value>() { computingSpace in
            let lhs: Value = try computingSpace.find(LHS_KEY)
            let rhs: Value = try computingSpace.find(RHS_KEY)
            return lhs + rhs
        }
        result.assign(LHS_KEY, member: lhs)
        result.assign(RHS_KEY, member: rhs)
        return result
    }
    
    public static func - (lhs: Behavior<Value>, rhs: Behavior<Value>) -> FunctionalBehavior<Value> {
        let result = FunctionalBehavior<Value>() { computingSpace in
            let lhs: Value = try computingSpace.find(LHS_KEY)
            let rhs: Value = try computingSpace.find(RHS_KEY)
            return lhs - rhs
        }
        result.assign(LHS_KEY, member: lhs)
        result.assign(RHS_KEY, member: rhs)
        return result
    }
}

extension Behavior where Value: Numeric {
    
    public static func *= (source: Behavior<Value>, value: Value) {
        source.update(source.value * value)
    }
    
    public static func * (source: Behavior<Value>, value: Value) -> FunctionalBehavior<Value> {
        let result = FunctionalBehavior<Value>() { computingSpace in
            let source: Value = try computingSpace.find(SOURCE_KEY)
            return source * value
        }
        result.assign(SOURCE_KEY, member: source)
        return result
    }
    
    public static func * (lhs: Behavior<Value>, rhs: Behavior<Value>) -> FunctionalBehavior<Value> {
        let result = FunctionalBehavior<Value>() { computingSpace in
            let lhs: Value = try computingSpace.find(LHS_KEY)
            let rhs: Value = try computingSpace.find(RHS_KEY)
            return lhs * rhs
        }
        result.assign(LHS_KEY, member: lhs)
        result.assign(RHS_KEY, member: rhs)
        return result
    }
}

extension Behavior where Value: FloatingPoint {
    
    public static func /= (source: Behavior<Value>, value: Value) {
        source.update(source.value / value)
    }
    
    public static func / (source: Behavior<Value>, value: Value) -> FunctionalBehavior<Value> {
        let result = FunctionalBehavior<Value>() { computingSpace in
            let source: Value = try computingSpace.find(SOURCE_KEY)
            return source / value
        }
        result.assign(SOURCE_KEY, member: source)
        return result
    }
    
    public static func / (lhs: Behavior<Value>, rhs: Behavior<Value>) -> FunctionalBehavior<Value> {
        let result = FunctionalBehavior<Value>() { computingSpace in
            let lhs: Value = try computingSpace.find(LHS_KEY)
            let rhs: Value = try computingSpace.find(RHS_KEY)
            return lhs / rhs
        }
        result.assign(LHS_KEY, member: lhs)
        result.assign(RHS_KEY, member: rhs)
        return result
    }
}
