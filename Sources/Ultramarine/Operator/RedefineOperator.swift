//
//  RedefineOperator.swift
//  Ultramarine
//

infix operator <>: AssignmentPrecedence

extension ClosedBehavior {
    
    @discardableResult
    public static func <> (destination: ClosedBehavior<Value>, source: Behavior<Value>) -> ClosedBehavior<Value> {
        destination.watch(to: source)
        return destination
    }
}

extension ClosedBehavior where Value == String {
    
    @discardableResult
    public static func <> <Source: CustomStringConvertible>(destination: ClosedBehavior<Value>, source: Behavior<Source>) -> ClosedBehavior<Value> {
        destination.watch(to: InjectionBehavior(source: source) { $0.description })
        return destination
    }
}

extension FormattedStringBehavior {
    
    @discardableResult
    public static func <> (destination: FormattedStringBehavior, newFormat: String) -> FormattedStringBehavior {
        destination.replace(format: newFormat)
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
    public static func <> (signal:  Signal<Payload>, _ definition: (Self) -> Void) -> Signal<Payload> {
        return signal.apply(closure: definition)
    }
}
