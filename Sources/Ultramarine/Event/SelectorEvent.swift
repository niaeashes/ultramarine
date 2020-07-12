//
//  SelectorEvent.swift
//  Ultramarine
//

#if !os(macOS)

import Foundation

public final class SelectorEvent<Sender, Value>: NSObject, Cancellable {
    
    public typealias WrappedEvent = Event<Value, Never>
    
    public var selector: Selector { return #selector(SelectorEvent.spawn(_:)) }
    
    private var subscription: Subscription<Sender>?
    let event = WrappedEvent()
    
    public init(_ handler: @escaping (Sender) -> Value?) {
        
        let event = self.event
        
        subscription = Subscription<Sender>() { object, _ in
            switch handler(object) {
            case .some(let value):
                event.post(value)
            default:
                break
            }
        }
    }
    
    @objc private func spawn(_ sender: Any) {
        if let sender = sender as? Sender {
            subscription?.send(sender)
        } else {
            assertionFailure()
        }
    }
    
    public func cancel() {
        subscription?.cancel()
        subscription = nil
    }
}

@propertyWrapper
public struct Selectable<Sender, Value> {
    
    public init(wrappedValue event: SelectorEvent<Sender, Value>) {
        self.wrappedValue = event
    }
    
    public var projectedValue: Event<Value, Never> { return wrappedValue.event }
    public var wrappedValue: SelectorEvent<Sender, Value>
}

#endif
