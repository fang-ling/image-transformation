//
//  FastFourierTransformTests.swift
//
//
//  Created by Fang Ling on 2023/11/4.
//

import Foundation
import ImageCodec
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
  
  func test_fft_2d() {
    var buf = image_decode(file_path: "/tmp/1.jpg")!
    let c_pixels = fft_2d(buf)
    let pixels = c_pixels.map {
      $0.map { $0.map { UInt8(squeeze(20 * log($0.magnitude()), 0, 255)) }}
    }
    let CC = buf.component_count
    for k in 0 ..< CC {
      for r in 0 ..< buf.height {
        for c in 0 ..< buf.width {
          buf.array[(r * buf.height + c) * CC + k] = pixels[k][r][c]
        }
      }
    }
    image_encode(file_path: "/tmp/2.jpg", pixel_buffer: buf, quality: 1)
  }
}
