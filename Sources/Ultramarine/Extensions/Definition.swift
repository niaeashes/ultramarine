//
//  File.swift
//  
//

extension Bool {
    public func subject() -> WritableSubject<Self> { WritableSubject<Self>(self) }
    public static func signal() -> Signal<Self> { Signal<Self>() }
}

extension FixedWidthInteger {
    public func subject() -> WritableSubject<Self> { WritableSubject<Self>(self) }
    public static func signal() -> Signal<Self> { Signal<Self>() }
}

extension FloatingPoint {
    public func subject() -> WritableSubject<Self> { WritableSubject<Self>(self) }
    public static func signal() -> Signal<Self> { Signal<Self>() }
}

extension String {
    public func subject() -> WritableSubject<Self> { WritableSubject<Self>(self) }
    public static func signal() -> Signal<Self> { Signal<Self>() }
}
