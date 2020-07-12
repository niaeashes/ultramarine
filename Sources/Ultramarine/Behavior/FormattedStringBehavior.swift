//
//  FormattedStringBehavior.swift
//  
//

public class FormattedStringBehavior: Behavior<String> {
    
    private let source: Array<Element>
    
    private enum Element: CustomStringConvertible {
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
        let collection = ReplaceTokenStorage.current?.collection ?? [:]
        
        var source: Array<Element> = [.string(format)]
        
        collection.forEach { key, target in
            
            let oldSource = source.map { $0 }
            source = []
            oldSource.forEach { element in
                switch element {
                case .string(let format):
                    var parts = format.components(separatedBy: "<:-\(key)-:>")
                    while parts.count > 0 {
                        source.append(.string(parts.removeFirst()))
                        if parts.count > 0 {
                            source.append(.token(target))
                        }
                    }
                default:
                    source.append(element)
                }
            }
        }
        
        self.source = source
        
        super.init(source.map { $0.description }.joined())
        
        collection.values.forEach {
            $0.onUpdate { [weak self] _, cancellable in
                if let self = self {
                    self.run()
                } else {
                    cancellable.cancel()
                }
            }
        }
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
        
        return "<:-\(key)-:>"
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
