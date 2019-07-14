//
//  UIView+Extensions.swift
//  SendKin
//
//  Created by Natan Rolnik on 07/07/19.
//

import UIKit

enum LayoutReference {
    case safeArea
    case superview
}

extension UIView {
    func addAndFit(_ subview: UIView, layoutReference: LayoutReference = .superview) {
        addSubview(subview)
        subview.fitInSuperview(with: layoutReference)
    }

    func addAndCenter(_ subview: UIView) {
        addSubview(subview)
        subview.centerInSuperview()
    }

    func fitInSuperview(with reference: LayoutReference = .superview) {
        guard let superview = superview else {
            print("fitInSuperview() called when superview is nil")
            return
        }

        translatesAutoresizingMaskIntoConstraints = false

        let g: UILayoutGuide?

        if #available(iOS 11.0, *) {
            g = reference == .safeArea ? superview.safeAreaLayoutGuide : nil
        } else {
            g = nil
        }

        leadingAnchor.constraint(equalTo: g?.leadingAnchor ?? superview.leadingAnchor).isActive = true
        topAnchor.constraint(equalTo: g?.topAnchor ?? superview.topAnchor).isActive = true
        trailingAnchor.constraint(equalTo: g?.trailingAnchor ?? superview.trailingAnchor).isActive = true
        bottomAnchor.constraint(equalTo: g?.bottomAnchor ?? superview.bottomAnchor).isActive = true
    }

    func centerInSuperview() {
        guard let superview = superview else {
            print("centerInSuperview() called when superview is nil")
            return
        }

        translatesAutoresizingMaskIntoConstraints = false

        centerXAnchor.constraint(equalTo: superview.centerXAnchor).isActive = true
        centerYAnchor.constraint(equalTo: superview.centerYAnchor).isActive = true
    }

    var safeBottomAnchor: NSLayoutYAxisAnchor {
        guard #available(iOS 11.0, *) else {
            return bottomAnchor
        }

        return safeAreaLayoutGuide.bottomAnchor
    }

    var safeTopAnchor: NSLayoutYAxisAnchor {
        guard #available(iOS 11.0, *) else {
            return topAnchor
        }

        return safeAreaLayoutGuide.topAnchor
    }
}
