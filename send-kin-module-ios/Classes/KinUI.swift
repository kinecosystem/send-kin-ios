//
//  KinUI.swift
//  Pods-send-kin-module-ios_Example
//
//  Created by Natan Rolnik on 02/07/19.
//

import UIKit

public enum KinUI {
    enum Colors {
        static let white = UIColor.white
        static let veryLightGray = UIColor(red: 0.97, green: 0.97, blue: 0.97, alpha: 1.00)
        static let gray = UIColor(red: 0.65, green: 0.65, blue: 0.65, alpha: 1.00)
        static let darkGray = UIColor(red: 0.29, green: 0.29, blue: 0.29, alpha: 1.00)
        static let black = UIColor(red: 0.12, green: 0.12, blue: 0.12, alpha: 1.00)
        static let purple = UIColor(red: 0.43, green: 0.26, blue: 0.91, alpha: 1.00)
    }

    enum Fonts {
        static func sailec(size: CGFloat) -> UIFont {
            return fontNamed("Sailec", fileExtension: "otf", family: "Sailec", size: size)
        }

        static func sailecMedium(size: CGFloat) -> UIFont {
            return fontNamed("Sailec-Medium", fileExtension: "otf", family: "Sailec", size: size)
        }

        static func sailecBold(size: CGFloat) -> UIFont {
            return fontNamed("Sailec-Bold", fileExtension: "otf", family: "Sailec", size: size)
        }

        static func kinK(size: CGFloat) -> UIFont {
            return fontNamed("Kin_k", fileExtension: "ttf", family: "Kin_k", size: size)
        }

        static private func fontNamed(_ name: String, fileExtension: String, family: String, size: CGFloat) -> UIFont {
            if !UIFont.fontNames(forFamilyName: family).contains(name) {
                let bundle = Bundle(for: UIBundleToken.self)
                let url = bundle
                    .bundleURL
                    .appendingPathComponent("SendKin.bundle")
                    .appendingPathComponent("\(name).\(fileExtension)")
                CTFontManagerRegisterFontsForURL(url as CFURL, .process, nil)
            }

            return UIFont(name: name, size: size)!
        }
    }
}

private final class UIBundleToken {}
