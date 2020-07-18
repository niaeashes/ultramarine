//
//  Signal.swift
//  Ultramarine
//

public class Signal<Value>: Transmit<Value> {
    
    public override init() {}
    
    public func fire(_ value: Value) {
        relay(value)
    }
}

extension Signal where Value == Void {
    
    public func fire() {
        relay(Void())
    }
}
