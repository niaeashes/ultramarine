//
//  Upstream.swift
//  Ultramarine
//

class Upstream<Input>: Cancellable {
    
    private var handler: ((Input) -> Void)?
    private weak var owner: CancellableOwner?
    
    init(_ handler: @escaping (Input) -> Void, owner: CancellableOwner? = nil) {
        self.handler = handler
        self.owner = owner
    }
    
    func send(_ input: Input) {
        handler?(input)
    }
    
    public func cancel() {
        handler = nil
        owner?.cancel(target: self)
    }
    
    public var isCanceled: Bool { handler == nil }
}
