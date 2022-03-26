//
//  NatureAnnotationView.swift
//  MapShroom
//
//  Created by Андрей on 26.03.2022.
//

import MapKit

private let naturalFindingClusterID = "naturalFinding"

class NatureAnnotationView: MKMarkerAnnotationView {

    static let ReuseID = "naturalAnnotation"

    override init(annotation: MKAnnotation?, reuseIdentifier: String?) {
        super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)
        clusteringIdentifier = naturalFindingClusterID
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func prepareForDisplay() {
        super.prepareForDisplay()
        
        displayPriority = .defaultLow
        
        markerTintColor = #colorLiteral(red: 0.3411764801, green: 0.6235294342, blue: 0.1686274558, alpha: 1)
        glyphImage = UIImage(systemName: "leaf.circle.fill")!
    }
}

class ShroomAnnotationView: MKMarkerAnnotationView {

    static let ReuseID = "shroomAnnotation"
    
    override init(annotation: MKAnnotation?, reuseIdentifier: String?) {
        super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)
        clusteringIdentifier = naturalFindingClusterID
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForDisplay() {
        super.prepareForDisplay()
        
        displayPriority = .defaultHigh
        
        markerTintColor = #colorLiteral(red: 0.2665765285, green: 0.116027005, blue: 0.004009447992, alpha: 1)
        glyphImage = UIImage(named: "mushroom")!
    }
}
