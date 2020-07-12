//
//  Subscription.swift
//  Ultramarine
//

class Subscription<Input>: Cancellable {
    
    var handler: ((Input, Cancellable) -> Void)?
    
    init(_ handler: @escaping (Input, Cancellable) -> Void) {
        self.handler = handler
    }
    
    init<Root: AnyObject>(to keyPath: ReferenceWritableKeyPath<Root, Input>, on object: Root) {
        self.handler = { [weak object] value, cancellable in
            if let object = object {
                object[keyPath: keyPath] = value
            } else {
                cancellable.cancel()
            }
        }
    }
    
    init<Root: AnyObject>(to keyPath: ReferenceWritableKeyPath<Root, Optional<Input>>, on object: Root) {
        self.handler = { [weak object] value, cancellable in
            if let object = object {
                object[keyPath: keyPath] = Optional(value)
            } else {
                cancellable.cancel()
            }
        }
    }
    
    func send(_ input: Input) {
        handler?(input, self)
    }
    
    public func cancel() {
        handler = nil
    }
}
