//
//  Utils.swift
//  Ultramarine
//

func isEquals<Value>(_ lhs: Value, _ rhs: Value) -> Bool {
    return false
}

func isEquals<Value>(_ lhs: Value, _ rhs: Value) -> Bool where Value: Equatable {
    return lhs == rhs
}
