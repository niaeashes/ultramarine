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

extension Subscriber {
    
    public static func <<= (subscriber: Self, value: Input) {
        subscriber.receive(value)
    }
}

infix operator <+: AssignmentPrecedence
infix operator <!: AssignmentPrecedence
infix operator >>: AssignmentPrecedence

extension Event {
    
    public static func <+ (event: Event<Value, Failure>, value: Value) {
        event.post(value)
    }
    
    public static func <! (event: Event<Value, Failure>, error: Failure) {
        event.raise(error)
    }
}
