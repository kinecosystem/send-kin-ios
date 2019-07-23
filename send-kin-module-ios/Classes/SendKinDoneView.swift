//
//  SendKinDoneView.swift
//  SendKin
//
//  Created by Natan Rolnik on 11/07/19.
//

import UIKit

protocol SendKinDoneDelegate: class {
    func sendKinDoneDidTapClose()
    func sendKinDoneDidTapLaunchApp()
}

class SendKinDoneView: UIView {
    let amount: UInt64
    let destinationAppName: String
    weak var delegate: SendKinDoneDelegate?

    init(amount: UInt64, destinationAppName: String, delegate: SendKinDoneDelegate) {
        self.amount = amount
        self.destinationAppName = destinationAppName
        self.delegate = delegate

        super.init(frame: .zero)

        backgroundColor = KinUI.Colors.purple

        setupSubviews()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupSubviews() {
        let font = KinUI.Fonts.sailecMedium(size: 16)

        let textLabel = UILabel()
        let formattedAmount = KinAmountFormatter().string(from: .init(value: amount)) ?? String(describing: amount)
        textLabel.text = "You've successfully sent \(formattedAmount) Kin"
        textLabel.font = font
        textLabel.textColor = KinUI.Colors.white

        let launchAppButton = UIButton()
        launchAppButton.addTarget(self, action: #selector(launchTapped), for: .primaryActionTriggered)
        let attributedTitle = NSAttributedString(string: "go to \(destinationAppName)",
            attributes: [.font: font,
                         .underlineStyle: NSUnderlineStyle.single.rawValue,
                         .foregroundColor: KinUI.Colors.white])
        launchAppButton.setAttributedTitle(attributedTitle, for: .normal)

        let textStack = UIStackView(arrangedSubviews: [textLabel, launchAppButton])
        textStack.axis = .vertical
        textStack.alignment = .leading
        textStack.distribution = .fillEqually

        let closeButton = UIButton(type: .custom)
        closeButton.addTarget(self, action: #selector(closeTapped), for: .primaryActionTriggered)
        closeButton.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        closeButton.tintColor = KinUI.Colors.white
        let closeImage = KinUI.image(named: "CloseButton")?
            .withRenderingMode(.alwaysTemplate)
        closeButton.setImage(closeImage, for: .normal)

        let mainStack = UIStackView(arrangedSubviews: [textStack, closeButton])
        mainStack.translatesAutoresizingMaskIntoConstraints = false
        mainStack.alignment = .center
        mainStack.axis = .horizontal

        addSubview(mainStack)

        NSLayoutConstraint.activate([
            topAnchor.constraint(equalTo: mainStack.topAnchor),
            mainStack.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 24),
            trailingAnchor.constraint(equalTo: mainStack.trailingAnchor, constant: 24),
            safeBottomAnchor.constraint(equalTo: mainStack.bottomAnchor)
            ])
    }

    @objc private func closeTapped() {
        delegate?.sendKinDoneDidTapClose()
    }

    @objc private func launchTapped() {
        delegate?.sendKinDoneDidTapLaunchApp()
    }
}
