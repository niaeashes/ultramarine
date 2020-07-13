//
//  File.swift
//  

public extension Behavior {
    
    func apply(closure: (Self) -> Void) -> Self {
        closure(self)
        return self
    }
}

public extension Event {
    
    func apply(closure: (Self) -> Void) -> Self {
        closure(self)
        return self
    }
}
