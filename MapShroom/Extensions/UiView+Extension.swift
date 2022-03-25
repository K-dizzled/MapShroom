//
//  UiView+Extension.swift
//  MapShroom
//
//  Created by Андрей on 25.03.2022.
//

import Foundation
import UIKit

extension UIView {
    func addSubviews(_ views: UIView ...) {
        views.forEach { (view) in
            self.addSubview(view)
        }
    }
}
