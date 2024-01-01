//
//  NearestNeighborInterpolationTests.swift
//
//
//  Created by Fang Ling on 2023/9/14.
//

//import ImageCodec
@testable import ImageTransformation
import UniformTypeIdentifiers
import XCTest

final class NearestNeighborInterpolationTests : XCTestCase {
  /*func test_nearest_neighbor_interpolation() {
    let images = [
      "Images/test.jpg",
      "Images/building.jpg",
      "Images/cameraman.heic",
      "Images/lenna.jpg"
    ]
    
    for image in images {
      /* Decode image */
      let src_pixel_buf = image_decode(file_path: image)
      guard let src_pixel_buf else {
        fatalError("unable to decode image")
      }
      /* Calculate sizes */
      let sizes = [
        (
          Int(Double(src_pixel_buf.width) * 0.4),
          Int(Double(src_pixel_buf.height) * 0.4)
        ),
        (src_pixel_buf.width * 3, src_pixel_buf.height * 3)
      ]
      for i in sizes.indices {
        /* NN interpolation */
        let dst_pixel_buf = nearest_neighbor_interpolation(
          src_pixel_buf: src_pixel_buf,
          dst_width: sizes[i].0,
          dst_height: sizes[i].1
        )
        /* Encode the output image */
        image_encode(
          file_path: image.components(separatedBy: "/")
            .joined(separator: "/nn-\(i)-")
            .replacingOccurrences(of: "jpg", with: "png")
            .replacingOccurrences(of: "png", with: "heic"),
          pixel_buffer: dst_pixel_buf,
          quality: 1
        )
      }
    }
  }*/
}
