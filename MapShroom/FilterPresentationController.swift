//
//  FilterPresentationController.swift
//  MapShroom
//
//  Created by Андрей on 26.03.2022.
//

import Foundation
import UIKit

class FilterPresentationController: UIPresentationController {
    let blurEffectView: UIVisualEffectView!
    var tapGestureRecognizer: UITapGestureRecognizer = UITapGestureRecognizer()


    override init(
        presentedViewController: UIViewController,
        presenting presentingViewController: UIViewController?
    ) {
        let blurEffect = UIBlurEffect(style: .systemThinMaterial)
        blurEffectView = UIVisualEffectView(effect: blurEffect)

        super.init(
            presentedViewController: presentedViewController,
            presenting: presentingViewController
        )

        tapGestureRecognizer = UITapGestureRecognizer(
            target: self,
            action: #selector(dismissController)
        )

        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]

        self.blurEffectView.isUserInteractionEnabled = true
        self.blurEffectView.addGestureRecognizer(tapGestureRecognizer)
    }

    override var frameOfPresentedViewInContainerView: CGRect {
        CGRect(
            x: 0, y: self.containerView!.frame.height * 0.4,
            width: self.containerView!.frame.width,
            height: self.containerView!.frame.height * 0.6
        )
    }

    override func presentationTransitionWillBegin() {
        self.blurEffectView.alpha = 0
        self.containerView?.addSubview(blurEffectView)
        self.presentedViewController
            .transitionCoordinator?
            .animate(
                alongsideTransition: { (UIViewControllerTransitionCoordinatorContext) in
                    self.blurEffectView.alpha = 0.7
                },
                completion: { (UIViewControllerTransitionCoordinatorContext) in
                }
            )
    }

    override func dismissalTransitionWillBegin() {
        self.presentedViewController
            .transitionCoordinator?
            .animate(
                alongsideTransition: { (UIViewControllerTransitionCoordinatorContext) in
                    self.blurEffectView.alpha = 0
                },
                completion: { (UIViewControllerTransitionCoordinatorContext) in
                    self.blurEffectView.removeFromSuperview()
                }
            )
    }

    override func containerViewWillLayoutSubviews() {
        super.containerViewWillLayoutSubviews()
        presentedView!.roundCorners([.topLeft, .topRight], radius: 22)
    }

    override func containerViewDidLayoutSubviews() {
        super.containerViewDidLayoutSubviews()
        presentedView?.frame = frameOfPresentedViewInContainerView
        blurEffectView.frame = containerView!.bounds
    }

    @objc func dismissController(){
        self.presentedViewController.dismiss(animated: true, completion: nil)
    }
}


