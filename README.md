# Laziable [![Version](https://img.shields.io/badge/Version-1.1.0-black.svg?style=flat)](#installation) [![License](https://img.shields.io/cocoapods/l/Laziable.svg?style=flat)](#license)

[![Platforms](https://img.shields.io/badge/Platforms-iOS|watchOS|tvOS|macOS|watchOS-brightgreen.svg?style=flat)](#installation)
[![Swift support](https://img.shields.io/badge/Swift-3.3%20%7C%204.1%20%7C%204.2-red.svg?style=flat)](#swift-versions-support)
[![CocoaPods Compatible](https://img.shields.io/cocoapods/v/Laziable.svg?style=flat&label=CocoaPods)](https://cocoapods.org/pods/Laziable)
[![Carthage compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage)
[![Twitter](https://img.shields.io/badge/Twitter-@BellAppLab-blue.svg?style=flat)](http://twitter.com/BellAppLab)

![Laziable](./Images/laziable.png)

So you declared a `lazy var` in Swift thinking it would behave like lazily instantiated variables in good ol' Objective-C. You thought you would set them to `nil` and they would reconstruct themselves later on when needed.

You poor thing.

[They don't](https://stackoverflow.com/a/40847994).

So why not bring that awesomeness back to Swift in a very lightweight way?

## Specs

* iOS 9+
* watchOS 3+
* tvOS 9+
* watchOS 3+
* macOS 10.10+
* Swift 4.2+

## Usage

Declare your `Lazy` variable in one of the three ways provided:

**Suggestion**: for the best results, use `let` when declaring your `Lazy` variables.

```swift
class TestClass
{
    let lazyString = §{
        return "testString"
    }

    let lazyDouble: Lazy<Double> = Lazy {
        return 0.0
    }

    let lazyArray = Lazy {
        return ["one", "two", "three"]
    }
}
```

Access your variable:

```swift
let testObject = TestClass()
print(testObject.lazyString§) //prints out "testString"
```

Set your variable to `nil`, so it gets reconstructed again later:

```swift
let testObject = TestClass()
testObject.lazyDouble §= nil
```

## Operators

* `prefix §`
  * Shorthand contructor for a `Lazy` variable:
  
```swift
let lazyThing = §{
    return <#code#>
}
```

* `postfix operator §`
  * Shorthand accessor for `Lazy`:
  
```swift
let lazyString = §{
    return "Much cool"
}

print(lazyThing§) //prints out "Much cool"
```

* `infix operator §=`
  * Shorthand assignment for `Lazy`:

```swift
let lazyString = §{
    return "Much cool"
}

lazyString §= nil //the string "Much cool" has been destroyed
print(lazyThing§) //reconstructs the string and prints out "Much cool"
```

## Notes

For the best results, use `let` when declaring your `Lazy` variables.

Also, make sure to use `[weak self]` or `[unowned self]` if capturing `self` in a `Lazy` variable's constructor.

## Installation

### Cocoapods

```ruby
pod 'Laziable', '~> 1.1'
```

Then `import Laziable` where needed.

### Carthage

```swift
github "BellAppLab/Laziable" ~> 1.1
```

Then `import Laziable` where needed.

### Swift Package Manager

```swift
dependencies: [
    .package(url: "https://github.com/BellAppLab/Laziable", from: "1.1.0")
]
```

Then `import Laziable` where needed.

### Git Submodules

```
cd toYourProjectsFolder
git submodule add -b submodule --name Laziable https://github.com/BellAppLab/Laziable.git
```

Then drag the `Laziable` folder into your Xcode project.

## Author

Bell App Lab, apps@bellapplab.com

### Credits

[Logo image](https://thenounproject.com/search/?q=lazy&i=1604294#) by [Georgiana Ionescu](https://thenounproject.com/georgiana.ionescu) from [The Noun Project](https://thenounproject.com/)

## License

Lazy is available under the MIT license. See the LICENSE file for more info.
