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
  src_pixel_buf : PixelBuffer,
  dst_width : Int,
  dst_height : Int
) -> PixelBuffer {
  /*
   * Let I be r_in * c_in image. We want to resize I to r_out * c_out and make
   * a new image.
   */
  /* Preparation */
  let I = src_pixel_buf.array
  var J = [UInt8]()
  var dst_pixel_buf =
    PixelBuffer(
      width: dst_width,
      height: dst_height,
      bits_per_component: src_pixel_buf.bits_per_component,
      component_count: src_pixel_buf.component_count,
      color_space: src_pixel_buf.color_space,
      bitmap_info: src_pixel_buf.bitmap_info,
      properties: src_pixel_buf.properties
    )
  /* Size of original image */
  let r_in = src_pixel_buf.height
  let c_in = src_pixel_buf.width
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
       *
       * 0.5 for aligned_corner
       */
      let r_f = (Double(r_prime) + 0.5) * s_r - 0.5
      let c_f = (Double(c_prime) + 0.5) * s_c - 0.5
      /*
       * (r_0, c_0) are the row and column indices of the pixels in the
       * input image to use in the algorithm.
       */
      var r_0 = Int(floor(r_f))
      var c_0 = Int(floor(c_f))
      /*
       * 1) Neither r_0 nor c_0 can be less than zero and
       * 2) r_0 + 1 cannot be greater than r_in - 1 and
       *    c_0 + 1 cannot be greater than c_in - 1.
       */
      if r_0 < 0 { r_0 = 0 }
      if c_0 < 0 { c_0 = 0 }
      let r_1 = r_0 == r_in - 1 ? r_0 : r_0 + 1
      let c_1 = c_0 == c_in - 1 ? c_0 : c_0 + 1
      /*
       * (∆r, ∆c) are the fractional parts of the row and column subpixel
       * locations.
       */
      let Δr = r_f - floor(r_f)
      let Δc = c_f - floor(c_f)
      
      let f1 = (1 - Δr) * (1 - Δc)
      let f2 = Δr * (1 - Δc)
      let f3 = (1 - Δr) * Δc
      let f4 = Δr * Δc
      
      for i in 0 ..< CC {
        let j =
          Double(I[(r_0 * c_in + c_0) * CC + i]) * f1 +
          Double(I[(r_1 * c_in + c_0) * CC + i]) * f2 +
          Double(I[(r_0 * c_in + c_1) * CC + i]) * f3 +
          Double(I[(r_1 * c_in + c_1) * CC + i]) * f4
        
        J.append(UInt8(j))
      }
    }
  }
  dst_pixel_buf.array = J
  
  return dst_pixel_buf
}
