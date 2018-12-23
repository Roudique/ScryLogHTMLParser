import XCTest
@testable import ScryLogHTMLParser

final class ScryLogHTMLParserTests: XCTestCase {
    func testEmptyData() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct
        // results.
        let data = Data()
        let tables = ScryLogHTMLParser.parse(data: data)
        
        XCTAssert(tables.count == 0, "There should be no tables for empty data object.")
    }

    static var allTests = [
        ("testExample", testEmptyData),
    ]
}
