//
//  BicubicInterpolation.swift
//  
//
//  Created by Fang Ling on 2023/9/17.
//

import Foundation
import ImageCodec

/* Returns nearest valid index */
@inlinable
func squeeze<T : Comparable>(_ i : T, _ min : T, _ max : T) -> T {
  return i > max ? max : (i < min ? min : i)
}

@usableFromInline
let C : [Double] = [ 1,  0,  0,  0,
                     0,  0,  1,  0,
                    -3,  3, -2, -1,
                     2, -2,  1,  1]
/* Transpose of C */
@usableFromInline
let C_T : [Double] = [1,  0, -3,  2,
                      0,  0,  3, -2,
                      0,  1, -2,  1,
                      0,  0, -1,  1]

@inlinable
func mat_mul_4x4(_ A : [Double], _ B : [Double]) -> [Double] {
  return [
    A[0x0]*B[0x0]+A[0x1]*B[0x4]+A[0x2]*B[0x8]+A[0x3]*B[0xc],
    A[0x0]*B[0x1]+A[0x1]*B[0x5]+A[0x2]*B[0x9]+A[0x3]*B[0xd],
    A[0x0]*B[0x2]+A[0x1]*B[0x6]+A[0x2]*B[0xa]+A[0x3]*B[0xe],
    A[0x0]*B[0x3]+A[0x1]*B[0x7]+A[0x2]*B[0xb]+A[0x3]*B[0xf],
    
    A[0x4]*B[0x0]+A[0x5]*B[0x4]+A[0x6]*B[0x8]+A[0x7]*B[0xc],
    A[0x4]*B[0x1]+A[0x5]*B[0x5]+A[0x6]*B[0x9]+A[0x7]*B[0xd],
    A[0x4]*B[0x2]+A[0x5]*B[0x6]+A[0x6]*B[0xa]+A[0x7]*B[0xe],
    A[0x4]*B[0x3]+A[0x5]*B[0x7]+A[0x6]*B[0xb]+A[0x7]*B[0xf],
    
    A[0x8]*B[0x0]+A[0x9]*B[0x4]+A[0xa]*B[0x8]+A[0xb]*B[0xc],
    A[0x8]*B[0x1]+A[0x9]*B[0x5]+A[0xa]*B[0x9]+A[0xb]*B[0xd],
    A[0x8]*B[0x2]+A[0x9]*B[0x6]+A[0xa]*B[0xa]+A[0xb]*B[0xe],
    A[0x8]*B[0x3]+A[0x9]*B[0x7]+A[0xa]*B[0xb]+A[0xb]*B[0xf],
    
    A[0xc]*B[0x0]+A[0xd]*B[0x4]+A[0xe]*B[0x8]+A[0xf]*B[0xc],
    A[0xc]*B[0x1]+A[0xd]*B[0x5]+A[0xe]*B[0x9]+A[0xf]*B[0xd],
    A[0xc]*B[0x2]+A[0xd]*B[0x6]+A[0xe]*B[0xa]+A[0xf]*B[0xe],
    A[0xc]*B[0x3]+A[0xd]*B[0x7]+A[0xe]*B[0xb]+A[0xf]*B[0xf],
  ]
}

