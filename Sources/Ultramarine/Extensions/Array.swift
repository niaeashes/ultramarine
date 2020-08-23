//
//  Array.swift
//  Ultramarine
//

extension Array {
    public func subject() -> Subject { Subject(self) }
    public typealias Subject = Ultramarine.Subject<Self>
}
