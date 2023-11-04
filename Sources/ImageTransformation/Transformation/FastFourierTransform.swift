//
//  FastFourierTransform.swift
//
//
//  Created by Fang Ling on 2023/11/4.
//

import Foundation

struct Complex {
  var real : Double
  var imaginary : Double
  
  init(_ real : Double, _ imaginary: Double) {
    self.real = real
    self.imaginary = imaginary
  }
  
  @inlinable
  static func + (lhs : Complex, rhs : Complex) -> Complex {
    return Complex(lhs.real + rhs.real, lhs.imaginary + rhs.imaginary)
  }
  
  @inlinable
  static func - (lhs : Complex, rhs : Complex) -> Complex {
    return Complex(lhs.real - rhs.real, lhs.imaginary - rhs.imaginary)
  }
  
  @inlinable
  static func * (lhs : Complex, rhs : Complex) -> Complex {
    return Complex(
      lhs.real * rhs.real - lhs.imaginary * rhs.imaginary,
      lhs.real * rhs.imaginary + rhs.real * lhs.imaginary
    )
  }
  
  @inlinable
  static func *= (lhs : inout Complex, rhs : Complex) {
    lhs = lhs * rhs
  }
  
  @inlinable
  static func / (lhs : Complex, rhs : Double) -> Complex {
    return Complex(lhs.real / rhs, lhs.imaginary / rhs)
  }
}

func _fft(_ a : inout [Complex], _ is_inv : Bool) {
  let n = a.count /* n must be the power of 2 */
  if n == 1 {
    return
  }
  /* 
   * Euler's formula: exp(ix) = cosx + isinx
   * omega_n = exp(tau*i/n) = exp(i*(tau/n)) = cos(tau/n) + isinx(tau/n)
   */
  let τ_over_n = 2 * π / Double(n) * (is_inv ? -1 : 1)
  let ω_n = Complex(cos(τ_over_n), sin(τ_over_n))
  var ω = Complex(1, 0)
  var a_0 = [Complex]()
  var a_1 = [Complex]()
  for i in stride(from: 0, to: n, by: 2) {
    a_0.append(a[i])
    a_1.append(a[i + 1])
  }
  _fft(&a_0, is_inv)
  _fft(&a_1, is_inv)
  /* 
   * y_0 ---> a_0
   * y_1 ---> a_1
   */
  var δ = Complex(0, 0)
  var ω_times_y1k = Complex(0, 0)
  let len = n / 2
  for k in 0 ..< len {
    ω_times_y1k = ω * a_1[k]
    δ = ω_times_y1k + a_0[k]
    a[k] = δ
    δ = a_0[k] - ω_times_y1k
    a[k + len] = δ
    ω *= ω_n
  }
}

func _ifft_normalize(_ a : inout [Complex]) {
  a = a.map { $0 / Double(a.count) }
}
