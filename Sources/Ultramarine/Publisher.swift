//
//  Publisher.swift
//

public protocol Publisher {
    
    associatedtype Output
    
    func sink(_ completion: @escaping (Output) -> Void) -> Cancellable
}
