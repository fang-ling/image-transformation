//
//  LaplacianSharpeningTests.swift
//
//
//  Created by Fang Ling on 2023/10/11.
//

import Foundation
import ImageCodec
@testable import ImageTransformation
import XCTest

final class LaplacianSharpeningTests : XCTestCase {
  func test() {
    let files = ["/tmp/1.heic", "/tmp/moon.heic"]
    for file in files {
      var buf = image_decode(file_path: file)!
      //buf = laplacian_sharpening(src_buf: buf, kernel: .four)
      image_encode(file_path: file, pixel_buffer: buf, quality: 1.0)
    }
  }
  
//  func test2() {
//    let buf = image_decode(file_path: "/tmp/1.jpg")!
//    
//    var uint_buf = buf
//    uint_buf.array = _laplacian_sharpening(src_buf: buf, kernel: .four).map {
//      UInt8(squeeze($0, 0, 255))
//    }
//    image_encode(file_path: "/tmp/uint8.jpg", pixel_buffer: uint_buf, quality: 1)
//    
//    var int_buf = buf
//    var temp = _laplacian_sharpening(src_buf: buf, kernel: .four)
//    let imin = temp.min()! // may less than zero
//    let imax = temp.max()!
//    temp = temp.map {
//      $0 - imin
//    }
//    int_buf.array = temp.map {
//      UInt8(squeeze(Double($0) * (255.0 / Double(imax)), 0, 255))
//    }
//    image_encode(file_path: "/tmp/int.jpg", pixel_buffer: int_buf, quality: 1)
//    
//    let four_buf = laplacian_sharpening(src_buf: buf, kernel: .four)
//    image_encode(file_path: "/tmp/4.jpg", pixel_buffer: four_buf, quality: 1)
//    let eight_buf = laplacian_sharpening(src_buf: buf, kernel: .eight)
//    image_encode(file_path: "/tmp/8.jpg", pixel_buffer: eight_buf, quality: 1)
//  }
}
