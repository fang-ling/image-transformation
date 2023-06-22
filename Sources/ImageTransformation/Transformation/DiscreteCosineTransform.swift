//
//  DiscreteCosineTransform.swift
//
//
//  Created by Fang Ling on 2023/6/12.
//

import Foundation

/*
 * 2-D DCT-II formula
 *
 * See https://en.wikipedia.org/wiki/Discrete_cosine_transform#M-D_DCT-II
 * for more infomation.
 */
@inlinable
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
@inlinable
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
