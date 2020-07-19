//
//  Transmit.swift
//  Ultramarine
//

public class Transmit<Value> {
    
    var sources: Array<Cancellable> = []
    private(set) var upstreams: Array<Weak<Upstream<Value>>> = []
    private var inProcess = false
    
    func relay(_ value: Value) {
        guard lock() else { return }
        defer { unlock() }
        
        let upstreams = self.upstreams.compactMap { $0.obj }
        upstreams.forEach { $0.send(value) }
    }
    
    func bind(source: Cancellable) {
        sources.append(source)
    }
    
    public func releaseAll() {
        upstreams.forEach { $0.obj?.cancel() }
        upstreams = []
        sources = []
    }
    
    public func clean() {
        upstreams = upstreams.filter { !($0.obj?.isCanceled ?? true) }
    }
    
    deinit {
        upstreams.forEach { $0.obj?.cancel() }
    }
}

// MARK: - Upstreams control.

extension Transmit {
    
    @discardableResult
    func sign(_ upstream: @escaping (Value, Cancellable) -> Void) -> Upstream<Value> {
        defer { clean() }
        let upstream = Upstream<Value>(owner: self, upstream)
        upstreams.append(upstream.weak)
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
        let sub = sign { [weak publisher] in
            guard let publisher = publisher else { return $1.cancel() }
            if isIncluded($0) { publisher.relay($0) }
        }
        publisher.bind(source: sub)
        return publisher
    }
    
    public func map<Output>(_ transform: @escaping (Value) -> Output) -> Transmit<Output> {
        let publisher = Transmit<Output>()
        let sub = sign { [weak publisher] in
            guard let publisher = publisher else { return $1.cancel() }
            publisher.relay(transform($0))
        }
        publisher.bind(source: sub)
        return publisher
    }
    
    @discardableResult
    public func sink(_ completion: @escaping (Value) -> Void) -> Cancellable {
        return sign { value, _ in completion(value) }
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
        
        return sign { [weak object] in
            guard let object = object else { return $1.cancel() }
            action(object)($0)
        }
    }
}

// MARK: - Assign to another object.

extension Transmit {
    
    public func assign<Root: AnyObject>(to keyPath: ReferenceWritableKeyPath<Root, Value>, on object: Root) -> Cancellable {
        if let subject = self as? Subject<Value> {
            object[keyPath: keyPath] = subject.value
        }
        return sign { [weak object] in
            guard let object = object else { return $1.cancel() }
            object[keyPath: keyPath] = $0
        }
    }
    
    public func assign<Root: AnyObject>(to keyPath: ReferenceWritableKeyPath<Root, Optional<Value>>, on object: Root) -> Cancellable {
        if let subject = self as? Subject<Value> {
            object[keyPath: keyPath] = subject.value
        }
        return sign { [weak object] in
            guard let object = object else { return $1.cancel() }
            object[keyPath: keyPath] = $0
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
