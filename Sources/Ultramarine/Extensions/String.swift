//
//  String.swift
//  Ultramarine
//

// MARK - Behavior.

extension Behavior where Output: Continuous {
    
    @discardableResult
    public func assign<Root: AnyObject>(to keyPath: ReferenceWritableKeyPath<Root, Output>, on object: Root) -> Cancellable {
        
        let sub = Subscription(to: keyPath, on: object)
        subscribe(sub)
        sub.send(value)
        
        return sub
    }
    
    @discardableResult
    public func assign<Root: AnyObject>(to keyPath: ReferenceWritableKeyPath<Root, Optional<Output>>, on object: Root) -> Cancellable {
        
        let sub = Subscription(to: keyPath, on: object)
        subscribe(sub)
        sub.send(value)
        
        return sub
    }
}

extension Subscription where Input: CustomStringConvertible {
    
    convenience init(output: Subscription<String>) {
        
        self.init() { value, _ in
            output.send(value.description)
        }
    }
}
