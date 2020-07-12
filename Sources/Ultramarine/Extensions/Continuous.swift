//
//  Continuous.swift
//  Ultramarine
//

public protocol Continuous {
    var continuous: OpenBehavior<Self> { get }
}

extension Int: Continuous {
    
    public var continuous: OpenBehavior<Int> {
        return OpenBehavior<Int>(self)
    }
}

extension Bool: Continuous {
    
    public var continuous: OpenBehavior<Bool> {
        return OpenBehavior<Bool>(self)
    }
}
