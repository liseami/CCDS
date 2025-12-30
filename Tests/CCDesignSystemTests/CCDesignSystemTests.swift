import XCTest
@testable import CCDesignSystem

final class CCDesignSystemTests: XCTestCase {
    func testVersionExists() throws {
        XCTAssertFalse(CCDesignSystemInfo.version.isEmpty)
    }
}
