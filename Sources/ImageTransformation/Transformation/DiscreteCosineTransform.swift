//
//  DiscreteCosineTransform.swift
//
//
//  Created by Fang Ling on 2023/6/12.
//

import Accelerate
import Foundation

/*
 * 1-D DCT-IV:
 * For 0 <= k < N
 *   Or[k] = sum(Ir[j] * cos((k+1/2) * (j+1/2) * pi / N, 0 <= j < N)
 */
func dct(_ source: [Float]) -> [Float] {
  let forward_dct = vDSP.DCT(count: source.count, transformType: .IV)!
  return forward_dct.transform(source)
}

func idct(_ source: [Float]) -> [Float] {
  return dct(vDSP.multiply(2 / Float(source.count), source))
}

/* x: width * height */
public func dct_2d(source: [Float], width: Int, height: Int) -> [Float] {
  var X = [Float]()
  X.reserveCapacity(source.count)
  /* Row DCT */
  for r in 0 ..< height {
    X += dct(Array(source[r * width ..< (r + 1) * width]))
  }
  /* Column DCT */
  var X_T = transpose(X, row: height, column: width)
  X.removeAll(keepingCapacity: true)
  for c in 0 ..< width {
    X += dct(Array(X_T[c * height ..< (c + 1) * height]))
  }
  /* Transpose back */
  X_T = transpose(X, row: width, column: height)
  return X_T
}

public func idct_2d(source: [Float], width: Int, height: Int) -> [Float] {
  var x = [Float]()
  x.reserveCapacity(source.count)
  /* Row IDCT */
  for r in 0 ..< height {
    x += idct(Array(source[r * width ..< (r + 1) * width]))
  }
  /* Column IDCT */
  var X_T = transpose(x, row: height, column: width)
  x.removeAll(keepingCapacity: true)
  for c in 0 ..< width {
    x += idct(Array(X_T[c * height ..< (c + 1) * height]))
  }
  /* Transpose back */
  X_T = transpose(x, row: width, column: height)
  return X_T
}
