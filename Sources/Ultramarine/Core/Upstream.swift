//
//  Upstream.swift
//  Ultramarine
//

class Upstream<Input>: Cancellable {
    
    private var handler: ((Input) -> Void)?
    
    init(_ handler: @escaping (Input) -> Void) {
        self.handler = handler
    }
    
    func send(_ input: Input) {
        handler?(input)
    }
    
    public func cancel() {
        handler = nil
    }
    
    public var isCanceled: Bool { handler == nil }
}
