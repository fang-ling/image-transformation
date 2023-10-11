//
//  MedianFilterTests.swift
//
//
//  Created by Fang Ling on 2023/10/11.
//

import Foundation
import ImageCodec
@testable import ImageTransformation
import XCTest

final class MedianFilterTests : XCTestCase {
  func test() {
    let rounds = 1
    let files = ["/tmp/1.heic", "/tmp/circuit.heic"]
    for file in files {
      var buf = image_decode(file_path: file)!
      for _ in 0 ..< rounds {
        buf = median_filter(src_buf: buf, k_size: 5)
      }
      image_encode(file_path: file, pixel_buffer: buf, quality: 1.0)
    }
  }
}
