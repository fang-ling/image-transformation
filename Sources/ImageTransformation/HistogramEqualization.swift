//
//  HistogramEqualization.swift
//
//
//  Created by Fang Ling on 2023/10/11.
//

import Foundation
import ImageCodec

/* Due to API updates, it is temporarily unavailable. */
/*
func histogram_equalization(src_buf : PixelBuffer) -> PixelBuffer {
  let CC = src_buf.component_count /* Channel Count */
  var src_buf = src_buf
  let mn = src_buf.width * src_buf.height
  
  /* Intensity levels */
  let L = 256
  
  /* The number of pixels that have intensity r_k. (0≤k<256) */
  var N = [[Int]](repeating: [Int](repeating: 0, count: L), count: CC)
  for r in 0 ..< src_buf.height {
    for c in 0 ..< src_buf.width {
      for j in 0 ..< CC {
        N[j][Int(src_buf.array[(r * src_buf.width + c) * CC + j])] += 1
      }
    }
  }
  /* Get P_r(r_k) */
  let P_r = N.map { n_k in
    n_k.map { Double($0) / Double(mn) }
  }
  /* Get S_k */
  var S = [[UInt8]](repeating: [], count: CC)
  for j in 0 ..< CC {
    for i in 0 ..< L {
      var sum = 0.0
      for k in 0 ..< i {
        sum += P_r[j][k]
      }
      sum *= Double(L - 1)
      S[j].append(UInt8(round(sum)))
    }
  }
  
  for r in 0 ..< src_buf.height {
    for c in 0 ..< src_buf.width {
      for j in 0 ..< CC {
        src_buf.array[(r * src_buf.width + c) * CC + j] = 
          S[j][Int(src_buf.array[(r * src_buf.width + c) * CC + j])]
      }
    }
  }
  return src_buf
}
*/
