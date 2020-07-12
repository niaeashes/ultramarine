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
The projected value is OpenBehavior that holds updatable value via update method and `<<=` operator.

```swift
let viewModel = LabelViewModel()
let label = UILabel()

viewModel.subscribe(label)

viewModel.text = "updated 1" // Simple set.
XCTAssertEqual(label.text, "updated 1")

// Use update method for projected value.
viewModel.$text.update("updated 2")
XCTAssertEqual(label.text, "updated 2")

// Use <<= operator.
viewModel.$text <<= "updated 3"
XCTAssertEqual(label.text, "updated 3")
```
