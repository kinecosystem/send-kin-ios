//
//  TransferErrorView.swift
//  SendKin
//
//  Created by Natan Rolnik on 14/07/19.
//

import UIKit

protocol TransferFailedViewDelegate: class {
    func transferFailedViewDidTapClose(_ transferFailedView: TransferFailedView)
}

class TransferFailedView: UIView {
    let error: Error
    weak var delegate: TransferFailedViewDelegate?

    init(error: Error, delegate: TransferFailedViewDelegate) {
        self.error = error
        self.delegate = delegate

        super.init(frame: .zero)

        setupSubviews()
        backgroundColor = KinUI.Colors.darkGray
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setupSubviews() {
        let errorImage = UIImage(named: "ErrorIcon", in: Bundle(for: SendKinDoneView.self), compatibleWith: nil)
        let errorImageView = UIImageView(image: errorImage)
        errorImageView.setContentHuggingPriority(.defaultHigh, for: .horizontal)

        let label = UILabel()
        label.text = "Transfer failed, try again later"
        label.font = KinUI.Fonts.sailec(size: 14)
        label.textColor = KinUI.Colors.white
        label.setContentHuggingPriority(.defaultLow, for: .horizontal)

        let closeButton = UIButton(type: .custom)
        closeButton.addTarget(self, action: #selector(closeTapped), for: .primaryActionTriggered)
        closeButton.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        closeButton.tintColor = KinUI.Colors.white
        let closeImage = UIImage(named: "CloseButton", in: Bundle(for: SendKinDoneView.self), compatibleWith: nil)?
            .withRenderingMode(.alwaysTemplate)
        closeButton.setImage(closeImage, for: .normal)

        let stackView = UIStackView(arrangedSubviews: [errorImageView, label, closeButton])
        stackView.spacing = 20
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.alignment = .center
        stackView.axis = .horizontal

        addSubview(stackView)

        NSLayoutConstraint.activate([
            topAnchor.constraint(equalTo: stackView.topAnchor),
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 24),
            trailingAnchor.constraint(equalTo: stackView.trailingAnchor, constant: 24),
            safeBottomAnchor.constraint(equalTo: stackView.bottomAnchor)
            ])
    }

    @objc private func closeTapped() {
        delegate?.transferFailedViewDidTapClose(self)
    }
}
