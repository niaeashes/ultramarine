//
//  Subscription.swift
//  Ultramarine
//

class Subscription<Input> {
    
    private var handler: ((Input, Cancellable) -> Void)?
    private var inProcess = false
    private var debugNote: String = ""
    
    init(_ handler: @escaping (Input, Cancellable) -> Void) {
        self.handler = handler
        debugNote = "simple handler"
    }
    
    convenience init<Root: AnyObject>(to keyPath: ReferenceWritableKeyPath<Root, Input>, on object: Root) {
        self.init() { [weak object] value, cancellable in
            if let object = object {
                object[keyPath: keyPath] = value
            } else {
                cancellable.cancel()
            }
        }
        debugNote = "Assign to \(object)"
    }
    
    convenience init<Root: AnyObject>(to keyPath: ReferenceWritableKeyPath<Root, Optional<Input>>, on object: Root) {
        self.init() { [weak object] value, cancellable in
            if let object = object {
                object[keyPath: keyPath] = Optional(value)
            } else {
                cancellable.cancel()
            }
        }
        debugNote = "Assign to \(object)"
    }
    
    func send(_ input: Input) {
        if inProcess { return }
        
        defer { inProcess = false }
        inProcess = true
        
        handler?(input, self)
    }
}

extension Subscription: Cancellable {
    
    public func cancel() {
        handler = nil
        debugNote = "canceled"
    }
    
    public var isCanceled: Bool { handler == nil }
}

extension Subscription: CustomDebugStringConvertible {
    
    public var debugDescription: String {
        return "Subscription<\(Input.self)>, \(debugNote)"
    }
}
