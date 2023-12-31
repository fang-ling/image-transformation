//
//  HistogramEqualizationTests.swift
//  
//
//  Created by Fang Ling on 2023/10/11.
//

import Foundation
import ImageCodec
@testable import ImageTransformation
import XCTest

final class HistogramEqualizationTests : XCTestCase {
  func test() {
    let files = ["/tmp/1.heic", "/tmp/bridge.heic"]
    for file in files {
      var buf = image_decode(file_path: file)!
      //buf = histogram_equalization(src_buf: buf)
      image_encode(file_path: file, pixel_buffer: buf, quality: 1.0)
    }
  }
}
