//Adapted from: https://github.com/mattgallagher/CwlUtils
/*
 ISC License

 Copyright © 2017 Matt Gallagher ( http://cocoawithlove.com ). All rights reserved.

 Permission to use, copy, modify, and/or distribute this software for any
 purpose with or without fee is hereby granted, provided that the above
 copyright notice and this permission notice appear in all copies.

 THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES
 WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF
 MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR ANY
 SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES
 WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN
 ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF OR
 IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
 */
#if os(Linux)
import Glibc
#else
import Darwin
#endif

private final class PThreadMutex {
  func sync<R>(execute work: () throws -> R) rethrows -> R {
    unbalancedLock()
    defer { unbalancedUnlock() }
    return try work()
  }

  func trySync<R>(execute work: () throws -> R) rethrows -> R? {
    guard unbalancedTryLock() else { return nil }
    defer { unbalancedUnlock() }
    return try work()
  }

  private var unsafeMutex = pthread_mutex_t()

  /// Default constructs as ".Normal" or ".Recursive" on request.
  init() {
    var attr = pthread_mutexattr_t()
    guard pthread_mutexattr_init(&attr) == 0 else {
      preconditionFailure()
    }
    pthread_mutexattr_settype(&attr, Int32(PTHREAD_MUTEX_NORMAL))
    guard pthread_mutex_init(&unsafeMutex, &attr) == 0 else {
      preconditionFailure()
    }
    pthread_mutexattr_destroy(&attr)
  }

  deinit {
    pthread_mutex_destroy(&unsafeMutex)
  }

  private func unbalancedLock() {
    pthread_mutex_lock(&unsafeMutex)
  }

  private func unbalancedTryLock() -> Bool {
    return pthread_mutex_trylock(&unsafeMutex) == 0
  }

  private func unbalancedUnlock() {
    pthread_mutex_unlock(&unsafeMutex)
  }
}


/*
 Copyright (c) 2018 Bell App Lab <apps@bellapplab.com>

 Permission is hereby granted, free of charge, to any person obtaining a copy
 of this software and associated documentation files (the "Software"), to deal
 in the Software without restriction, including without limitation the rights
 to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 copies of the Software, and to permit persons to whom the Software is
 furnished to do so, subject to the following conditions:

 The above copyright notice and this permission notice shall be included in
 all copies or substantial portions of the Software.

 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 THE SOFTWARE.
 */

import Foundation


//MARK: - Main
/**
 The main point of interaction with `Laziable`.

 You create a `Lazy` object by:

 ```swift
 let lazyThing = §{
     return <#code#>
 }
 ```

 At this point, `Lazy` is just storing the `Constructor` closure passed to it, not the underlying `Value`.
 Upon calling `lazyThing§`, `Lazy` will evaluate if a `Value` already exists. If it does, it will return it.
 If it doesn't, it will create a new one using the `Constructor`.

 By calling `lazyThing §= nil` you can then release the underlying `Value` and free some memory.
 */
public final class Lazy<Value>: CustomStringConvertible
{
    //MARK: Private instance variables
    @nonobjc
    private let mutex = PThreadMutex()

    @nonobjc
    private let constructor: () -> Value

    @nonobjc
    private var _value: Value?

    @nonobjc
    fileprivate var value: Value! {
        get {
            return mutex.sync {
                let value = _value ?? constructor()
                _value = value
                return value
            }
        }
        set {
            mutex.sync { _value = newValue }
        }
    }

    //MARK: Public
    /**
     A constructor closure that builds the `Value` that a `Lazy` object should hold.
     */
    public typealias Constructor = () -> Value

    //MARK: Initialisers
    /**
     Creates a new `Lazy` object with a `Constructor`.

     - parameters:
         - constructor: a constructor closure that builds the `Value` that this `Lazy` object should hold.
     */
    @nonobjc
    public init(_ constructor: @escaping Constructor) {
        self.constructor = constructor
    }

    @nonobjc
    public var description: String {
        if let tempValue = _value {
            return "Lazy<\(type(of: tempValue))>: constructor - \(constructor); value: \(tempValue)"
        }
        return "Lazy: constructor - \(constructor); value: nil"
    }
}


//MARK: - Operators
prefix operator §
/**
 Shorthand constructor for `Lazy`.

 ```swift
 let lazyThing = §{
     return <#code#>
 }
 ```
 */
public prefix func §<T>(rhs: @escaping () -> T) -> Lazy<T> {
    return Lazy(rhs)
}

postfix operator §
/**
 Shorthand accessor for `Lazy`.

 ```swift
 let lazyString = §{
     return "Much cool"
 }

 print(lazyThing§) //prints out "Much cool"
 ```
 */
public postfix func §<T>(lhs: Lazy<T>) -> T {
    return lhs.value
}

infix operator §=: AssignmentPrecedence
/**
 Shorthand assignment for `Lazy`.

 ```swift
 let lazyString = §{
     return "Much cool"
 }

 lazyString §= nil //the string "Much cool" has been destroyed
 print(lazyThing§) //reconstructs the string and prints out "Much cool"
 ```
 */
public func §=<T>(lhs: Lazy<T>, rhs: T?) {
    lhs.value = rhs
}
