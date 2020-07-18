//
//  String.swift
//  Ultramarine
//

import Foundation

prefix operator %

extension Subject where Value: CustomStringConvertible {
    
    public static prefix func % (source: Subject<Value>) -> String {
        source.replaceToken
    }
    
    public var string: Subject<String> {
        Subject.transform(source: self) { $0.description }
    }
}

private let TOKEN_PREFIX = "\u{1A}<"
private let TOKEN_POSTFIX = "\u{1A}>"

private extension Int {
    var replaceToken: String { "\(TOKEN_PREFIX)\(self)\(TOKEN_POSTFIX)"}
}

// MARK: - Formatted String.

class FormattedStringSubject: Subject<String> {
    
    private(set) var source: Array<Element> = []
    
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
    
    public init(format: String) {
        super.init("")
        
        prepare(format: format)
        update()
    }
    
    private func prepare(format: String) {
        defer { ReplaceTokenStorage.current?.clear() }
        let collection = ReplaceTokenStorage.current?.collection ?? [:]
        
        var newSource: Array<Element> = [.string(format)]
        
        collection.forEach { key, target in
            
            let oldSource = newSource.map { $0 }
            newSource = []
            oldSource.forEach { element in
                switch element {
                case .string(let format):
                    var parts = format.components(separatedBy: key.replaceToken)
                    while parts.count > 0 {
                        newSource.append(.string(parts.removeFirst()))
                        if parts.count > 0 {
                            newSource.append(.token(target))
                        }
                    }
                default:
                    newSource.append(element)
                }
            }
        }
        
        self.source = newSource
        
        collection.values.forEach { $0.sign { [weak self] _ in self?.update() } }
    }
    
    private func update() {
        value = source.map { $0.description }.joined()
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
        return FormattedStringSubject(format: self)
    }
}

// MARK: - CustomStringConvertible

extension Subject where Value: CustomStringConvertible {
    
    public var description: String { value.description }
    
    public var replaceToken: String {
        ReplaceTokenStorage.spawn()
        return ReplaceTokenStorage.current!.register(source: string)
    }
}
