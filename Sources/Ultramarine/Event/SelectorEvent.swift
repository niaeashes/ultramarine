//
//  SelectorEvent.swift
//  Ultramarine
//

#if !os(macOS)

import Foundation

public final class SelectorEvent<Sender>: NSObject {
    
    public typealias WrappedEvent = Event<Sender>
    
    public var selector: Selector { return #selector(SelectorEvent.spawn(_:)) }
    
    private var subscription: Subscription<Sender>?
    let event = WrappedEvent()
    
    public override init() {
        
        let event = self.event
        
        subscription = Subscription<Sender>() { object, _ in
            event.trigger(object)
        }
        
        super.init()
    }
    
    @objc private func spawn(_ sender: Any) {
        if let sender = sender as? Sender {
            subscription?.send(sender)
        } else {
            assertionFailure()
        }
    }
}

extension SelectorEvent: Cancellable {
    
    public func cancel() {
        subscription?.cancel()
        subscription = nil
    }
    
    public var isCanceled: Bool { subscription == nil }
}

@propertyWrapper
public struct Selectable<Sender> {
    
    public init() {}
    
    public var wrappedValue: Event<Sender> { return projectedValue.event }
    public let projectedValue = SelectorEvent<Sender>()
}

#endif
