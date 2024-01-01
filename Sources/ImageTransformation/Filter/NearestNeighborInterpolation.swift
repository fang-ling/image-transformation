//
//  NearestNeighborInterpolation.swift
//
//
//  Created by Fang Ling on 2023/9/14.
//

import Foundation
//import ImageCodec

/* Due to API updates, it is temporarily unavailable. */
/*@inlinable
public func nearest_neighbor_interpolation(
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
  /*
   * let source's r be r, source's c be c and
   *     destination's r be r', destination's c be c'.
   *       src_height   r           src_width   c
   * s_r = ---------- = --,   s_c = --------- = -- .
   *       dst_height   r'          dst_width   c'
   *
   * r = Int(r' * s_r)
   * c = Int(c' * s_c)
   */
  let CC = src_pixel_buf.component_count
  for r_prime in 0 ..< dst_height {
    for c_prime in 0  ..< dst_width {
      let r_0 = Int(Double(r_prime) * s_r)
      let c_0 = Int(Double(c_prime) * s_c)
      
      for i in 0 ..< CC {
        J.append(UInt8(I[(r_0 * c_in + c_0) * CC + i]))
      }
    }
  }
  dst_pixel_buf.array = J
  
  return dst_pixel_buf
}
*/
