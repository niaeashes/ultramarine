//
//  Upstream.swift
//  Ultramarine
//

class Upstream<Input>: Cancellable {
    
    private var handler: ((Input, Cancellable) -> Void)?
    private var owner: CancellableOwner?
    
    init(owner: CancellableOwner, _ handler: @escaping (Input, Cancellable) -> Void) {
        self.handler = handler
        self.owner = owner
    }
    
    func send(_ input: Input) {
        handler?(input, self)
    }
    
    public func cancel() {
        handler = nil
        owner?.cancel(target: self)
    }
    
    public var isCanceled: Bool { handler == nil }
}

class Weak<T: AnyObject> {
    
    weak var body: T?
    
    init(_ body: T) {
        self.body = body
    }
}

extension Upstream {
    
    var weak: Weak<Upstream<Input>> { Weak(self) }
}
