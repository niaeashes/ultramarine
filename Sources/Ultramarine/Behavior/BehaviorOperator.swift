//
//  BehaviorOperators.swift
//  Ultramarine
//

infix operator <>: AssignmentPrecedence

extension ClosedBehavior {
    
    public static func <> (destination: ClosedBehavior<Value>, source: Behavior<Value>) {
        destination.watch(to: source)
    }
}

infix operator <<=: AssignmentPrecedence

extension OpenBehavior {
    
    public static func <<= (open: OpenBehavior, value: Value) {
        open.set(value)
    }
}
