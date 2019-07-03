//
//  UILabel+Extensions.swift
//  Pods-send-kin-module-ios_Example
//
//  Created by Natan Rolnik on 02/07/19.
//

extension UILabel {
    func setTextApplyingLineSpacing(_ text: String, spacing: CGFloat = 4) {
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = spacing
        paragraphStyle.alignment = textAlignment
        attributedText = NSAttributedString(string: text, attributes: [.paragraphStyle: paragraphStyle])
    }

    func applyLineSpacing(_ spacing: CGFloat = 4) {
        guard let text = text else {
            return
        }

        setTextApplyingLineSpacing(text, spacing: spacing)
    }
}
