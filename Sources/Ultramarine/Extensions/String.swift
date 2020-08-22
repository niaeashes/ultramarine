//
//  String.swift
//  Ultramarine
//

import Foundation

private let TOKEN_PREFIX = "\u{1A}<"
private let TOKEN_POSTFIX = "\u{1A}>"

private extension Int {
    var replaceToken: String { "\(TOKEN_PREFIX)\(self)\(TOKEN_POSTFIX)"}
}

// MARK: - Formatted String.

final class FormattedStringTransmit: Transmit<Void> {
    
    private(set) var tokens: Array<Element> = []
    
    enum Element: CustomStringConvertible {
        case string(String)
        case token(Subject<String>)
        
        var description: String {
            switch self {
            case .string(let value):
                return value
            case .token(let string):
                return string.value
            }
        }
    }
    
    func prepare(format: String) -> Subject<String> {
        
        defer {
            ReplaceTokenStorage.current?.clear()
            relay(())
        }
        
        let collection = ReplaceTokenStorage.current?.collection ?? [:]
        let destination = "".subject()
        
        var newTokens: Array<Element> = [.string(format)]
        
        collection.forEach { key, target in
            
            let oldTokens = newTokens.map { $0 }
            let replaceToken = key.replaceToken
            newTokens = []
            oldTokens.forEach { element in
                switch element {
                case .string(let format):
                    var parts = format.components(separatedBy: replaceToken)
                    while !parts.isEmpty {
                        newTokens.append(.string(parts.removeFirst()))
                        if !parts.isEmpty { newTokens.append(.token(target)) }
                    }
                default:
                    newTokens.append(element)
                }
            }
            
            let sub = target.sign { [weak self] _, cancellable in
                guard let self = self else { return cancellable.cancel() }
                self.relay(())
            }
            
            self.bind(source: sub)
            sub.debugObject = self
        }
        
        self.tokens = newTokens
        
        let sub = sign { [weak self, weak destination] _, cancellable in
            guard let destination = destination, let tokens = self?.tokens else { return cancellable.cancel() }
            destination <<= tokens.map { $0.description }.joined()
        }
        
        destination.bind(source: sub)
        sub.debugObject = destination
        
        return destination
    }
}

private class ReplaceTokenStorage {
    
    var collection: Dictionary<Int, Subject<String>> = [:]
    
    static var current: ReplaceTokenStorage? = nil
    
    static func spawn() {
        ReplaceTokenStorage.current = ReplaceTokenStorage.current ?? ReplaceTokenStorage()
    }
    
    func register(source: Subject<String>) -> String {
        var key = 0
        while collection[key] != nil { key = Int.random(in: Int.min...Int.max) }
        
        collection[key] = source
        
        return key.replaceToken
    }
    
    func clear() {
        ReplaceTokenStorage.current = nil
    }
}

extension String {
    
    public func format() -> Subject<String> {
        defer { ReplaceTokenStorage.current?.clear() }
        return FormattedStringTransmit().prepare(format: self)
    }
}

// MARK: - CustomStringConvertible

prefix operator %

extension Subject: CustomStringConvertible where Value: CustomStringConvertible {
    
    public static prefix func % (source: Subject<Value>) -> String {
        source.replaceToken
    }
    
    public func string() -> Subject<String> {
        Subject.transform(source: self) { $0.description }
    }
    
    public var description: String { value.description }
    
    public var replaceToken: String {
        ReplaceTokenStorage.spawn()
        return ReplaceTokenStorage.current!.register(source: string())
    }
}
