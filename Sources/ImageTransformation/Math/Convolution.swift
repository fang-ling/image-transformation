//
//  Convolution.swift
//
//
//  Created by Fang Ling on 2024/1/6.
//

import Foundation

public enum ConvolutionMode {
  case full
  case valid
}

public func correlate_2d(
  _ I : [Double],
  _ K : [Double],
  mode : ConvolutionMode
) -> [Double] {
  let I_size = Int(sqrt(Double(I.count)))
  let K_size = Int(sqrt(Double(K.count)))

  var Y = [Double]()
  if mode == .valid { /* Align top-left corner */
    for r in 0 ..< I_size {
      if r + K_size > I_size {
        break
      }
      for c in 0 ..< I_size {
        if c + K_size > I_size {
          break
        }

        var sum = 0.0
        for k in 0 ..< K_size {
          for l in 0 ..< K_size {
            /* I[r+k, c+l] * K[k, l] */
            sum += I[(r + k) * I_size + (c + l)] * K[k * K_size + l]
          }
        }
        Y.append(sum)
      }
    }
  } else { /* Align input's top-left with kernel's bottom-right corner */
    for r in -K_size + 1 ..< I_size {
      for c in -K_size + 1 ..< I_size {

        var sum = 0.0
        for k in 0 ..< K_size {
          if r + k < 0 || r + k >= I_size {
            continue
          }

          for l in 0 ..< K_size {
            if c + l < 0 || c + l >= I_size {
              continue
            }

            sum += I[(r + k) * I_size + (c + l)] * K[k * K_size + l]
          }
        }
        Y.append(sum)
      }
    }
  }
  return Y
}

/* conv(I, K) = corr(I, rot180(K))*/
