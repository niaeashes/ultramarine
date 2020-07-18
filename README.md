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

## Behavior

"Behavior" is modeling values that vary over continuous time in FRP.

Specifically, sine waves, current time, and other one-argument functions.
But this is only a conceptual existence.
In practice, we don't deal with values that have a smooth continuity beyond the number of clocks on the CPU.
Ultramarine defines: Behavior as a value that is omnipresent in time.

```swift
let name = "Alice".continuous // Make open string behavior.
print(name.value) // "Alice"

name <<= "Bob"
print(name.value) // "Bob"
```

Behavior always has the value. You get the value via .value property on each Behaviors.

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

# Usecase

## Responsive numeric expression

Ultramarine supports recalculated numeric types over continuous time.

```swift
let a = 1.continuous

let b = a + 10 // b is always `a + 10`

print(a.value) // 1
print(b.value) // 11

a += 10

print(a.value) // 11
print(b.value) // 21

a -= 6

print(a.value) // 5
print(b.value) // 15
```

## String formatting

```swift
let name = "World".continuous
let hello = "Hello, \(%name).".format

print(hello) // Hello, World.

name <<= "Alice"
print(hello) // Hello, Alice.

name <<= "Bob"
print(hello) // Hello, Bob.
```

`%` prefix operator is replaceable `.replaceToken`.

```swift
let hello = "Hello, \(name.replaceToken)".format
```

`.format` is required.
If you don't insert `.format`, the replaceToken will be inserted into the string.
For example: `Hello, <:-0-:>.`

## ViewModel and View (MVVM Architecture)

ViewModel created in Ultramarine makes it easy to bind values to a View.
For example:

```swift
import UIKit

class LabelViewModel {

    @Pub var text = ""

    func subscribe(_ label: UILabel) {
        $text.assign(to: \UILabel.text, on: label)
    }
}
```

@Pub property wrapper means Publisher.
The projected value is OpenBehavior that holds updatable value via `<<=` operator.

```swift
let viewModel = LabelViewModel()
let label = UILabel()

viewModel.subscribe(label)

viewModel.text = "updated" // Simple set.

// Use <<= operator.
viewModel.$text <<= "updated"
```

## Signal: Simple counter and tap signal.

```swift
class ViewModel {
    let tapSignal = Signal<Void>()
    
    func tap() {
        tapSignal.fire(Void())
    }
}

let viewModel = ViewModel()
let count = 0

viewModel.tapSignal.sink { count += 1 }

viewModel.tap() // count = 1
viewModel.tap() // count = 2
```

## Connect between signal and behavior.

There are several ways to connect Behavior and Signals.
Simple implementing is by `sink`

```swift
let number = 0.continuous
let numberSignal = Signal<Int>()

numberSignal.sink { [weak number] value in number? <<= value }
```

A better way is to use `MemoryBehavior`.
This is a Behavior that keeps track of the last value sent by the Signal.
`MemoryBehavior` has `nil` as default value.

```swift
let numberMemory = MemoryBehavior<Int>()
let ticketSignal = Signal<Int>()

print(numberMemory.value) // nil

numberMemory.watch(to: ticketSignal)

ticketSignal.fire(484848)
print(numberMemory.value) // 484848

numberMemory.cancel()
ticketSignal.fire(818181)
print(numberMemory.value) // also, 484848
```
