//
//  DiscreteCosineTransform.swift
//
//
//  Created by Fang Ling on 2023/6/12.
//

import Foundation

/* 1-D DCT-II */
func _dct(_ x : [Double]) -> [Double] {
  let N = x.count
  var X = [Double]()
  X.reserveCapacity(N)

  /* constants */
  let π_over_N = π / Double(N)

  for k in 0 ..< N {
    var sum = 0.0
    for n in 0 ..< N {
      /* x_n * cos(π/N * (n + 1/2) * k) */
      sum += x[n] * cos(π_over_N * (Double(n) + 0.5) * Double(k))
    }
    X.append(sum)
  }

  /* Normalize (make it orthogonal) */
  X[0] *= 1 / sqrt(Double(N))
  let µ = sqrt(2) / sqrt(Double(N))
  for i in 1 ..< X.count {
    X[i] *= µ
  }

  return X
}

/* x: width * height */
public func dct_2d(_ x : [Double], width : Int, height : Int) -> [Double] {
  var X = [Double]()
  X.reserveCapacity(x.count)
  /* Row DCT */
  for r in 0 ..< height {
    X += _dct(Array(x[r * width ..< (r + 1) * width]))
  }
  /* Column DCT */
  /* In-place transpose is most difficult for a non-square matrix. */
  var X_T = [Double](repeating: 0, count: X.count)
  for r in 0 ..< height {
    for c in 0 ..< width {
      X_T[c * height + r] = X[r * width + c]
    }
  }
  X.removeAll(keepingCapacity: true)
  for c in 0 ..< width {
    X += _dct(Array(X_T[c * height ..< (c + 1) * height]))
  }
  /* Transpose back */
  X_T = [Double](repeating: 0, count: x.count)
  for c in 0 ..< width {
    for r in 0 ..< height {
      X_T[r * width + c] = X[c * height + r]
    }
  }
  return X_T
}

/*
 * 2-D DCT-II formula
 *
 * See https://en.wikipedia.org/wiki/Discrete_cosine_transform#M-D_DCT-II
 * for more infomation.
 */
@available(*, deprecated, message: "Use dct_2d(:width:height) instead")
public func dct_2d_ii(_ x : [Double], rows : Int, cols : Int) -> [Double] {
    var X = [Double](repeating: 0, count: rows * cols)
    let r_d = Double(rows)
    let c_d = Double(cols)

    for k1 in 0 ..< rows {
        for k2 in 0 ..< cols {
            let k1_d = Double(k1)
            let k2_d = Double(k2)

            for n1 in 0 ..< rows {
                for n2 in 0 ..< cols {
                    let n1_d = Double(n1)
                    let n2_d = Double(n2)

                    X[k1 * cols + k2] +=
                      x[n1 * cols + n2] *
                      cos(π * (n1_d + 0.5) * k1_d / r_d) *
                      cos(π * (n2_d + 0.5) * k2_d / c_d)
                }
            }
            /* Normalize */
            X[k1 * cols + k2] *= c(k1, r_d) * c(k2, c_d)
        }
    }
    return X
}

/*
 * Inverse 2-D DCT-II formula
 */
@available(*, deprecated, message: "No longer needed")
public func idct_2d_ii(_ X : [Double], rows : Int, cols : Int) -> [Double] {
    var x = [Double](repeating: 0, count: rows * cols)
    let r_d = Double(rows)
    let c_d = Double(cols)

    for k1 in 0 ..< rows {
        for k2 in 0 ..< cols {
            let k1_d = Double(k1)
            let k2_d = Double(k2)

            for n1 in 0 ..< rows {
                for n2 in 0 ..< cols {
                    let n1_d = Double(n1)
                    let n2_d = Double(n2)

                    x[k1 * cols + k2] +=
                      X[n1 * cols + n2] *
                      c(n1, r_d) * c(n2, c_d) * /* Normalize */
                      cos(π * (k1_d + 0.5) * n1_d / r_d) *
                      cos(π * (k2_d + 0.5) * n2_d / c_d)
                }
            }
        }
    }
    return x
}

@inlinable func c(_ u : Int, _ n : Double) -> Double {
    return u == 0 ? sqrt(1 / n) : sqrt(2 / n)
}
