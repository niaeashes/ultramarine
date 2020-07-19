//
//  Number.swift
//  Ultramarine
//

extension Subject where Value: AdditiveArithmetic {
    
    public static func += (source: Subject<Value>, value: Value) {
        source <<= source.value + value
    }
    
    public static func -= (source: Subject<Value>, value: Value) {
        source <<= source.value - value
    }
    
    public static func + (source: Subject<Value>, value: Value) -> Subject<Value> {
        return source.transform { $0 + value }
    }
    
    public static func - (source: Subject<Value>, value: Value) -> Subject<Value> {
        return source.transform { $0 - value }
    }
    
    public static func + (lhs: Subject<Value>, rhs: Subject<Value>) -> Subject<Value> {
        return Subject.combine(source: lhs, source: rhs) { $0 + $1 }
    }
    
    public static func - (lhs: Subject<Value>, rhs: Subject<Value>) -> Subject<Value> {
        return Subject.combine(source: lhs, source: rhs) { $0 - $1 }
    }
}

extension Subject where Value: Numeric {
    
    public static func *= (source: Subject<Value>, value: Value) {
        source <<= source.value * value
    }
    
    public static func * (source: Subject<Value>, value: Value) -> Subject<Value> {
        return source.transform { $0 * value }
    }
    
    public static func * (lhs: Subject<Value>, rhs: Subject<Value>) -> Subject<Value> {
        return Subject.combine(source: lhs, source: rhs) { $0 * $1 }
    }
}

extension Subject where Value: FloatingPoint {
    
    public static func /= (source: Subject<Value>, value: Value) {
        source <<= source.value / value
    }
    
    public static func / (source: Subject<Value>, value: Value) -> Subject<Value> {
        return Subject.transform(source: source) { $0 / value }
    }
    
    public static func / (lhs: Subject<Value>, rhs: Subject<Value>) -> Subject<Value> {
        return Subject.combine(source: lhs, source: rhs) { $0 / $1 }
    }
}
