//
//  RedefineOperator.swift
//  Ultramarine
//

infix operator <>: AssignmentPrecedence

extension ReadonlyBehavior {
    
    @discardableResult
    public static func <> (destination: ReadonlyBehavior<Value>, source: Behavior<Value>) -> ReadonlyBehavior<Value> {
        destination.watch(to: source)
        return destination
    }
}

extension ReadonlyBehavior where Value == String {
    
    @discardableResult
    public static func <> <Source: CustomStringConvertible>(destination: ReadonlyBehavior<Value>, source: Behavior<Source>) -> ReadonlyBehavior<Value> {
        destination.watch(to: InjectionBehavior(source: source) { $0.description })
        return destination
    }
}

extension MemoryBehavior {
    
    @discardableResult
    public static func <> (destination: MemoryBehavior<Value>, signal: Signal<Value>) -> MemoryBehavior<Value> {
        destination.watch(to: signal)
        return destination
    }
}

extension Signal {
    
    @discardableResult
    public static func <> (signal: Signal<Payload>, _ definition: (Self) -> Void) -> Signal<Payload> {
        return signal.apply(closure: definition)
    }
}
