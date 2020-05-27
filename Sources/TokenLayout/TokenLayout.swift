import CoreGraphics
import Foundation

public func rectsForTokens(
  numberOfTokens: Int,
  in rect: CGRect,
  lineHeight: CGFloat,
  maximumNumberOfLines: Int,
  horizontalSpacing: CGFloat,
  verticalSpacing: CGFloat,
  measureHandler: (Int, CGSize) -> CGSize,
  moreTokenMeasureHandler: (_ remainingItems: Int, _ remainingSize: CGSize) -> CGSize,
  ceil: (CGFloat) -> CGFloat = { $0.rounded(.up) }
) -> (rects: [CGRect], remainingNumberOfTokens: Int) {
  var remainingNumberOfTokens = numberOfTokens
  var currentLine = 0
  var tokenRects = [CGRect]()
  var lineRect = CGRect(x: rect.minX, y: rect.minY, width: rect.width, height: lineHeight)

  while remainingNumberOfTokens > 0, (currentLine < maximumNumberOfLines || maximumNumberOfLines == 0) {
    let rectsForLine = rectsForFittingTokensInLine(
      numberOfTokens: remainingNumberOfTokens,
      lineRect: lineRect,
      spacing: horizontalSpacing,
      measureHandler: { idx, availableSize in
        measureHandler(idx + tokenRects.count, availableSize)
      }
    )

    remainingNumberOfTokens -= rectsForLine.count
    tokenRects += rectsForLine
    currentLine += 1
    lineRect.origin.y += lineHeight + verticalSpacing

    // check that we're on the last line and that we have tokens left
    guard currentLine == maximumNumberOfLines, remainingNumberOfTokens > 0 else {
      continue
    }

    let lastLineMaxX = rectsForLine.last?.maxX ?? CGFloat(0)
    var remainingWidth = rect.minX + rect.width - lastLineMaxX - horizontalSpacing
    var moreTokenWidth = ceil(
      min(
        lineRect.width,
        moreTokenMeasureHandler(
          remainingNumberOfTokens,
          CGSize(width: remainingWidth, height: lineHeight)
        ).width
      )
    )

    if rectsForLine.count > 1 {
      var tokensToRemove = 0

      while remainingWidth < moreTokenWidth {
        let tokenRect = rectsForLine[rectsForLine.count - 1 - tokensToRemove]
        remainingWidth += tokenRect.width + horizontalSpacing
        tokensToRemove += 1
        remainingNumberOfTokens += 1

        moreTokenWidth = ceil(
          min(
            lineRect.width,
            moreTokenMeasureHandler(
              remainingNumberOfTokens,
              CGSize(width: remainingWidth, height: lineHeight)
            ).width
          )
        )
      }

      tokenRects = Array(tokenRects.dropLast(tokensToRemove))
    } else if rectsForLine.count == 1 {
      tokenRects[tokenRects.count - 1].size.width = rect.width - horizontalSpacing - moreTokenWidth
    }

    tokenRects.append(CGRect(
      x: tokenRects.last.map { $0.maxX + horizontalSpacing } ?? rect.minX,
      y: lineRect.origin.y - lineHeight - verticalSpacing,
      width: moreTokenWidth,
      height: lineHeight
    ))
  }

  return (rects: tokenRects, remainingNumberOfTokens: remainingNumberOfTokens)
}

private func rectsForFittingTokensInLine(
  numberOfTokens: Int,
  lineRect: CGRect,
  spacing: CGFloat,
  measureHandler: (Int, CGSize) -> CGSize
) -> [CGRect] {
  var tokenFrame = CGRect(x: lineRect.minX, y: lineRect.minY, width: 0, height: lineRect.height)
  var tokenRects = [CGRect]()

  for idx in 0 ..< numberOfTokens {
    let remainingWidth = lineRect.minX + lineRect.width - tokenFrame.minX

    if remainingWidth <= 0 {
      return tokenRects
    }

    let requiredSize = measureHandler(idx, CGSize(width: remainingWidth, height: lineRect.height))
    let requiredWidth = ceil(requiredSize.width)

    switch requiredSize {
    case _ where requiredWidth <= remainingWidth:
      tokenFrame.size.width = requiredWidth

    // a token can never be wider than the whole line
    case _ where idx == 0:
      tokenFrame.size.width = remainingWidth

    default:
      return tokenRects
    }

    tokenRects.append(tokenFrame)
    tokenFrame.origin.x = tokenFrame.maxX + spacing
  }

  return tokenRects
}
