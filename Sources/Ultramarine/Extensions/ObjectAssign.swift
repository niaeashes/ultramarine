//
//  ObjectAssign.swift
//  Ultramarine
//

#if !os(macOS)
import UIKit
#endif

private typealias Exec = (@escaping () -> Void) -> Void
private let pureExec: Exec = { $0() }

#if !os(macOS)
private let mainThreadExec: Exec = { DispatchQueue.main.async(execute: $0) }
#endif

extension Transmit {
    
    public func assign<Root: AnyObject>(to keyPath: ReferenceWritableKeyPath<Root, Value>, on object: Root) -> Cancellable {
        convertibleAssign(to: keyPath, on: object) { $0 }
    }
    
    public func assign<Root: AnyObject>(to keyPath: ReferenceWritableKeyPath<Root, Optional<Value>>, on object: Root) -> Cancellable {
        convertibleAssign(to: keyPath, on: object) { $0 }
    }
    
    func convertibleAssign<Root: AnyObject, Target>(to keyPath: ReferenceWritableKeyPath<Root, Target>, on object: Root, converter: @escaping (Value) -> Target) -> Cancellable {
        defer { (self as? Publisher)?.publish() }
        return sign { [weak object] value, cancellable in
            guard let object = object else { return cancellable.cancel() }
            var exec = pureExec
            
            #if !os(macOS)
            if object is UIView, !Thread.current.isMainThread {
                exec = mainThreadExec
            }
            #endif
            
            exec() { object[keyPath: keyPath] = converter(value) }
        }
    }
}

// MARK: - CustomStringConvertible.

extension Transmit where Value: CustomStringConvertible {
    
    public func assign<Root: AnyObject>(describeTo keyPath: ReferenceWritableKeyPath<Root, String>, on object: Root) -> Cancellable {
        convertibleAssign(to: keyPath, on: object) { $0.description }
    }
    
    public func assign<Root: AnyObject>(describeTo keyPath: ReferenceWritableKeyPath<Root, Optional<String>>, on object: Root) -> Cancellable {
        convertibleAssign(to: keyPath, on: object) { $0.description }
    }
}
