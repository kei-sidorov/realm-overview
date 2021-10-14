//
//  UIView+RoundCorners.swift
//  RealmOverview
//
//  Created by Kirill Sidorov on 25.08.2021.
//

import UIKit

extension UIView {
    func roundCorners(
        _ corners: UIRectCorner,
        radius: CGFloat) {
            let path = UIBezierPath(
                roundedRect: bounds,
                byRoundingCorners: corners,
                cornerRadii: CGSize(width: radius, height: radius)
            )
            let mask = CAShapeLayer()
            mask.path = path.cgPath
            layer.mask = mask
        }
}
