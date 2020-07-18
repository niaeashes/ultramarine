//
//  Subscription.swift
//  Ultramarine
//

class Subscription<Input> {
    
    private var handler: ((Input, Cancellable) -> Void)?
    private var inProcess = false
    
    init(_ handler: @escaping (Input, Cancellable) -> Void) {
        self.handler = handler
    }
    
    convenience init<Root: AnyObject>(to keyPath: ReferenceWritableKeyPath<Root, Input>, on object: Root) {
        self.init() { [weak object] value, cancellable in
            if let object = object {
                object[keyPath: keyPath] = value
            } else {
                cancellable.cancel()
            }
        }
    }
    
    convenience init<Root: AnyObject>(to keyPath: ReferenceWritableKeyPath<Root, Optional<Input>>, on object: Root) {
        self.init() { [weak object] value, cancellable in
            if let object = object {
                object[keyPath: keyPath] = Optional(value)
            } else {
                cancellable.cancel()
            }
        }
    }
    
    @discardableResult
    func execute(_ input: Input) -> Self {
        if inProcess { return self }
        
        defer { inProcess = false }
        inProcess = true
        
        handler?(input, self)
        
        return self
    }
}

extension Subscription: Cancellable {
    
    public func cancel() {
        handler = nil
    }
    
    public var isCanceled: Bool { handler == nil }
}

extension Subscription: CustomDebugStringConvertible {
    
    public var debugDescription: String {
        return "Subscription<\(Input.self)>"
    }
}
