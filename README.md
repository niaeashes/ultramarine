# Ultramarine

Ultramarine is like a Functional Reactive Programming framework.

Our goal is to:

- Lightweight and compact.
- Allows expressions likes functional composition.

But Ultramarine is:

- **NOT** Pure FRP Framework (Swift is not for functional programing)

# Basic

## Behavior

"Behavior" is modeling values that vary over continuous time in FRP.

But Ultramarine defines Behavior as a value that is omnipresent in time.
It means Behavior always provides value via .value property.

## Event

"Event" is Modeling which have occurrences at discrete points in time.

Ultramarine defines Event as values that are interspersed in time.

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

```
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
