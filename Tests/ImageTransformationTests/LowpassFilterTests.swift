//
//  LowpassFilterTests.swift
//  
//
//  Created by Fang Ling on 2023/10/11.
//

import Foundation
import ImageCodec
@testable import ImageTransformation
import XCTest

final class LowpassFilterTests : XCTestCase {
  func test() {
    let rounds = 1
    let files = ["/tmp/1.heic", "/tmp/moon.heic"]
    for file in files {
      var buf = image_decode(file_path: file)!
      for _ in 0 ..< rounds {
        //buf = lowpass_filter(src_buf: buf, k_size: 3)
      }
      image_encode(file_path: file, pixel_buffer: buf, quality: 1.0)
    }
  }
}
