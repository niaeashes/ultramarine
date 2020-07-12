//
//  FormattedStringBehavior.swift
//  
//

public class FormattedStringBehavior: Behavior<String> {
    
    private let format: String
    private let collection: Dictionary<Int, Behavior<String>>
    
    public init(format: String) {
        self.format = format
        collection = ReplaceTokenStorage.current?.collection ?? [:]
        
        super.init("")
        
        collection.values.forEach {
            $0.onUpdate { [weak self] _, cancellable in
                if let self = self {
                    self.run()
                } else {
                    cancellable.cancel()
                }
            }
        }
        
        run()
    }
    
    private func run() {
        var newValue = format
        
        collection.forEach { key, string in
            newValue = newValue.replacingOccurrences(of: "<:-\(key)-:>", with: string.value)
        }
        
        update(newValue)
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
    
    public var string: Behavior<String> {
        InjectionBehavior<Value, String>(source: self) { return $0.description }
    }
    
    public var replaceToken: String {
        ReplaceTokenStorage.spawn()
        return ReplaceTokenStorage.current!.register(source: string)
    }
}

extension String {
    
    public var formated: FormattedStringBehavior {
        defer { ReplaceTokenStorage.current?.clear() }
        return FormattedStringBehavior(format: self)
    }
}
