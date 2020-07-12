//
//  FunctionalBehavior.swift
//  Ultramarine
//

public final class FunctionalBehavior<Value>: Behavior<Optional<Value>>, Cancellable {
    
    private var members: Dictionary<String, ValueHolder> = [:]
    private var function: ((FunctionalBehavior<Value>) throws -> Value)?
    private var cancellables: Array<Cancellable> = []
    private(set) var lastError: Error? = nil
    
    init(_ function: @escaping (FunctionalBehavior<Value>) throws -> Value) {
        self.function = function
        super.init(nil)
    }
    
    private class ValueHolder: Cancellable {
        
        private(set) var target: AnyObject?
        
        init<V>(behavior: Behavior<V>) {
            self.target = behavior as AnyObject
        }
        
        var hasTarget: Bool { self.target != nil }
        
        func current<V>() -> V? {
            return (self.target as? Behavior<V>)?.value
        }
        
        func cancel() {
            self.target = nil
        }
    }
    
    private class PrivateSubscriber<Value, Input>: Subscriber {
        typealias Input = Input
        
        weak var root: FunctionalBehavior<Value>?
        
        init(_ root: FunctionalBehavior<Value>) {
            self.root = root
        }
        
        func notify(_ input: Input) {
            root?.relay()
        }
    }
    
    public func hasValue(_ key: String) -> Bool {
        return members[key]?.hasTarget ?? false
    }
    
    public func cancel() {
        cancellables.forEach { $0.cancel() }
        subscriptions.forEach { $0.cancel() }
        members = [:]
        function = nil
    }
    
    public var isRunnable: Bool {
        return function != nil
    }
    
    public var hasError: Bool {
        return lastError != nil
    }
    
    public override var value: Value! {
        do {
            return try function?(self)
        } catch {
            lastError = error
            return nil
        }
    }
    
    private func relay() {
        let subscriptions = self.subscriptions
        
        if let value = self.value {
            subscriptions.forEach { $0.send(value) }
        }
    }
    
    public enum FunctionRuntimeError: Error {
        case notFoundAssignedMember(name: String)
        case standard
    }
}

// MARK: - Assign / Find utilities.

extension FunctionalBehavior {
    
    public func assign<Input>(_ key: String, member: Behavior<Input>) {
        if members.contains(where: { k, _ in k == key }) {
            assertionFailure("Already assigned key: \(key)")
        }
        cancellables.append(member.connect(to: PrivateSubscriber<Value, Input>(self)))
        members[key] = ValueHolder(behavior: member)
    }
    
    func find<V>(_ key: String) throws -> V {
        if let value: V = members[key]?.current() {
            return value
        } else {
            throw FunctionRuntimeError.notFoundAssignedMember(name: key)
        }
    }
}
