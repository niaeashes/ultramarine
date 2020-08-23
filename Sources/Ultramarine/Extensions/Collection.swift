//
//  Collection.swift
//  Ultramarine
//

extension Subject where Value: Collection {
    
    public var isEmpty: Subject<Bool> { transform { $0.isEmpty } }
    public var count: Subject<Int> { transform { $0.count } }
}
