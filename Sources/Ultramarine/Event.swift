//
//  Event.swift
//  Ultramarine
//

public final class Event<Value, Failure: Error> {
    
    let name: String?
    private var subscriptions = [Subscription<EventPayload>]()
    
    public typealias EventPayload = Result<Value, Failure>
    
    public init(name: String? = nil) {
        self.name = name ?? "Unnamed Event"
    }
    
    func post(_ value: Value) {
        let subscriptions = self.subscriptions
        subscriptions.forEach { $0.send(.success(value)) }
    }
    
    func raise(_ error: Failure) {
        let subscriptions = self.subscriptions
        subscriptions.forEach { $0.send(.failure(error)) }
    }
}

extension Event: Publisher {
    
    public typealias Output = EventPayload
    
    @discardableResult
    public func connect<S>(to subscriber: S) -> Cancellable where S : Subscriber, Output == S.Input {
        
        let sub = Subscription<EventPayload>() { [weak subscriber] payload, cancellable in
            if let subscriber = subscriber {
                subscriber.notify(payload)
            } else {
                cancellable.cancel()
            }
        }
        subscriptions.append(sub)
        
        return sub
    }
    
    @discardableResult
    public func connect<S>(postTo subscriber: S) -> Cancellable where S : Subscriber, Value == S.Input {
        
        let sub = Subscription<EventPayload>() { [weak subscriber] payload, cancellable in
            if let subscriber = subscriber {
                switch payload {
                case .success(let value):
                    subscriber.notify(value)
                default:
                    break
                }
            } else {
                cancellable.cancel()
            }
        }
        subscriptions.append(sub)
        
        return sub
    }
    
    @discardableResult
    public func connect<S>(raiseTo subscriber: S) -> Cancellable where S : Subscriber, Failure == S.Input {
        
        let sub = Subscription<EventPayload>() { [weak subscriber] payload, cancellable in
            if let subscriber = subscriber {
                switch payload {
                case .failure(let error):
                    subscriber.notify(error)
                default:
                    break
                }
            } else {
                cancellable.cancel()
            }
        }
        subscriptions.append(sub)
        
        return sub
    }
}

extension Event: Subscriber {
    
    public typealias Input = EventPayload
    
    public func notify(_ input: Input) {
        switch input {
        case .success(let value):
            post(value)
        case .failure(let error):
            raise(error)
        }
    }
    
    public func notify(_ success: Value) {
        post(success)
    }
    
    public func notify(_ error: Failure) {
        raise(error)
    }
}

// MARK: - Resgister handler.

extension Event {
    
    public func onSuccess(_ completion: @escaping (Value, Cancellable) -> Void) -> Cancellable {
        
        let sub = Subscription<EventPayload>() { payload, cancellable in
            switch payload {
            case .success(let value):
                completion(value, cancellable)
            default:
                break
            }
        }
        subscriptions.append(sub)
        
        return sub
    }
    
    public func onError(_ completion: @escaping (Failure, Cancellable) -> Void) -> Cancellable {
        
        let sub = Subscription<EventPayload>() { payload, cancellable in
            switch payload {
            case .failure(let failure):
                completion(failure, cancellable)
            default:
                break
            }
        }
        subscriptions.append(sub)
        
        return sub
    }
}
