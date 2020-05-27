import XCTest

#if !canImport(ObjectiveC)
  public func allTests() -> [XCTestCaseEntry] {
    [
      testCase(TokenLayoutTests.allTests),
    ]
  }
#endif
