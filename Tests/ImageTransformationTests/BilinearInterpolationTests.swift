//
//  BilinearInterpolationTests.swift
//
//
//  Created by Fang Ling on 2023/9/15.
//

import CoreGraphics
import ImageCodec
@testable import ImageTransformation
import UniformTypeIdentifiers
import XCTest
import Foundation
final class BilinearInterpolationTests : XCTestCase {
    func test_1() {
        /*let (pixels, meta) = nearest_neighbor_interpolation(
          src_pixels: [12345,23456, 34567, 65535],
          src_metadata:
            ImageMetadata(
              color_space: CGColorSpace(name: CGColorSpace.sRGB)!,
              width: 1, height: 1
            ),
          dst_width: 500,
          dst_height: 500
        )

        image_encode(file_path: "1.png", pixels: pixels,
                     metadata: meta, type: UTType.png, quality: 1)*/
    }

    func test_bilinear_interpolation() {
        let images = [
          //"Images/test.jpg",
          //"Images/building.jpg",
          //"Images/cameraman.heic",
          "Images/test.png"
          //"/Users/louisshen/Workplace/lml/Images/lenna.jpg"
        ]


        for image in images {
            /* Decode image */
            let (src_pixels, src_metadata) = image_decode(file_path: image)
            if src_pixels == nil || src_metadata == nil {
                fatalError("unable to decode image")
            }
            //print(src_pixels!)
            /* Calculate sizes */
            let sizes = [
              (
                Int(Double(src_metadata!.width) * 0.4),
                Int(Double(src_metadata!.height) * 0.4)
              ),
              (src_metadata!.width * 3, src_metadata!.height * 3)
              //(16, 16)
            ]
            print(src_metadata!.color_space)
            for i in sizes.indices {
                /* BI interpolation */
                var (dst_pixels, dst_metadata) = bilinear_interpolation(
                  src_pixels: src_pixels!,
                  src_metadata: src_metadata!,
                  dst_width: sizes[i].0,
                  dst_height: sizes[i].1
                )
                print(dst_pixels)
                dst_metadata.properties = nil
                //let (dst_pixels, dst_metadata) = (src_pixels!, src_metadata!)
                /* Encode the output image */
                image_encode(
                  file_path: image
                    .components(separatedBy: "/")
                    .joined(separator: "/bi-\(i)-")
                    .replacingOccurrences(of: "jpg", with: "png"),
                    //.replacingOccurrences(of: "png", with: "heic"),
                  pixels: dst_pixels,
                  metadata: dst_metadata,
                  type: UTType.png,
                  quality: 1
                )
            }
        }
    }
}
