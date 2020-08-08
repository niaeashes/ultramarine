//
//  File.swift
//  

extension Subject {
    
    public func apply(closure: (Subject<Value>) -> Void) -> Subject<Value> {
        closure(self)
        return self
    }
    
    public static func define<Value>(_ initialValue: Value, closure: @escaping (Subject<Value>) -> Void) -> Subject<Value> {
        Subject<Value>(initialValue).apply(closure: closure)
    }
}

extension Signal {
    
    public func apply(closure: (Signal<Value>) -> Void) -> Signal<Value> {
        closure(self)
        return self
    }
    
    public static func define<Value>(closure: @escaping (Signal<Value>) -> Void) -> Signal<Value> {
        Signal<Value>().apply(closure: closure)
    }
}
