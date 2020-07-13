//
//  Number.swift
//  Ultramarine
//

private let SOURCE_KEY = "source"
private let LHS_KEY = "left-hand source"
private let RHS_KEY = "right-hand source"

extension UInt: Continuous {}
extension UInt8: Continuous {}
extension UInt16: Continuous {}
extension UInt32: Continuous {}
extension UInt64: Continuous {}

extension Int: Continuous {}
extension Int8: Continuous {}
extension Int16: Continuous {}
extension Int32: Continuous {}
extension Int64: Continuous {}

extension Float32: Continuous {}
extension Float64: Continuous {}
extension Float80: Continuous {}

extension Behavior where Value: AdditiveArithmetic {
    
    public static func += (source: Behavior<Value>, value: Value) {
        source.update(source.value + value)
    }
    
    public static func -= (source: Behavior<Value>, value: Value) {
        source.update(source.value - value)
    }
    
    public static func + (source: Behavior<Value>, value: Value) -> Behavior<Value> {
        return InjectionBehavior(source: source) { return $0 + value }
    }
    
    public static func - (source: Behavior<Value>, value: Value) -> Behavior<Value> {
        return InjectionBehavior(source: source) { return $0 - value }
    }
    
    public static func + (lhs: Behavior<Value>, rhs: Behavior<Value>) -> Behavior<Value> {
        return CombineBehavior(source: lhs, source: rhs) { return $0 + $1 }
    }
    
    public static func - (lhs: Behavior<Value>, rhs: Behavior<Value>) -> Behavior<Value> {
        return CombineBehavior(source: lhs, source: rhs) { return $0 - $1 }
    }
}

extension Behavior where Value: Numeric {
    
    public static func *= (source: Behavior<Value>, value: Value) {
        source.update(source.value * value)
    }
    
    public static func * (source: Behavior<Value>, value: Value) -> Behavior<Value> {
        return InjectionBehavior(source: source) { return $0 * value }
    }
    
    public static func * (lhs: Behavior<Value>, rhs: Behavior<Value>) -> Behavior<Value> {
        return CombineBehavior(source: lhs, source: rhs) { return $0 * $1 }
    }
}

extension Behavior where Value: FloatingPoint {
    
    public static func /= (source: Behavior<Value>, value: Value) {
        source.update(source.value / value)
    }
    
    public static func / (source: Behavior<Value>, value: Value) -> Behavior<Value> {
        return InjectionBehavior(source: source) { return $0 / value }
    }
    
    public static func / (lhs: Behavior<Value>, rhs: Behavior<Value>) -> Behavior<Value> {
        return CombineBehavior(source: lhs, source: rhs) { return $0 / $1 }
    }
}
