import TokenLayout
import XCTest

class TokenLayoutTests: XCTestCase {
  //  ┌──────────────┐      ┌──────────────┐      ┌──────────────┐
  //  │     50px     │ 12px │     50px     │ 12px │     50px     │
  //  └──────────────┘      └──────────────┘      └──────────────┘
  //                              10px
  //  ┌──────────────┐      ┌──────────────┐      ┌──────┐
  //  │     50px     │ 12px │     50px     │ 12px │ More │
  //  └──────────────┘      └──────────────┘      └──────┘
  func testLineWrapWithSmallMoreToken() {
    let result = rectsForTokens(
      numberOfTokens: 7,
      in: CGRect(x: 0, y: 0, width: 174, height: 50),
      lineHeight: 20,
      maximumNumberOfLines: 2,
      horizontalSpacing: 12,
      verticalSpacing: 10,
      measureHandler: { _, _ in CGSize(width: 50, height: 1) },
      moreTokenMeasureHandler: { _, _ in CGSize(width: 25, height: 1) }
    )

    let expectedRects = [
      CGRect(x: 0, y: 0, width: 50, height: 20),
      CGRect(x: 62, y: 0, width: 50, height: 20),
      CGRect(x: 124, y: 0, width: 50, height: 20),
      CGRect(x: 0, y: 30, width: 50, height: 20),
      CGRect(x: 62, y: 30, width: 50, height: 20),
      CGRect(x: 124, y: 30, width: 25, height: 20),
    ]

    XCTAssertEqual(result.rects, expectedRects)
    XCTAssertEqual(result.remainingNumberOfTokens, 2)
  }

  //  ┌──────────────┐      ┌──────────────┐      ┌──────────────┐
  //  │     50px     │ 12px │     50px     │ 12px │     50px     │
  //  └──────────────┘      └──────────────┘      └──────────────┘
  //                              10px
  //  ┌──────────────┐      ┌──────────────────┐
  //  │     50px     │ 12px │       More       │
  //  └──────────────┘      └──────────────────┘
  func testLineWrapWithWideMoreToken() {
    let result = rectsForTokens(
      numberOfTokens: 7,
      in: CGRect(x: 0, y: 0, width: 174, height: 50),
      lineHeight: 20,
      maximumNumberOfLines: 2,
      horizontalSpacing: 12,
      verticalSpacing: 10,
      measureHandler: { _, _ in CGSize(width: 50, height: 1) },
      moreTokenMeasureHandler: { _, _ in CGSize(width: 75, height: 1) }
    )

    let expectedRects = [
      CGRect(x: 0, y: 0, width: 50, height: 20),
      CGRect(x: 62, y: 0, width: 50, height: 20),
      CGRect(x: 124, y: 0, width: 50, height: 20),
      CGRect(x: 0, y: 30, width: 50, height: 20),
      CGRect(x: 62, y: 30, width: 75, height: 20),
    ]

    XCTAssertEqual(result.rects, expectedRects)
    XCTAssertEqual(result.remainingNumberOfTokens, 3)
  }

  //  ┌──────────────┐      ┌──────────────┐
  //  │     50px     │ 12px │     50px     │
  //  └──────────────┘      └──────────────┘
  //                              10px
  //  ┌──────────────────────────────────────────────────────────┐
  //  │                      300px -> 174px                      │
  //  └──────────────────────────────────────────────────────────┘
  //                              10px
  //  ┌──────────────┐      ┌──────────────┐
  //  │     50px     │ 12px │     50px     │
  //  └──────────────┘      └──────────────┘
  func testWiderThanLineToken() {
    let widths: [CGFloat] = [50, 50, 300, 50, 50]

    let result = rectsForTokens(
      numberOfTokens: 5,
      in: CGRect(x: 0, y: 0, width: 174, height: 50),
      lineHeight: 20,
      maximumNumberOfLines: 3,
      horizontalSpacing: 12,
      verticalSpacing: 10,
      measureHandler: { idx, _ in CGSize(width: widths[idx], height: 1) },
      moreTokenMeasureHandler: { _, _ in CGSize(width: 75, height: 1) }
    )

    let expectedRects = [
      CGRect(x: 0, y: 0, width: 50, height: 20),
      CGRect(x: 62, y: 0, width: 50, height: 20),
      CGRect(x: 0, y: 30, width: 174, height: 20),
      CGRect(x: 0, y: 60, width: 50, height: 20),
      CGRect(x: 62, y: 60, width: 50, height: 20),
    ]

    XCTAssertEqual(result.rects, expectedRects)
    XCTAssertEqual(result.remainingNumberOfTokens, 0)
  }

