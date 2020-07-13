//
//  OpenBehavior.swift
//  Ultramarine
//

public protocol Continuous {
    var continuous: OpenBehavior<Self> { get }
}

public final class OpenBehavior<Value>: Behavior<Value> {
    
    public override init(_ initialValue: Value) {
        super.init(initialValue)
    }
    
    public override var value: Value {
        get { return super.value }
        set { update(newValue) }
    }
}