/* Due to API updates, it is temporarily unavailable. */
/*@inlinable
public func bicubic_interpolation(
  src_pixel_buf : PixelBuffer,
  dst_width : Int,
  dst_height : Int
) -> PixelBuffer {
  let CC = src_pixel_buf.component_count
  /*
   * Let I be r_in * c_in image. We want to resize I to r_out * c_out and make
   * a new image.
   */
  /* Preparation */
  let OFFSET = [-1, 0, 1, 2]
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
  
  for r_prime in 0 ..< r_out {
    for c_prime in 0 ..< c_out {
      /*
       * (r_f, c_f) is the subpixel location in the input image from which
       * to sample the output pixel (r, c).
       *
       * 0.5 for aligned_corner
       */
      let r_f = (Double(r_prime) + 0.5) * s_r - 0.5
      let c_f = (Double(c_prime) + 0.5) * s_c - 0.5
      /*
       * (r_0, c_0) are the row and column indices of the pixels in the
       * input image to use in the algorithm.
       */
      let r_0 = Int(floor(r_f))
      let c_0 = Int(floor(c_f))
      /*
       * (∆r, ∆c) are the fractional parts of the row and column subpixel
       * locations.
       */
      let Δr = r_f - floor(r_f)
      let Δc = c_f - floor(c_f)
      for i in 0 ..< CC {
        /*
         *  I_prime:
         *  +---------+---------+---------+---------+
         *  | r-1,c-1 | r-1,c+0 | r-1,c+1 | r-1,c+2 |
         *  |    0    |    1    |    2    |    3    |
         *  +---------+---------+---------+---------+
         *  | r+0,c-1 | r+0,c+0 | r+0,c+1 | r+0,c+2 |
         *  |    4    |    5    |    6    |    7    |
         *  +---------+---------+---------+---------+
         *  | r+1,c-1 | r+1,c+0 | r+1,c+1 | r+1,c+2 |
         *  |    8    |    9    |    a    |    b    |
         *  +---------+---------+---------+---------+
         *  | r+2,c-1 | r+2,c+0 | r+2,c+1 | r+2,c+2 |
         *  |    c    |    d    |    e    |    f    |
         *  +---------+---------+---------+---------+
         */
        var I_p = [Double]()
        for m in OFFSET {
          for n in OFFSET {
            let x = squeeze(r_0+m, 0, r_in-1) * c_in + squeeze(c_0+n, 0, c_in-1)
            I_p.append(Double(I[x * CC + i]))
          }
        }
        /*
         *  D(r,c):
         *  +-         -+
         *  | 0 1 | 2 3 |
         *  | 4 5 | 6 7 |
         *  | ----+---- |
         *  | 8 9 | a b |
         *  | c d | e f |
         *  +-         -+
         *
         * --===>
         *  0: I(r, c)                  1: I(r, c + 1)
         *  4: I(r + 1, c)              5: I(r + 1, c + 1)
         *  --
         *  2: ∂(0)/∂c                  3: ∂(1)/∂c
         *  6: ∂(4)/∂c                  7: ∂(5)/∂c
         *  --
         *  8: ∂(0)/∂r                  9: ∂(1)/∂r
         *  c: ∂(4)/∂r                  d: ∂(5)/∂r
         *  --
         *  8: ∂(0)/∂c∂r                9: ∂(1)/∂c∂r
         *  c: ∂(4)/∂c∂r                d: ∂(5)/∂c∂r
         * --===>
         *  0: I(r, c)                  1: I(r, c + 1)
         *  4: I(r + 1, c)              5: I(r + 1, c + 1)
         *  --
         *  2: 0.5 * (I(r, c + 1) - I(r, c - 1))
         *  3: 0.5 * (I(r, c + 2) - I(r, c))
         *  6: 0.5 * (I(r + 1, c + 1) - I(r + 1, c - 1))
         *  7: 0.5 * (I(r + 1, c + 2) - I(r + 1, c))
         *  --
         *  8: 0.5 * (I(r + 1, c) - I(r - 1, c))
         *  9: 0.5 * (I(r + 1, c + 1) - I(r - 1, c + 1))
         *  c: 0.5 * (I(r + 2, c) - I(r, c))
         *  d: 0.5 * (I(r + 2, c + 1) - I(r, c + 1))
         *  --
         *  a: .25 * (I(r+1,c+1) - I(r+1,c-1) + I(r-1,c-1) - I(r-1,c+1))
         *  b: .25 * (I(r+1,c+2) - I(r+1,c) + I(r-1,c) - I(r-1,c+2))
         *  e: .25 * (I(r+2,c+1) - I(r+2,c-1) + I(r,c-1) - I(r,c+1))
         *  f: .25 * (I(r+2,c+2) - I(r+2,c) + I(r,c) - I(r,c+2))
         */
        let D =
          [ //     0         1                        2                        3
            I_p[0x5], I_p[0x6], 0.5*(I_p[0x6]-I_p[0x4]), 0.5*(I_p[0x7]-I_p[0x5]),
            //     4         5                      6                          7
            I_p[0x9], I_p[0xa], 0.5*(I_p[0xa]-I_p[0x8]), 0.5*(I_p[0xb]-I_p[0x9]),
            //                    8                        9
            0.5*(I_p[0x9]-I_p[0x1]), 0.5*(I_p[0xa]-I_p[0x2]),
            //                                       a
            0.25*(I_p[0xa]-I_p[0x8]+I_p[0x0]-I_p[0x2]),
            //                                       b
            0.25*(I_p[0xb]-I_p[0x9]+I_p[0x1]-I_p[0x3]),
            //                    c                        d
            0.5*(I_p[0xd]-I_p[0x5]), 0.5*(I_p[0xe]-I_p[0x6]),
            //                                       e
            0.25*(I_p[0xe]-I_p[0xc]+I_p[0x4]-I_p[0x6]),
            //                                       f
            0.25*(I_p[0xf]-I_p[0xd]+I_p[0x5]-I_p[0x7])
          ]
        let A = mat_mul_4x4(mat_mul_4x4(C, D), C_T)
        
        var j = 0.0
        let r_p = [1, Δr, Δr * Δr, Δr * Δr * Δr] /* Powers of Δr */
        let c_p = [1, Δc, Δc * Δc, Δc * Δc * Δc] /* Powers of Δc */
        for m in 0 ..< 4 {
          for n in 0 ..< 4 {
            j += A[m * 4 + n] * r_p[m] * c_p[n]
          }
        }
        /* Don't know why j is less than zero or greater than 255. */
        J.append(UInt8(squeeze(round(j), 0, 255)))
      }
    }
  }
  dst_pixel_buf.array = J
  
  return dst_pixel_buf
}
*/
