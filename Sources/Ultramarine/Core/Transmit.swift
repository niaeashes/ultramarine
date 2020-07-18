//
//  Transmit.swift
//  Ultramarine
//

public class Transmit<Value> {
    
    private(set) var upstreams: Array<Upstream<Value>> = []
    private var inProcess = false
    
    func relay(_ value: Value) {
        guard lock() else { return }
        defer { unlock() }
        
        let upstreams = self.upstreams
        upstreams.forEach { $0.send(value) }
    }
    
    public func releaseAll() {
        upstreams.forEach { $0.cancel() }
        upstreams = []
    }
}

// MARK: - Upstreams control.

extension Transmit {
    
    @discardableResult
    func sign(_ upstream: @escaping (Value) -> Void) -> Upstream<Value> {
        let upstream = Upstream<Value>(upstream, owner: self)
        upstreams.append(upstream)
        return upstream
    }
}

// MARK: - Lock / Unlock utilities.

extension Transmit {
    
    private func lock() -> Bool {
        defer { inProcess = true }
        return !inProcess
    }
    
    private func unlock() {
        inProcess = false
    }
}

// MARK: Modification methods.

extension Transmit {
    
    public func filter(_ isIncluded: @escaping (Value) -> Bool) -> Transmit<Value> {
        let publisher = Transmit<Value>()
        sign { if isIncluded($0) { publisher.relay($0) } }
        return publisher
    }
    
    public func map<Output>(_ transform: @escaping (Value) -> Output) -> Transmit<Output> {
        let publisher = Transmit<Output>()
        sign { publisher.relay(transform($0)) }
        return publisher
    }
    
    @discardableResult
    public func sink(_ completion: @escaping (Value) -> Void) -> Cancellable {
        sign(completion)
    }
    
    ///
    /// When the value is received, call the object's method.
    ///
    /// Unlike the `sink` method, the `action` method does not register the target object as a weak Reference. For example, the following code is equivalent
    /// ~~~
    /// signal.sink { [weak receiver] in receiver.update($0) }
    /// signal.register(Receiver.update, on: receiver)
    /// ~~~
    ///
    @discardableResult
    public func action<Root: AnyObject>(_ action: @escaping (Root) -> (Value) -> Void, on object: Root) -> Cancellable {
        
        sign { [weak object] in
            guard let object = object else { return }
            action(object)($0)
        }
    }
}

// MARK: - Cancellable.

extension Transmit: CancellableOwner {
    
    func cancel(target: Cancellable) {
        
        if let index = upstreams.firstIndex(where: { $0 === target }) {
            upstreams.remove(at: index)
        }
    }
}

// MARK: - for Debug.

extension Transmit: CustomDebugStringConvertible {
    
    public var debugDescription: String {
        "Transmit<\(Value.self)>, \(upstreams.count) upstreams."
    }
}
