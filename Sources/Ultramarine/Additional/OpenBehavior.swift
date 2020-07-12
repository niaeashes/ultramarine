//
//  OpenBehavior.swift
//  Ultramarine
//

public final class OpenBehavior<Value>: Behavior<Value>, Subscriber {
    
    public typealias Input = Value
    
    public override init(_ initialValue: Value) {
        super.init(initialValue)
    }
    
    public override func update(_ value: Value) {
        super.update(value)
    }
    
    public func receive(_ input: Input) {
        update(input)
    }
    
    public override var value: Value {
        get { return super.value }
        set { update(newValue) }
    }
}