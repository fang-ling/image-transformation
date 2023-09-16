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
  src_pixels : [UInt16],
  src_metadata : ImageMetadata,
  dst_width : Int,
  dst_height : Int
) -> ([UInt16], ImageMetadata) {
    /*
     * Let I be r_in * c_in image. We want to resize I to r_out * c_out and make
     * a new image.
     */
    let I = src_pixels
    var J = [UInt16]()
    /* Copy metadata */
    var dst_metadata = src_metadata
    dst_metadata.height = dst_height
    dst_metadata.width = dst_width
    /* Size of original image */
    let r_in = src_metadata.height
    let c_in = src_metadata.width
    /* Size of scaled image */
    let r_out = dst_height
    let c_out = dst_width
    /* Row and column scale factors */
    let s_r = Double(r_in) / Double(r_out)
    let s_c = Double(c_in) / Double(c_out)

    for r_prime in 0 ..< r_out {
        for c_prime in 0 ..< c_out {
            /*
             * (r_f, c_f) is the subpixel location in the input image from which
             * to sample the output pixel (r, c).
             */
            let r_f = Double(r_prime+1) * s_r
            let c_f = Double(c_prime+1) * s_c
            //r_f = min(Double(r_in - 1), r_f)
            //c_f = min(Double(c_in - 1), c_f)
            /*
             * (r_0, c_0) are the row and column indices of the pixels in the
             * input image to use in the algorithm.
             */
            var r_0 = Int(floor(/*Double(r_prime) * s_r*/r_f))
            var c_0 = Int(floor(/*Double(c_prime) * s_c*/c_f))
            /*
             * 1) Neither r_0 nor c_0 can be less than zero and
             * 2) r_0 + 1 cannot be greater than r_in - 1 and
             *    c_0 + 1 cannot be greater than c_in - 1.
             */
            if r_0 < 1 { r_0 = 1 }
            //if r_0 + 1 > r_in - 1 { r_0 = r_in - 2 }
            if c_0 < 1 { c_0 = 1 }
            //if c_0 + 1 > c_in - 1 { c_0 = c_in - 2 }
            let r_1 = (r_0 == r_in/* - 1*/) ? r_0 : r_0 + 1
            let c_1 = (c_0 == c_in/* - 1*/) ? c_0 : c_0 + 1

            /*
             * (∆r, ∆c) are the fractional parts of the row and column subpixel
             * locations.
             */
            let Δr = r_f - floor(r_f)
            let Δc = c_f - floor(c_f)
            //print(r_0 * c_in + c_0-c_in-1)
            let f1 = (1 - Δr) * (1 - Δc)
            let f2 = Δr * (1 - Δc)
            let f3 = (1 - Δr) * Δc
            let f4 = Δr * Δc
            for i in 0 ..< 4 {
                var j =
                  Double(I[(r_0 * c_in + c_0-c_in-1) * 4 + i]) * f4 +
                  Double(I[(r_1 * c_in + c_0-c_in-1) * 4 + i]) * f3 +
                  Double(I[(r_0 * c_in + c_1-c_in-1) * 4 + i]) * f2 +
                  Double(I[(r_1 * c_in + c_1-c_in-1) * 4 + i]) * f1

                //if j > 65535 { j = 65535 }
                J.append(UInt16(round(j)))
                //J.append(UInt16(round(j)))
                //J.append(UInt16(round(j)))
                //J.append(UInt16(round(j)))
            }
            /*if r_prime == 0 && c_prime == 0 {
                print("r_f:\(r_f)")
                print("c_f:\(c_f)")
                print("r_0:\(r_0)")
                print("c_0:\(c_0)")
                print("r_1:\(r_1)")
                print("c_1:\(c_1)")
                print("(1 - Δr) * (1 - Δc):\((1 - Δr) * (1 - Δc))")
                print("Δr * (1 - Δc):\(Δr * (1 - Δc))")
                print("(1 - Δr) * Δc:\((1 - Δr) * Δc)")
                print("Δr * Δc:\(Δr * Δc)")
                print(I[(r_0 * c_in + c_0) * 4] >> 8)
                print(I[(r_1 * c_in + c_0) * 4] >> 8)
                print(I[(r_0 * c_in + c_1) * 4] >> 8)
                print(I[(r_1 * c_in + c_1) * 4] >> 8)
                }*/
            //
            //print("r_0:\(r_0) c_0:\(c_0) r_1:\(r_1) c_1:\(c_1)")
        }
    }

    return (J, dst_metadata)
    /*/* Preparation */
    let src_width = src_metadata.width
    let src_height = src_metadata.height
    var dst_metadata = src_metadata
    dst_metadata.width = dst_width
    dst_metadata.height = dst_height
    //dst_metadata.properties = nil /* do not copy properties */
    var dst_pixels = [UInt16]()
    /* Calculate scaling factors */
    let s_r = Double(src_height) / Double(dst_height)
    let s_c = Double(src_width) / Double(dst_width)

    /*
     * Create a cubic pixel array:
     * [R16G16B16A16, R16G16B16A16, R16G16B16A16, ...]
     *      \
     *       \---> most significant bit                   least significant bit
     *                 RRRRRRRRRRRRRRRRGGGG...GGGGBBB..BBBAAAAAAAAAAAAAAAA
     *                 \-----------------------64 bits-------------------/
     */
    var cubic_pixels = [UInt64]()
    for i in stride(from: 0, to: src_pixels.count, by: 4) {
        var pixel : UInt64 = 0
        for j in 0 ..< 4 {
            pixel |= (UInt64(src_pixels[i + j]) << (16 * (3 - j)))
        }
        cubic_pixels.append(pixel)
    }

    for r_prime in 0 ..< dst_height {
        for c_prime in 0  ..< dst_width {
            var r_f = min(Double(src_height - 1), Double(r_prime) * s_r)
            var c_f = min(Double(src_width - 1), Double(c_prime) * s_c)
            var r = Int(r_f)
            var c = Int(c_f)
            var delta_r = r_f - Double(r)
            var delta_c = c_f - Double(c)

            var i1 = r * src_width + c
            var i2 = i1 + 1
            var i3 = (r + 1) * src_width + c
            var i4 = i3 + 1

            var f1 = (1 - delta_r) * (1 - delta_c)
            var f2 = (1 - delta_r) * delta_c
            var f3 = delta_r * (1 - delta_c)
            var f4 = delta_r * delta_c

            for i in (0 ..< 4).reversed() {
                let val = Double(
                    (cubic_pixels[i1] >> (16*i)) & 0xFFFF
                  ) * f1 +
                    Double(
                      (cubic_pixels[i2] >> (16*i)) & 0xFFFF
                    ) * f2 +
                    Double(
                      (cubic_pixels[i3] >> (16*i)) & 0xFFFF
                    ) * f3 +
                    Double(
                      (cubic_pixels[i4] >> (16*i)) & 0xFFFF
                    ) * f4
                dst_pixels.append(
                  UInt16(
                    val
                  )
                )
            }
        }
    }

    return (dst_pixels, dst_metadata)*/

/*        var new_metadata = src_metadata
    new_metadata.width = dst_width
    new_metadata.height = dst_height
    var new_pixels = [UInt16]()

    let s_r = Double(src_metadata.height) / Double(dst_height)
    let s_c = Double(src_metadata.width) / Double(dst_width)

    let mw = src_metadata.width

    /* Index out of range if perform upscale */
    for r_prime in 0 ..< dst_height {
        for c_prime in 0  ..< dst_width {
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
                    Double(src_pixels[(r * mw + c) * 4 + i]) * f1 +
                      Double(src_pixels[((r+1) * mw + c) * 4 + i]) * f2 +
                      Double(src_pixels[(r * mw + (c+1)) * 4 + i]) * f3 +
                      Double(src_pixels[((r+1) * mw + (c+1)) * 4 + i]) * f4
                  )
                )
            }
        }
    }

    return (new_pixels, new_metadata)*/
}
