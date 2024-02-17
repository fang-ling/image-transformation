//
//  Matrix.swift
//
//
//  Created by Fang Ling on 2024/2/17.
//

import Foundation
import Accelerate

public func transpose(_ I : [Double], row : Int, column : Int) -> [Double] {
  [Double](unsafeUninitializedCapacity: I.count) { buf, u_u_capacity in
    vDSP_mtransD(
      I, 1,
      buf.baseAddress!, 1,
      vDSP_Length(column),
      vDSP_Length(row)
    )
    u_u_capacity = I.count
  }
}
