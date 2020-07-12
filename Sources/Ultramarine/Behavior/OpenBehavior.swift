//
//  OpenBehavior.swift
//  Ultramarine
//

public final class OpenBehavior<Value>: Behavior<Value> {
    
    public override init(_ initialValue: Value) {
        super.init(initialValue)
    }
    
    public override var value: Value {
        get { return super.value }
        set { update(newValue) }
    }
}
