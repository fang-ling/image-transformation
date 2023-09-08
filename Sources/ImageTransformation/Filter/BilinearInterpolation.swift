//
//  BilinearInterpolation.swift
//
//
//  Created by Fang Ling on 2023/6/11.
//

import ImageCodec
import Foundation

@inlinable
public func bilinear_interpolation(
  pixels : [UInt16],
  metadata : ImageMetadata,
  width : Int,
  height : Int
) -> ([UInt16], ImageMetadata) {
    var new_metadata = metadata
    new_metadata.width = width
    new_metadata.height = height
    var new_pixels = [UInt16]()

    let s_r = Double(metadata.height) / Double(height)
    let s_c = Double(metadata.width) / Double(width)

    let mw = metadata.width

    /* Index out of range if perform upscale */
    for r_prime in 0 ..< height {
        for c_prime in 0  ..< width {
            let r_f = Double(r_prime) * s_r
            let c_f = Double(c_prime) * s_c
            let r = Int(r_f)
            let c = Int(c_f)
            let delta_r = r_f - Double(r)
            let delta_c = c_f - Double(c)

            let f1 = (1 - delta_r) * (1 - delta_c)
            let f2 = delta_r * (1 - delta_c)
            let f3 = (1 - delta_r) * delta_c
            let f4 = delta_r * delta_c

            for i in 0 ..< 4 {
                new_pixels.append(
                  UInt16(
                    Double(pixels[(r * mw + c) * 4 + i]) * f1 +
                      Double(pixels[((r+1) * mw + c) * 4 + i]) * f2 +
                      Double(pixels[(r * mw + (c+1)) * 4 + i]) * f3 +
                      Double(pixels[((r+1) * mw + (c+1)) * 4 + i]) * f4
                  )
                )
            }
        }
    }

    return (new_pixels, new_metadata)
}
