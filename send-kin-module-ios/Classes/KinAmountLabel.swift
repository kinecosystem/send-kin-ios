//
//  KinAmountLabel.swift
//  Kinit
//

import UIKit

enum AmountLabelSize: Int {
    case small = 16
    case large = 56
}

class KinAmountFormatter: NumberFormatter {
    override init() {
        super.init()

        locale = Locale.current
        usesGroupingSeparator = true
        numberStyle = .decimal
        maximumFractionDigits = 0
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class KinAmountLabel: UILabel {
    static let amountFormatter = KinAmountFormatter()

    var size = AmountLabelSize.small {
        didSet {
            if oldValue != size {
                renderAmount()
            }
        }
    }

    var isBold = true {
        didSet {
            if oldValue != isBold {
                renderAmount()
            }
        }
    }

    var amount: UInt64 = 0 {
        didSet {
            renderAmount()
        }
    }

    private func attributedPrefix() -> NSAttributedString? {
        let kFontSize = floor(CGFloat(size.rawValue) * 0.42)
        let kFont = KinUI.Fonts.kinK(size: kFontSize)

        return NSAttributedString(string: "K ", attributes: [.font: kFont, .baselineOffset: Int(size.rawValue/6)])
    }

    private func renderAmount() {
        let attributedBalance = self.attributedNumber(self.amount)
        let attributedText = NSMutableAttributedString()

        if let prefix = attributedPrefix() {
            attributedText.append(prefix)
        }

        attributedText.append(attributedBalance)

        self.attributedText = attributedText
    }

    private func attributedNumber(_ amount: UInt64) -> NSAttributedString {
        let fontSize = CGFloat(size.rawValue)
        let formattedAmount = KinAmountLabel.amountFormatter.string(from: NSNumber(value: amount))
        let amountString = formattedAmount ?? String(amount)
        return NSAttributedString(string: amountString, attributes: [.font: font(size: fontSize)])
    }

    private func font(size: CGFloat) -> UIFont {
        if isBold {
            return KinUI.Fonts.sailecBold(size: size)
        }

        return KinUI.Fonts.sailecMedium(size: size)
    }
}
