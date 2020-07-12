//
//  String.swift
//  Ultramarine
//

extension String: Continuous {
    
    public var continuous: OpenBehavior<String> {
        return OpenBehavior<String>(self)
    }
}

prefix operator %

extension Behavior where Value: CustomStringConvertible {
    
    public static prefix func % (source: Behavior<Value>) -> String {
        return source.replaceToken
    }
}
