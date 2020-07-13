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

## Event

"Event" is modeling which have occurrences at discrete time in FRP.

The most common example of an event is user input.
In FRP concepts, an Event is a time/value pair. However, Ultramarine defines Events as values that are scattered in time, not necessarily It does not focus on time.
Unlike Behavior, events disappear when they are used up.

An Event object is like a hole that accepts a value. When the value is raised, it is thrown into Event.

```swift
let event = Event<Void>()

event.trigger(())
```

Events have no function by themselves. Add a process that is chained from the event.

```swift
let event = Event<Void>()
var counter = 0

event.sink { counter += 1 }

event.trigger(())
event.trigger(())
event.trigger(())
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

```swift
// Redefine format
hello <> "Goodbye, \(%name)." // or use .replace(format:)
print(hello) // Goodbye, Bob.
```

`<>` operator means "(re)define" the behavior.

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

## Event: Simple counter and tap event.

```swift
class ViewModel {
    let tapEvent = Event<Void>()
    
    func tap() {
        tapEvent.trigger(Void())
    }
}

let viewModel = ViewModel()
let count = 0

viewModel.tapEvent.sink { count += 1 }

viewModel.tap() // count = 1
viewModel.tap() // count = 2
```
