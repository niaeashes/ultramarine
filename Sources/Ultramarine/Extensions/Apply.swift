//
//  File.swift
//  

public extension Behavior {
    
    public func apply(closure: (Self) -> Void) -> Self {
        closure(self)
        return self
    }
}

public extension Event {
    
    public func apply(closure: (Self) -> Void) -> Self {
        closure(self)
        return self
    }
}
