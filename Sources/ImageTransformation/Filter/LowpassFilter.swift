//
//  LowpassFilter.swift
//
//
//  Created by Fang Ling on 2023/10/11.
//

import Foundation
import ImageCodec

func lowpass_filter(src_buf : PixelBuffer, k_size : Int) -> PixelBuffer {
  let CC = src_buf.component_count
  let H = src_buf.height
  let W = src_buf.width
  var new_buf = src_buf
  
  for r in 0 ..< src_buf.height {
    for c in 0 ..< src_buf.width {
      for k in 0 ..< CC {
        var sum = 0
        for j in -(k_size / 2) ... (k_size / 2) {
          for i in -(k_size / 2) ... (k_size / 2) {
            sum += Int(
              src_buf.array[
                (
                  squeeze(r + j, 0, H - 1) * W +
                  squeeze(c + i, 0, W - 1)
                ) * CC + k
              ]
            )
          }
        }
        new_buf.array[(r * W + c) * CC + k] = UInt8(sum / (k_size * k_size))
      }
    }
  }
  return new_buf
}
