# Ultramarine

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
let name = "Alice".subject // Make string writable subject.
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

signal.sink { counter += 1 }

signal.fire(())
signal.fire(())
signal.fire(())
print(counter) // 3
```

# Usage
