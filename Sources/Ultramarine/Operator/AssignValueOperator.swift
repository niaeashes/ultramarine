//
//  AssignValueOperator.swift
//  Ultramarine
//

infix operator <<=: AssignmentPrecedence

extension OpenBehavior {
    
    public static func <<= (open: OpenBehavior, value: Value) {
        open.value = value
    }
}
