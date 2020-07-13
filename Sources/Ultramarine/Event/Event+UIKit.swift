//
//  UIKitEvent.swift
//  
//

#if !os(macOS)
import UIKit

// MARK: - UIEvent.

public class UIEvent<View: UIView>: Event<View> {
    
    weak var notificationCenter: NotificationCenter?
    var observer: NSObjectProtocol! = nil
    
    init(for name: Notification.Name, object: View, on notificationCenter: NotificationCenter = NotificationCenter.default) {
        
        self.notificationCenter = notificationCenter
        
        super.init()
        
        observer = notificationCenter
            .addObserver(forName: name, object: object, queue: .main) { [weak self] in
                self?.notify($0)
            }
    }
    
    private func notify(_ notification: Notification) {
        if let object = notification.object as? View {
            trigger(object)
        } else {
            assertionFailure()
        }
    }
}

extension UIEvent: Cancellable {
    
    public func cancel() {
        notificationCenter?.removeObserver(observer)
        observer = nil
    }
    
    public var isCanceled: Bool { observer == nil }
}

// MARK: - NotificationCenter.

extension NotificationCenter {
    
    public func event<View: UIView>(for name: Notification.Name, object: View) -> UIEvent<View> {
        return UIEvent(for: name, object: object, on: self)
    }
}

// MARK: - #selector Hack.

public final class SelectorEvent<Sender>: NSObject {
    
    public var selector: Selector { return #selector(SelectorEvent.spawn(_:)) }
    
    private var subscription: Subscription<Sender>?
    
    public init(_ handler: @escaping (Sender, Cancellable) -> Void) {
        subscription = Subscription<Sender>(handler)
        super.init()
    }
    
    @objc private func spawn(_ sender: Any) {
        if let sender = sender as? Sender {
            subscription?.send(sender)
        } else {
            assertionFailure()
        }
    }
}

extension SelectorEvent: Cancellable {
    
    public func cancel() {
        subscription?.cancel()
        subscription = nil
    }
    
    public var isCanceled: Bool { subscription == nil }
}

// MARK: - Tap Event.

public class UITapEvent<View: UIView>: Event<View> {
    private var cancellables: Array<Cancellable> = []
    
    public func watch(_ target: View) {
        let selectorEvent = SelectorEvent() { [weak self] object, cancellable in
            self?.trigger(object) ?? cancellable.cancel()
        }
        let recoginizer = UITapGestureRecognizer(target: selectorEvent, action: selectorEvent.selector)
        target.addGestureRecognizer(recoginizer)
        cancellables.append(selectorEvent)
    }
}

extension UITapEvent where View: UIControl {
    
    public func watch(_ target: View) {
        let selectorEvent = SelectorEvent() { [weak self] object, cancellable in
            self?.trigger(object) ?? cancellable.cancel()
        }
        target.addTarget(selectorEvent, action: selectorEvent.selector, for: .touchUpInside)
        cancellables.append(selectorEvent)
    }
}

#endif
