//
//  File.swift
//  

extension Behavior {
    
    public func apply(closure: (Self) -> Void) -> Self {
        closure(self)
        return self
    }
}

extension Event {
    
    public func apply(closure: (Self) -> Void) -> Self {
        closure(self)
        return self
    }
}
