//
//  PubSubProperty.swift
//  Ultramarine
//

@propertyWrapper
public struct Pub<Value> {
    
    public init(wrappedValue value: Value) {
        projectedValue = OpenBehavior<Value>(value)
    }
    
    public var projectedValue: OpenBehavior<Value>
    
    public var wrappedValue: Value {
        get { return projectedValue.value }
        set { projectedValue.update(newValue) }
    }
}

@propertyWrapper
public struct Sub<Value> {
    
    public init(wrappedValue value: Value) {
        projectedValue = ClosedBehavior<Value>(value)
    }
    
    public var projectedValue: ClosedBehavior<Value>
    
    public var wrappedValue: Value {
        get { return projectedValue.value }
    }
}
