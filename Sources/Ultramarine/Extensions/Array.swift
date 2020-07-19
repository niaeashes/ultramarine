//
//  Array.swift
//  Ultramarine
//

extension Array {
    public func subject() -> Subject<Self> { Subject<Self>(self) }
}
