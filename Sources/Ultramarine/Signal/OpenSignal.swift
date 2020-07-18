//
//  OpenSignal.swift
//  Ultramarine
//  

public final class OpenSignal<Payload>: Signal<Payload> {
    
    public override init() {}
    
    public override func fire(_ payload: Payload) {
        super.fire(payload)
    }
}
