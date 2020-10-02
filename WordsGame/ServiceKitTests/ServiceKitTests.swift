import XCTest
@testable import ServiceKit
import Combine

class ServiceKitTests: XCTestCase {
    var cancellable: Cancellable?

    func testExample() throws {
        let exp = expectation(description: "1")
        cancellable = TranslatedWordsLoader.live.load()
        .sink(receiveValue: {
            print($0)
            exp.fulfill()
            })

        waitForExpectations(timeout: 5, handler: nil)
    }
}
