//
//  DiscreteCosineTransformTests.swift
//
//
//  Created by Fang Ling on 2023/12/31.
//

@testable import ImageTransformation
import XCTest

final class DiscreteCosineTransformTests : XCTestCase {
  func test_dct_2d() {
    let x : [Double] = [1, 2, 3, 4, 5, 6]
    let X1 = dct_2d_ii(x, rows: 2, cols: 3)
    let X2 = dct_2d(x, width: 3, height: 2)
    for i in 0 ..< x.count {
      XCTAssertEqual(X1[i], X2[i], accuracy:1e-6)
    }
  }
}
