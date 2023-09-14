//
//  NearestNeighborInterpolation.swift
//
//
//  Created by Fang Ling on 2023/9/14.
//

import ImageCodec
import Foundation

@inlinable
public func nearest_neighbor_interpolation(
  src_pixels : [UInt16],
  src_metadata : ImageMetadata,
  dst_width : Int,
  dst_height : Int
) -> ([UInt16], ImageMetadata) {
    /* Preparation */
    let src_width = src_metadata.width
    let src_height = src_metadata.height
    var dst_metadata = src_metadata
    dst_metadata.width = dst_width
    dst_metadata.height = dst_height
    var dst_pixels = [UInt16]()
    /* Calculate scale factor */
    let s_r = Double(src_height) / Double(dst_height)
    let s_c = Double(src_width) / Double(dst_width)
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
    for r_prime in 0 ..< dst_height {
        for c_prime in 0  ..< dst_width {
            let r = Int(Double(r_prime) * s_r)
            let c = Int(Double(c_prime) * s_c)
            /* Four channels for R, G, B and A. */
            for i in 0 ..< 4 {
                dst_pixels.append(
                  UInt16(src_pixels[(r * src_width + c) * 4 + i])
                )
            }
        }
    }

    return (dst_pixels, dst_metadata)
}
