//
//  KinUI.swift
//  Pods-send-kin-module-ios_Example
//
//  Created by Natan Rolnik on 02/07/19.
//

import UIKit

public enum KinUI {
    static let bundle = Bundle(for: UIBundleToken.self)

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
            return font(named: "Sailec", fileExtension: "otf", family: "Sailec", size: size)
        }

        static func sailecMedium(size: CGFloat) -> UIFont {
            return font(named: "Sailec-Medium", fileExtension: "otf", family: "Sailec", size: size)
        }

        static func sailecBold(size: CGFloat) -> UIFont {
            return font(named: "Sailec-Bold", fileExtension: "otf", family: "Sailec", size: size)
        }

        static func kinK(size: CGFloat) -> UIFont {
            return font(named: "Kin_k", fileExtension: "ttf", family: "Kin_k", size: size)
        }

        static private func font(named name: String, fileExtension: String, family: String, size: CGFloat) -> UIFont {
            if !UIFont.fontNames(forFamilyName: family).contains(name) {
                let url = bundle
                    .bundleURL
                    .appendingPathComponent("SendKin.bundle")
                    .appendingPathComponent("\(name).\(fileExtension)")
                CTFontManagerRegisterFontsForURL(url as CFURL, .process, nil)
            }

            return UIFont(name: name, size: size)!
        }
    }

    static func image(named name: String) -> UIImage? {
        if let image = UIImage(named: name, in: bundle, compatibleWith: nil) {
            return image
        }

        let url = bundle
            .bundleURL
            .appendingPathComponent("SendKin.bundle")

        if
            let rBundle = Bundle(url: url),
            let image = UIImage(named: name, in: rBundle, compatibleWith: nil) {
            return image
        }

        return nil
    }
}

private final class UIBundleToken {}
