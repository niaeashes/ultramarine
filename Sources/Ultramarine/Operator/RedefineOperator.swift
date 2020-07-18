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
    public static func <> (destination: MemoryBehavior<Value>, signal: SignalStream<Value>) -> MemoryBehavior<Value> {
        destination.watch(to: signal)
        return destination
    }
}

extension SignalStream {
    
    @discardableResult
    public static func <> (signal: SignalStream<Payload>, _ definition: (Self) -> Void) -> SignalStream<Payload> {
        return signal.apply(closure: definition)
    }
}