  //  ┌──────────────┐      ┌──────────────┐
  //  │     50px     │ 12px │     50px     │
  //  └──────────────┘      └──────────────┘
  //
  //  ┌────────────────────────────────────┐      ┌──────────────┐
  //  │            300 -> 87px             │ 12px │     More     │
  //  └────────────────────────────────────┘      └──────────────┘
  func testWiderThanLineWithMoreToken() {
    let widths: [CGFloat] = [50, 50, 300, 50, 50]

    let result = rectsForTokens(
      numberOfTokens: 5,
      in: CGRect(x: 0, y: 0, width: 174, height: 50),
      lineHeight: 20,
      maximumNumberOfLines: 2,
      horizontalSpacing: 12,
      verticalSpacing: 10,
      measureHandler: { idx, _ in CGSize(width: widths[idx], height: 1) },
      moreTokenMeasureHandler: { _, _ in CGSize(width: 75, height: 1) }
    )

    let expectedRects = [
      CGRect(x: 0, y: 0, width: 50, height: 20),
      CGRect(x: 62, y: 0, width: 50, height: 20),
      CGRect(x: 0, y: 30, width: 87, height: 20),
      CGRect(x: 99, y: 30, width: 75, height: 20),
    ]

    XCTAssertEqual(result.rects, expectedRects)
    XCTAssertEqual(result.remainingNumberOfTokens, 2)
  }

  //  ┌──────────────┐      ┌──────────────┐      ┌──────────────┐
  //  │     50px     │ 12px │     50px     │ 12px │     50px     │
  //  └──────────────┘      └──────────────┘      └──────────────┘
  //                              10px
  //  ┌──────────────┐      ┌──────────────┐      ┌──────────────┐
  //  │     50px     │ 12px │     50px     │ 12px │     50px     │
  //  └──────────────┘      └──────────────┘      └──────────────┘
  //                              10px
  //  ┌──────────────┐
  //  │     50px     │
  //  └──────────────┘
  func testAcceptsZeroMaximumNumberOfLines() {
    let result = rectsForTokens(
      numberOfTokens: 7,
      in: CGRect(x: 0, y: 0, width: 174, height: 50),
      lineHeight: 20,
      maximumNumberOfLines: 0,
      horizontalSpacing: 12,
      verticalSpacing: 10,
      measureHandler: { _, _ in CGSize(width: 50, height: 1) },
      moreTokenMeasureHandler: { _, _ in
        XCTFail("Should not call moreTokenMeasureHandler")
        return .zero
      }
    )

    let expectedRects = [
      CGRect(x: 0, y: 0, width: 50, height: 20),
      CGRect(x: 62, y: 0, width: 50, height: 20),
      CGRect(x: 124, y: 0, width: 50, height: 20),
      CGRect(x: 0, y: 30, width: 50, height: 20),
      CGRect(x: 62, y: 30, width: 50, height: 20),
      CGRect(x: 124, y: 30, width: 50, height: 20),
      CGRect(x: 0, y: 60, width: 50, height: 20),
    ]

    XCTAssertEqual(result.rects, expectedRects)
    XCTAssertEqual(result.remainingNumberOfTokens, 0)
  }
}
