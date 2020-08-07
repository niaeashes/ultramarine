# Ultramarine

![Unit Tests](https://github.com/niaeashes/ultramarine/workflows/Unit%20Tests/badge.svg)

Ultramarine is like a Functional Reactive Programming framework.

Our goal is to:

- Lightweight and compact.
- Allows expressions likes functional composition.

But Ultramarine is:

- **NOT** Pure FRP Framework (Swift is not for functional programing)

# Basic

Here's the basic concepts of Ultramarine.

Ultramarine is based on FRP, so I've written a little bit about FRP, but you don't need to know much about it.

## Subject

A Subject is an object that holds a value and can be notified of value changes and can be connected to other Subjects.

```swift
let name = "Alice".subject() // Make string subject.
print(name.value) // "Alice"

name <<= "Bob"
print(name.value) // "Bob"
```

Subject always has the value. You get the value via `.value` property on each Subject.

## Signal

Ultramarine defines Signals as values that are scattered in time, not necessarily It does not focus on time.
Unlike Behavior, signals disappear when they are used up.
(In FRP, this concept is called an Event.)

An Signal object is like a hole that accepts a value. When the value is raised, it is thrown into Signal.

```swift
let signal = Signal<Void>()

signal.fire(())
```

Signals have no function by themselves. Add a process that is chained from the signal.

```swift
let signal = Signal<Void>()
var counter = 0

let sub = signal.sink { counter += 1 }

signal.fire(())
signal.fire(())
print(counter) // 2

sub.cancel()

signal.fire(())
signal.fire(())
print(counter) // 2
```

# Usage

## Expressions

### Arithmetic operators.

Supports: `+`, `-`, `*`, `/`

```swift
let a = 1.subject()
let b = 10.subject()

let c = a + b // c is also Subject<Int>, and always result of `a + b`.

print(c.value) // 1 + 10 = 11

a <<= 10
print(c.value) // 10 + 10 = 20
```

Supports to combine Subject<Int> and Int.

```swift
let a = 1.subject()
let b = a * 2 // b is always result of `a * 2`.

print(b.value) // 1 * 2 = 2

a <<= 6
print(b.value) // 6 * 2 = 12
```

### Logical Operators

Supports: `&&`, `||`, `!`

```swift
let c1 = false.subject()
let c2 = false.subject()

let r1 = c1 && c2
let r2 = c1 || c2
let r3 = !c1

print(r1.value, r2.value, r3.value) // false, false, true

c1 <<= true
print(r1.value, r2.value, r3.value) // false, true, false

c2 <<= true
print(r1.value, r2.value, r3.value) // true, true, false
```

## CustomStringConvertible

If Value is CustomStringconvertible, Subject<Value> has description property.

```swift
let a = 42.subject()
print("answer to ultimate question: \(a.description)") // print '42'
```
