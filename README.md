# Ultramarine

Ultramarine is like a Functional Reactive Programming framework.

Our goal is to:

- Lightweight and compact.
- Allows for functional composition of classes.
- Minimal utility methods.

# Basic

## Behavior

"Behavior" is modeling values that vary over continuous time.

Ultramarine defines Behavior as a value that is omnipresent in time.
It means Behavior always provides value via .value property. (Pull)

## Event

"Event" is Modeling which have occurrences at discrete points in time.

Ultramarine defines Event as values that are interspersed in time.

## Publisher / Subscriber

Publisher sends the values to Subscriber as needed.
Behavior is always Publisher and notifies Subscribers when the value changes.

# Usecase

## Functional composition for Number

```swift
let a = 1.continuous

let b = a + 10 // b is always `a + 10`

XCTAssertEqual(a.value, 1)
XCTAssertEqual(b.value, 11)

a += 10

XCTAssertEqual(a.value, 11)
XCTAssertEqual(b.value, 21)

a -= 6

XCTAssertEqual(a.value, 5)
XCTAssertEqual(b.value, 15)
```
