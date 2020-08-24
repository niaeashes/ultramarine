//
//  RangeReplaceableCollection.swift
//  Ultramarine
//

private let APPENDED_SIGNAL_KEY = "appended"
private let REMOVED_SIGNAL_KEY = "removed"

extension Subject where Value: RangeReplaceableCollection {
    
    public var appendedSignal: Signal<Value.Element>! { signal.get(name: APPENDED_SIGNAL_KEY) }
    public var removedSignal: Signal<(Value.Index, Value.Element)>! { signal.get(name: REMOVED_SIGNAL_KEY) }
    
    public func append(_ newElement: Value.Element) {
        value.append(newElement)

        if signal.has(name: APPENDED_SIGNAL_KEY) {
            appendedSignal?.fire(newElement)
        }
        relay(value)
    }
    
    @discardableResult
    public func remove(at i: Value.Index) -> Value.Element {
        let element = value.remove(at: i)
        
        if signal.has(name: REMOVED_SIGNAL_KEY) {
            removedSignal?.fire((i, element))
        }
        relay(value)
        
        return element
    }
    
    public subscript(index: Value.Index) -> Value.Element? {
        value.indices.contains(index) ? value[index] : nil
    }
}
