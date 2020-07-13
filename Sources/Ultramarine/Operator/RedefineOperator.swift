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

extension Event {
    
    @discardableResult
    public static func <> (event:  Event<Payload>, _ definition: (Self) -> Void) -> Event<Payload> {
        return event.apply(closure: definition)
    }
}
