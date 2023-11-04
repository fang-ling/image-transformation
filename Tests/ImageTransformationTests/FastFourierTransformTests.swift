//
//  FastFourierTransformTests.swift
//
//
//  Created by Fang Ling on 2023/11/4.
//

import Foundation
@testable import ImageTransformation
import XCTest

final class FastFourierTransformTests : XCTestCase {
  func test_fft() {
    var a = [7, 3, 5, 0, 0, 0, 0, 0].map { Complex($0, 0) }
    var b = [1, 2, 7, 0, 0, 0, 0, 0].map { Complex($0, 0) }
    _fft(&a, false)
    _fft(&b, false)
    var c = [Complex]()
    for i in a.indices {
      c.append(a[i] * b[i])
    }
    _fft(&c, true)
    _ifft_normalize(&c)
    XCTAssertEqual(c.map { Int($0.real) }, [7, 17, 60, 31, 35, 0, 0, 0])
  }
}
