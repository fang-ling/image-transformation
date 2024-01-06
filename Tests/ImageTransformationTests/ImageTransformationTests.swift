@testable import ImageTransformation
import XCTest

final class lmlTests : XCTestCase {
  func test_corr() {
    let I = [1.0, 6, 2,
             5, 3, 1,
             7, 0, 4]
    let K = [1.0, 2,
             -1, 0]
    let Y_prime = [8.0, 7, 4, 5]
    let Y = correlate_2d(I, K, mode: .valid)
    for i in Y.indices {
      XCTAssertEqual(Y_prime[i], Y[i], accuracy: 1e-6)
    }

    let Y_full_prime = [0.0, -1, -6, -2,
                        2, 8, 7, 1,
                        10, 4, 5, -3,
                        14, 7, 8, 4]
    let Y_full = correlate_2d(I, K, mode: .full)
    for i in Y_full.indices {
      XCTAssertEqual(Y_full_prime[i], Y_full[i], accuracy: 1e-6)
    }
  }
}
