import XCTest
@testable import Laziable


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


class LazyTests: XCTestCase
{
    let testClass = TestClass()

    func testLazy() {
        XCTAssertEqual(testClass.lazyString§, "testString", "What is going on here?")
        XCTAssertEqual(testClass.lazyDouble§, 0.0, "What is going on here?")
        XCTAssertEqual(testClass.lazyArray§, ["one", "two", "three"], "What is going on here?")

        testClass.lazyDouble §= 1.0

        XCTAssertEqual(testClass.lazyDouble§, 1.0, "What is going on here?")
    }
}

extension LazyTests
{
    static var allTests : [(String, (LazyTests) -> () throws -> Swift.Void)] {
        return [
            ("testLazy", testLazy)
        ]
    }
}
