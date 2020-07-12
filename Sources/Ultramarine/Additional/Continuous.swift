//
//  Continuous.swift
//  Ultramarine
//

public protocol Continuous {
    var continuous: Behavior<Self> { get }
}

extension String: Continuous {
    
    public var continuous: Behavior<String> {
        return Behavior<String>(self)
    }
}

extension Int: Continuous {
    
    public var continuous: Behavior<Int> {
        return Behavior<Int>(self)
    }
}

extension Bool: Continuous {
    
    public var continuous: Behavior<Bool> {
        return Behavior<Bool>(self)
    }
}
