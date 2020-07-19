//
//  Upstream.swift
//  Ultramarine
//

class Upstream<Input>: Cancellable {
    
    private var handler: ((Input, Cancellable) -> Void)?
    private var owner: CancellableOwner?
    weak var debugObject: DebugObject? = nil
    
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
    
    weak var obj: T?
    
    init(_ obj: T) {
        self.obj = obj
    }
}

extension Upstream {
    
    var weak: Weak<Upstream<Input>> { Weak(self) }
}

extension Upstream: CustomDebugStringConvertible {
    
    var debugDescription: String {
        return "Upstream<\(Input.self)>: \(debugObject?.debugDescription ?? "(no debug object)")"
    }
}
