//
//  ResultSignal.swift
//  Ultramarine
//  
//

public class ResultSignal<Success, Failure: Error>: Signal<Result<Success, Failure>> {
    
    public let succeed = Signal<Success>()
    public let failed = Signal<Failure>()
    
    public override init() {
        super.init()
        
        subscribe(Subscription<Output>() { [weak succeed] payload, cancellable in
            if let signal = succeed {
                switch payload {
                case .success(let value):
                    signal.fire(value)
                default:
                    break
                }
            } else {
                cancellable.cancel()
            }
        })
        
        subscribe(Subscription<Output>() { [weak failed] payload, cancellable in
            if let signal = failed {
                switch payload {
                case .failure(let value):
                    signal.fire(value)
                default:
                    break
                }
            } else {
                cancellable.cancel()
            }
        })
    }
    
    public override func fire(_ payload: Result<Success, Failure>) {
        super.fire(payload)
    }
    
    public func success(_ value: Success) {
        fire(.success(value))
    }
    
    public func failure(_ value: Failure) {
        fire(.failure(value))
    }
}
