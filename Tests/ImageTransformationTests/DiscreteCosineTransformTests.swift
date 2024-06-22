//
//  DiscreteCosineTransformTests.swift
//  lml
//
//  Created by Fang Ling on 2023/12/31.
//

@testable import ImageTransformation
import XCTest

final class DiscreteCosineTransformTests: XCTestCase {
  func test_dct_idct_1d() {
    let x = Array(1 ... 256).map({ Float($0) })
    let x_prime = idct(dct(x))
    for i in 0 ..< x.count {
      XCTAssertEqual(x[i], x_prime[i], accuracy: 1e-4)
    }
    print(x_prime)
  }
  func test_dct_idct_2d() {
    let x = Array(1 ... 256).map({ Float($0) })
    let x_prime = idct_2d(
      source: dct_2d(source: x, width: 16, height: 16),
      width: 16,
      height: 16
    )
    for i in 0 ..< x.count {
      XCTAssertEqual(x[i], x_prime[i], accuracy: 1e-4)
    }
  }
}
