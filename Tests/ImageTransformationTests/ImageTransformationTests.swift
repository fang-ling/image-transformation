import ImageCodec
@testable import ImageTransformation
import UniformTypeIdentifiers
import XCTest

final class lmlTests : XCTestCase {
    func test_dct_2d_ii() {
        /* Rectangular */
        let M_int = [10 , 20,  30,
                     40 , 50,  60,
                     70 , 80,  90,
                     100, 110, 120,
                     130, 140, 150]
        let Mt = dct_2d_ii(M_int.map { Double($0) }, rows: 5, cols: 3)
        let iMt = idct_2d_ii(Mt, rows: 5, cols: 3)
        XCTAssertEqual(M_int, iMt.map { Int(round($0)) })

        /* Square */
        let N_int = [19358, 19342, 19306,
                     19348, 19346, 12333,
                     12361, 19342, 12321]
        let Nt = dct_2d_ii(N_int.map { Double($0) }, rows: 3, cols: 3)
        let iNt = idct_2d_ii(Nt, rows: 3, cols: 3)
        XCTAssertEqual(N_int, iNt.map { Int(round($0)) })
    }

    func test_bilinear_interpolation() {
        let (pixels, metadata) = image_decode(file_path: "Images/test.png")
        if pixels == nil || metadata == nil {
            fatalError("unable to decode image")
        }

        /* Test upscale */
        /*let (p1, m1) = bilinear_interpolation(
          pixels: pixels!,
          metadata: metadata!,
          width: 1000,
          height: 3584
        )
        image_encode(
          file_path: "Images/output-1.heic",
          pixels: p1,
          metadata: m1,
          type: UTType.heic,
          quality: 1
        )*/
        /* Test downscale */
        let (p2, m2) = bilinear_interpolation(
          pixels: pixels!,
          metadata: metadata!,
          width: 414,
          height: 896
        )
        image_encode(
          file_path: "Images/output-2.heic",
          pixels: p2,
          metadata: m2,
          type: UTType.heic,
          quality: 1
        )
    }
}
