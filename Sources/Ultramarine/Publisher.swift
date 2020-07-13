//
//  Publisher.swift
//

public protocol Publisher {
    
    associatedtype Output
    
    func sink(_ completion: @escaping (Output) -> Void) -> Cancellable
}

#if !os(macOS)

import Foundation

extension Publisher {
    
    public func receive(on runLoop: RunLoop) -> Self {
        return self
    }
}

#endif
