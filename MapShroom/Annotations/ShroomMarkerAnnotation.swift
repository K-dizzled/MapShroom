//
//  ShroomMarkerAnnotation.swift
//  MapShroom
//
//  Created by Андрей on 25.03.2022.
//

import Foundation
import MapKit
import UIKit

class ShroomMarkerAnnotation : MKMarkerAnnotationView {
    static let glyphImage: UIImage = {
        let rect = CGRect(origin: .zero, size: CGSize(width: 40, height: 40))
        return UIGraphicsImageRenderer(bounds: rect).image { _ in
            let radius: CGFloat = 11
            let offset: CGFloat = 7
            let insetY: CGFloat = 5
            let center = CGPoint(x: rect.midX, y: rect.maxY - radius - insetY - 6)
            let path = UIBezierPath(arcCenter: center, radius: radius, startAngle: .pi, endAngle: 0, clockwise: true)
            path.append(UIBezierPath(ovalIn: CGRect(x: rect.midX - 6, y: rect.midY - 9, width: 12, height: 22)))
//            path.addQuadCurve(to: CGPoint(x: rect.midX, y: rect.minY + insetY), controlPoint: CGPoint(x: rect.midX - radius, y: center.y - offset))
//            path.addQuadCurve(to: CGPoint(x: rect.midX + radius, y: center.y), controlPoint: CGPoint(x: rect.midX + radius, y: center.y - offset))
            path.close()
            UIColor.white.setFill()
            path.fill()
        }
    }()

    override var annotation: MKAnnotation? {
        didSet { configure(for: annotation) }
    }

    override init(annotation: MKAnnotation?, reuseIdentifier: String?) {
        super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)

        glyphImage = Self.glyphImage
        markerTintColor = #colorLiteral(red: 0.3098039329, green: 0.2039215714, blue: 0.03921568766, alpha: 1)

        configure(for: annotation)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(for annotation: MKAnnotation?) {
        displayPriority = .required

        // if doing clustering, also add
        // clusteringIdentifier = ...
    }
}
