//
//  HistogramEqualization.swift
//
//
//  Created by Fang Ling on 2023/10/11.
//

import Foundation

public func histogram_equalization(
  _ I : [UInt8], 
  width : Int,
  height : Int
) -> [UInt8] {
  var J = [UInt8](repeating: 0, count: I.count)
  let mn = width * height
  /* Intensity levels, 256 for 8-bit image */
  let L = 256
  /* The number of pixels that have intensity r_k. (0 ≤ k < 256) */
  var N = [Int](repeating: 0, count: L)
  for r in 0 ..< height {
    for c in 0 ..< width {
      N[Int(I[r * width + c])] += 1
    }
  }
  /* Get P_r(r_k) */
  let P_r = N.map({ Double($0) / Double(mn) })
  /* Get S_k */
  var S = [UInt8]()
  for i in 0 ..< L {
    var sum = 0.0
    for k in 0 ..< i {
      sum += P_r[k]
    }
    sum *= Double(L - 1)
    S.append(UInt8(round(sum)))
  }
  for r in 0 ..< height {
    for c in 0 ..< width {
      J[r * width + c] = S[Int(I[r * width + c])]
    }
  }
  return J
}
