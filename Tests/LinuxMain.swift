#if os(Linux)
import XCTest
@testable import SLToolsTests

XCTMain([
    testCase(SLToolsTests.allTests)
])
#endif
