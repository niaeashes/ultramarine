//
//  Result.swift
//  Ultramarine
//

// MARK: - Result.

extension Transmit {
    
    public func ifSuccess<S, F>(_ completion: @escaping (S) -> Void) -> Transmit<Value> where Value == Result<S, F> {
        return map {
            switch $0 {
            case .success(let value):
                completion(value)
            default:
                break
            }
            return $0
        }
    }
    
    public func ifFailure<S, F>(_ completion: @escaping (F) -> Void) -> Transmit<Value> where Value == Result<S, F> {
        return map {
            switch $0 {
            case .failure(let error):
                completion(error)
            default:
                break
            }
            return $0
        }
    }
}
