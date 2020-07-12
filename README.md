# Ultramarine

Ultramarine is like a Functional Reactive Programming framework.

Our goal is to:

- Lightweight and compact.
- Allows for functional composition of classes.
- Minimal utility methods.

# Usecase

## Functional composition for Number

```swift
let a = 1.continuous

let b = a + 10 // b is always `a + 10`

do {
    XCTAssertEqual(a.value, 1)
    XCTAssertEqual(b.value, 11)
}

a += 10

do {
    XCTAssertEqual(a.value, 11)
    XCTAssertEqual(b.value, 21)
}

a -= 6

do {
    XCTAssertEqual(a.value, 5)
    XCTAssertEqual(b.value, 15)
}
```
