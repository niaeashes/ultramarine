//
//  String.swift
//  Ultramarine
//

extension String: Continuous {}

prefix operator %

extension Behavior where Value: CustomStringConvertible {
    
    public static prefix func % (source: Behavior<Value>) -> String {
        source.replaceToken
    }
    
    public var string: Behavior<String> {
        InjectionBehavior<Value, String>(source: self) { return $0.description }
    }
}
