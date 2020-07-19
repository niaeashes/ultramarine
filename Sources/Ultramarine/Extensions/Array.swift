//
//  Array.swift
//  Ultramarine
//

extension Array where Element: Equatable {
    public func subject() -> Subject<Self> { Subject<Self>(self) }
}
