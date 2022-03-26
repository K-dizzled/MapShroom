//
//  FilterViewController.swift
//  MapShroom
//
//  Created by Андрей on 26.03.2022.
//

import Foundation
import UIKit
import MapKit

class FilterViewController: UIViewController {
    
    private enum Constants {
        static let topLineCornerRadius : CGFloat = 3
        static let topLineWidthPercent : CGFloat = 0.15
        static let topLineOffset : CGFloat = 12
        static let topLineHeight : CGFloat = 6
        
        static let draggingVelocity : CGFloat = 1300
        static let animationDuration : CGFloat = 0.3
        static let yOriginNotDismissed : CGFloat = 400
    }
    
    var onDoneBlock : ((Bool) -> Void)?
    private var hasSetPointOrigin = false
    private var pointOrigin: CGPoint?
    
    let topView: UIView = {
        let view = UIView()
        view.isUserInteractionEnabled = true
        view.backgroundColor = .clear
        return view
    }()
    
    let topDarkLine: UIView = {
        let view = UIView()
        view.backgroundColor = .secondaryLabel
        view.layer.cornerRadius = Constants.topLineCornerRadius
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        if !hasSetPointOrigin {
            hasSetPointOrigin = true
            pointOrigin = self.view.frame.origin
        }
        
        setupViews()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if isBeingDismissed {
            onDoneBlock!(true)
        }
    }
    
    func setupViews() {
        view.addSubview(topView)
        topView.frame = CGRect(
            x: 0, y: 0,
            width: view.frame.width,
            height: view.frame.height
        )
        
        topView.addSubview(topDarkLine)
        let lineSize = view.frame.width * Constants.topLineWidthPercent
        topDarkLine.frame = CGRect(
            x: (view.frame.width - lineSize) / 2,
            y: Constants.topLineOffset,
            width: lineSize,
            height: Constants.topLineHeight
        )
        
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(panGestureRecognizerAction))
        
        topView.addGestureRecognizer(panGesture)
    }
    
    @objc func panGestureRecognizerAction(sender: UIPanGestureRecognizer) {
        let translation = sender.translation(in: view)

        guard translation.y >= 0 else { return }

        view.frame.origin = CGPoint(
            x: 0,
            y: self.pointOrigin!.y + translation.y
        )

        if sender.state == .ended {
            let dragVelocity = sender.velocity(in: view)
            if dragVelocity.y >= Constants.draggingVelocity {
                // Velocity fast enough to dismiss the uiview
                self.dismiss(animated: true, completion: nil)
            } else {
                // Set back to original position of the view controller
                UIView.animate(withDuration: Constants.animationDuration) {
                    self.view.frame.origin = self.pointOrigin ?? CGPoint(
                        x: 0, y: Constants.yOriginNotDismissed
                    )
                }
            }
        }
    }
}

