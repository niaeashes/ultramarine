//
//  OpenBehavior.swift
//  Ultramarine
//

public protocol Continuous {
    var continuous: OpenBehavior<Self> { get }
}

extension Continuous {
    
    public var continuous: OpenBehavior<Self> {
        return OpenBehavior<Self>(self)
    }
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
