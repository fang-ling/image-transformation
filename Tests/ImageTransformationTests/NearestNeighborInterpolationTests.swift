//
//  NearestNeighborInterpolationTests.swift
//
//
//  Created by Fang Ling on 2023/9/14.
//

import ImageCodec
@testable import ImageTransformation
import UniformTypeIdentifiers
import XCTest

final class NearestNeighborInterpolationTests : XCTestCase {
    func test_nearest_neighbor_interpolation() {
        let images = [
          "Images/test.jpg",
          "Images/building.jpg",
          "Images/cameraman.heic",
          "Images/lenna.jpg"
        ]
        for image in images {
            /* Decode image */
            let (src_pixels, src_metadata) = image_decode(file_path: image)
            if src_pixels == nil || src_metadata == nil {
                fatalError("unable to decode image")
            }
            /* Calculate sizes */
            let sizes = [
              (
                Int(Double(src_metadata!.width) * 0.4),
                Int(Double(src_metadata!.height) * 0.4)
              ),
              (src_metadata!.width * 3, src_metadata!.height * 3),
              (512, 512)
            ]

            for i in sizes.indices {
                /* NN interpolation */
                let (dst_pixels, dst_metadata) = nearest_neighbor_interpolation(
                  src_pixels: src_pixels!,
                  src_metadata: src_metadata!,
                  dst_width: sizes[i].0,
                  dst_height: sizes[i].1
                )
                /* Encode the output image */
                image_encode(
                  file_path: image
                    .components(separatedBy: "/")
                    .joined(separator: "/nn-\(i)-")
                    .replacingOccurrences(of: "jpg", with: "heic"),
                  pixels: dst_pixels,
                  metadata: dst_metadata,
                  type: UTType.heic,
                  quality: 1
                )
            }
        }
    }
}
