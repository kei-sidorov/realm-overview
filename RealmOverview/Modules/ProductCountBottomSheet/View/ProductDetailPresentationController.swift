//
//  ProductDetailPresentationController.swift
//  RealmOverview
//
//  Created by Kirill Sidorov on 24.08.2021.
//

import UIKit

final class ProductDetailPresentationController: UIPresentationController {
    private let blurEffectView: UIVisualEffectView?
    private var tapGesture = UITapGestureRecognizer()
    
    override init(presentedViewController: UIViewController, presenting presentingViewController: UIViewController?) {
        let blurEffect = UIBlurEffect(style: .dark)
        blurEffectView = UIVisualEffectView(effect: blurEffect)
        super.init(presentedViewController: presentedViewController, presenting: presentingViewController)
        tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissController))
        blurEffectView?.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        blurEffectView?.isUserInteractionEnabled = true
        blurEffectView?.addGestureRecognizer(tapGesture)
    }
    
    override var frameOfPresentedViewInContainerView: CGRect {
        guard let frame = containerView?.frame else { return CGRect() }
        return CGRect(
            origin: CGPoint(
                x: 0,
                y: (frame.height) * 0.7
            ),
            size: CGSize(
                width: (frame.width),
                height: (frame.height) * 0.4)
        )
    }
    
    override func presentationTransitionWillBegin() {
        guard let blurEffectView = blurEffectView else { return }
        blurEffectView.alpha = 0
        containerView?.addSubview(blurEffectView)
        presentedViewController.transitionCoordinator?.animate(alongsideTransition: { [weak self] _ in
            self?.blurEffectView?.alpha = 0.3
        })
    }
    
    override func dismissalTransitionWillBegin() {
        presentedViewController.transitionCoordinator?.animate(alongsideTransition: { [weak self] _ in
            self?.blurEffectView?.alpha = 0
        }, completion: { [weak self] _ in
            self?.blurEffectView?.removeFromSuperview()
        })
    }
    
    override func containerViewWillLayoutSubviews() {
        super.containerViewWillLayoutSubviews()
        presentedView?.roundCorners([.topLeft, .topRight], radius: 22)
    }
    
    override func containerViewDidLayoutSubviews() {
        super.containerViewDidLayoutSubviews()
        presentedView?.frame = frameOfPresentedViewInContainerView
        blurEffectView?.frame = containerView?.bounds ?? CGRect()
    }
    
    @objc private func dismissController() {
        presentedViewController.dismiss(animated: true)
    }
}
