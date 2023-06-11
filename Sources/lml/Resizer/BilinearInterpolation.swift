//
//  BilinearInterpolation.swift
//
//
//  Created by Fang Ling on 2023/6/11.
//

import txt

extension Resizer {
    @inlinable
    public static func bilinear_interpolation(
      _ origin : RGBA64,
      width : Int,
      height : Int
    ) -> RGBA64 {
        var new = RGBA64(width: width, height: height)

        let s_r = Double(origin.height) / Double(height)
        let s_c = Double(origin.width) / Double(width)

        for r_prime in 0 ..< height {
            for c_prime in 0  ..< width {
                let r_f = Double(r_prime) * s_r
                let c_f = Double(c_prime) * s_c
                let r = Int(r_f)
                let c = Int(c_f)
                let delta_r = r_f - Double(r)
                let delta_c = c_f - Double(c)

                let f1 = (1 - delta_r) * (1 - delta_c)
                let f2 = delta_r * (1 - delta_c)
                let f3 = (1 - delta_r) * delta_c
                let f4 = delta_r * delta_c

                let red =
                  Double(origin.pixels[r * origin.width + c].red()) * f1 +
                  Double(origin.pixels[(r+1) * origin.width + c].red()) * f2 +
                  Double(origin.pixels[r * origin.width + c+1].red()) * f3 +
                  Double(origin.pixels[(r+1) * origin.width + c+1].red()) * f4
                let green =
                  Double(origin.pixels[r * origin.width + c].green()) * f1 +
                  Double(origin.pixels[(r+1) * origin.width + c].green()) * f2 +
                  Double(origin.pixels[r * origin.width + c+1].green()) * f3 +
                  Double(origin.pixels[(r+1) * origin.width + c+1].green()) * f4
                let blue =
                  Double(origin.pixels[r * origin.width + c].blue()) * f1 +
                  Double(origin.pixels[(r+1) * origin.width + c].blue()) * f2 +
                  Double(origin.pixels[r * origin.width + c+1].blue()) * f3 +
                  Double(origin.pixels[(r+1) * origin.width + c+1].blue()) * f4
                let alpha =
                  Double(origin.pixels[r * origin.width + c].alpha()) * f1 +
                  Double(origin.pixels[(r+1) * origin.width + c].alpha()) * f2 +
                  Double(origin.pixels[r * origin.width + c+1].alpha()) * f3 +
                  Double(origin.pixels[(r+1) * origin.width + c+1].alpha()) * f4

                new.pixels.append(
                  RGBA64Pixel(
                    red: Color(red),
                    green: Color(green),
                    blue: Color(blue),
                    alpha: Color(alpha)
                  )
                )
            }
        }

        return new
    }
}
