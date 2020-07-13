//
//  EventReceiver.swift
//

public protocol EventReceiver: AnyObject {
    
    associatedtype Payload
    
    func notify(_ value: Payload)
}

extension Event {
    
    @discardableResult
    func bind<R: EventReceiver>(to receiver: R) -> Cancellable where R.Payload == Payload {
        
        return subscribe(Subscription<Payload>() { [weak receiver] value, cancellable in
            if let receiver = receiver {
                receiver.notify(value)
            } else {
                cancellable.cancel()
            }
        })
    }
}
