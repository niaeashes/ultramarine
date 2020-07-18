//
//  FormattedStringBehavior.swift
//  Ultramarine
//

import Foundation

private let TOKEN_PREFIX = "<--"
private let TOKEN_POSTFIX = "-->"

private extension Int {
    var replaceToken: String { "\(TOKEN_PREFIX)\(self)\(TOKEN_POSTFIX)"}
}

public class FormattedStringBehavior: Behavior<String> {
    
    private(set) var source: Array<Element> = []
    
    enum Element: CustomStringConvertible {
        case string(String)
        case token(Behavior<String>)
        
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
        run()
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
        
        collection.values.forEach { $0.chain { [weak self] in self?.run() } }
    }
    
    private func run() {
        update(source.map { $0.description }.joined())
    }
}

private class ReplaceTokenStorage {
    
    var collection: Dictionary<Int, Behavior<String>> = [:]
    
    static var current: ReplaceTokenStorage? = nil
    
    static func spawn() {
        ReplaceTokenStorage.current = ReplaceTokenStorage.current ?? ReplaceTokenStorage()
    }
    
    func register(source: Behavior<String>) -> String {
        var key = 0
        while collection[key] != nil { key = Int.random(in: Int.min...Int.max) }
        
        collection[key] = source
        
        return key.replaceToken
    }
    
    func clear() {
        ReplaceTokenStorage.current = nil
    }
}

extension Behavior where Value: CustomStringConvertible {
    
    public var replaceToken: String {
        ReplaceTokenStorage.spawn()
        return ReplaceTokenStorage.current!.register(source: string)
    }
}

extension String {
    
    public var format: FormattedStringBehavior {
        defer { ReplaceTokenStorage.current?.clear() }
        return FormattedStringBehavior(format: self)
    }
}
