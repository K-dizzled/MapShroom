//
//  UiImage+Extension.swift
//  MapShroom
//
//  Created by Андрей on 25.03.2022.
//

import Foundation
import UIKit

extension UIImage {
    func resized(to size: CGSize) -> UIImage {
        return UIGraphicsImageRenderer(size: size).image { _ in
            draw(in: CGRect(origin: .zero, size: size))
        }
    }
}
