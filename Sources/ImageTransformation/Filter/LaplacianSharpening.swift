//
//  LaplacianSharpening.swift
//
//
//  Created by Fang Ling on 2023/10/11.
//

import Foundation
import ImageCodec

fileprivate let kernel =
  [ 
    //0, 0, 0,  0, 0, 0, 0,
    //0, 0, 0,  0, 0, 0, 0,
    /*0, 0, */0,  1, 0,// 0, 0,
              /*0, 0, */1, -4, 1,// 0, 0,
              /*0, 0, */0,  1, 0,// 0, 0,
    //0, 0, 0,  0, 0,// 0, 0,
    //0, 0, 0,  0, 0,// 0, 0
  ]

func laplacian_sharpening(src_buf : PixelBuffer) -> PixelBuffer {
  let k_size = 3
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
            sum +=
              Int(src_buf.array[
                (
                  squeeze(r + j, 0, H - 1) * W +
                  squeeze(c + i, 0, W - 1)
                ) * CC + k
              ]) * kernel[(j+1) * 3 + (i+1)]
          }
        }
        new_buf.array[(r * W + c) * CC + k] =
          UInt8(squeeze(Int(new_buf.array[(r * W + c) * CC + k]) - sum, 0, 255))
      }
    }
  }
  return new_buf
}
