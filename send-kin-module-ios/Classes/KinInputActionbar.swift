//
//  KinInputActionbar.swift
//  SendKin
//
//  Created by Natan Rolnik on 08/07/19.
//

import UIKit

private let actionBarContentHeight: CGFloat = 72

protocol KinInputActionBarDelegate: class {
    func kinInputActionBarDidTap()
}

final class KinInputActionBar: UIView {
    private let actionButton: UIButton
    weak var delegate: KinInputActionBarDelegate?
    private let style: KinInputActionBarStyle

    var isEnabled: Bool {
        get {
            return actionButton.isEnabled && !actionButton.isHidden
        }
        set {
            actionButton.isEnabled = newValue
            backgroundColor = newValue ? style.backgroundColor : style.disabledBackgroundColor
        }
    }

    init(title: String, style: KinInputActionBarStyle = .default) {
        self.style = style

        actionButton = UIButton(type: .system)
        actionButton.setTitle(title, for: .normal)
        actionButton.setBackgroundImage(.from(style.backgroundColor), for: .normal)
        actionButton.setBackgroundImage(.from(style.disabledBackgroundColor), for: .disabled)
        actionButton.setTitleColor(style.textColor, for: .normal)
        actionButton.setTitleColor(style.disabledTextColor, for: .disabled)
        actionButton.titleLabel?.font = style.font

        super.init(frame: .zero)

        addAndFit(actionButton, layoutReference: .safeArea)

        self.backgroundColor = style.backgroundColor
        actionButton.addTarget(self, action: #selector(actionButtonTapped), for: .primaryActionTriggered)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override var intrinsicContentSize: CGSize {
        var bottomInset: CGFloat = 0

        if #available(iOS 11.0, *) {
            bottomInset = UIApplication.shared.keyWindow?.safeAreaInsets.bottom ?? 0
        }

        return CGSize(width: UIView.noIntrinsicMetric,
                      height: actionBarContentHeight + bottomInset)
    }

    @objc func actionButtonTapped() {
        delegate?.kinInputActionBarDidTap()
    }
}
