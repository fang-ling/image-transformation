//
//  BilinearInterpolationTests.swift
//
//
//  Created by Fang Ling on 2023/9/15.
//

//import ImageCodec
@testable import ImageTransformation
import XCTest

final class BilinearInterpolationTests : XCTestCase {
  func test_bilinear_interpolation() {
    /* Decode image */
    /*let src = image_decode(file_path: "/tmp/1.jpg")
    guard let src else {
      fatalError("unable to decode image")
    }
    var dst1 = src
    for i in 0 ..< dst1.component_count {
      dst1.components[i] = bilinear_interpolation(
        dst1.components[i],
        src_width: dst1.width,
        src_height: dst1.height,
        dst_width: 64,
        dst_height: 64
      )
    }
    dst1.width = 64
    dst1.height = 64
    image_encode(file_path: "/tmp/2.heic", pixel_buffer: dst1, quality: 1.0)

    var dst2 = src
    for i in 0 ..< dst1.component_count {
      dst2.components[i] = bilinear_interpolation(
        dst2.components[i],
        src_width: dst2.width,
        src_height: dst2.height,
        dst_width: 1333,
        dst_height: 2444
      )
    }
    dst2.width = 1333
    dst2.height = 2444
    image_encode(file_path: "/tmp/3.heic", pixel_buffer: dst2, quality: 1.0)*/
  }
}
