//
//  WatershedEvent.swift
//  
//

public class WatershedEvent<Success, Failure: Error>: Event<Result<Success, Failure>> {
    
    public let succeed = Event<Success>()
    public let failed = Event<Failure>()
    
    public override init() {
        super.init()
        
        _ = subscribe(Subscription<Output>() { [weak succeed] payload, cancellable in
            if let event = succeed {
                switch payload {
                case .success(let value):
                    event.trigger(value)
                default:
                    break
                }
            } else {
                cancellable.cancel()
            }
        })
        
        _ = subscribe(Subscription<Output>() { [weak failed] payload, cancellable in
            if let event = failed {
                switch payload {
                case .failure(let value):
                    event.trigger(value)
                default:
                    break
                }
            } else {
                cancellable.cancel()
            }
        })
    }
    
    public func success(_ value: Success) {
        trigger(.success(value))
    }
    
    public func failure(_ value: Failure) {
        trigger(.failure(value))
    }
}
