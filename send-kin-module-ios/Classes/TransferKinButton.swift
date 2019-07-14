//
//  TransferKinButton.swift
//  SendKin
//
//  Created by Natan Rolnik on 11/07/19.
//

import UIKit

final class TransferButton: UIButton {
    override init(frame: CGRect) {
        super.init(frame: frame)

        let backgroundImage = UIImage.from(.white)
        setBackgroundImage(backgroundImage, for: .normal)
        setBackgroundImage(backgroundImage, for: .highlighted)
        layer.cornerRadius = 4
        layer.masksToBounds = true
        layer.borderWidth = 1
        layer.borderColor = KinUI.Colors.purple.cgColor
        tintColor = KinUI.Colors.purple
        titleLabel?.font = KinUI.Fonts.sailecMedium(size: 13)
        setTitle("Transfer Kin", for: .normal)
        setTitleColor(KinUI.Colors.purple, for: .normal)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override var intrinsicContentSize: CGSize {
        var size = super.intrinsicContentSize
        size.height += 12
        size.width += 12
        return size
    }
}
