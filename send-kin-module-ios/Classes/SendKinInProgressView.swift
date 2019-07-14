//
//  SendKinInProgressView.swift
//  SendKin
//
//  Created by Natan Rolnik on 11/07/19.
//

import UIKit

class SendKinInProgressView: UIView {
    let thisAppIconURL: URL?
    let destinationAppIconURL: URL
    let destinationAppName: String
    let amount: UInt64

    var text: String {
        let formattedAmount = KinAmountFormatter().string(from: .init(value: amount)) ?? String(describing: amount)
        return "Transferring \(formattedAmount) Kin to \(destinationAppName)"
    }

    init(thisAppIconURL: URL?, destinationAppIconURL: URL, destinationAppName: String, amount: UInt64) {
        self.thisAppIconURL = thisAppIconURL
        self.destinationAppIconURL = destinationAppIconURL
        self.destinationAppName = destinationAppName
        self.amount = amount

        super.init(frame: .zero)

        setupSubviews()
        backgroundColor = KinUI.Colors.darkGray
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupSubviews() {
        let mainStackView = UIStackView(arrangedSubviews: [descriptionLabel(), iconsStackView()])
        mainStackView.translatesAutoresizingMaskIntoConstraints = false
        mainStackView.spacing = 20
        mainStackView.axis = .horizontal
        mainStackView.alignment = .center

        addSubview(mainStackView)

        NSLayoutConstraint.activate([
            topAnchor.constraint(equalTo: mainStackView.topAnchor),
            mainStackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 24),
            trailingAnchor.constraint(equalTo: mainStackView.trailingAnchor, constant: 24),
            safeBottomAnchor.constraint(equalTo: mainStackView.bottomAnchor)
        ])
    }

    private func descriptionLabel() -> UILabel {
        return with(UILabel()) {
            $0.translatesAutoresizingMaskIntoConstraints = false
            $0.textColor = KinUI.Colors.white
            $0.font = KinUI.Fonts.sailecMedium(size: 16)
            $0.numberOfLines = 2
            $0.setTextApplyingLineSpacing(text)
            $0.textAlignment = .left
        }
    }

    private func iconsStackView() -> UIStackView {
        let thisAppIcon = UIImageView()
        let destinationAppIcon = UIImageView()

        [thisAppIcon, destinationAppIcon].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            $0.backgroundColor = .white
            $0.layer.cornerRadius = 6
            $0.widthAnchor.constraint(equalToConstant: 36).isActive = true
            $0.heightAnchor.constraint(equalToConstant: 36).isActive = true
        }

        if let thisAppIconURL = thisAppIconURL {
            ImageLoader.loadImage(at: thisAppIconURL, for: thisAppIcon)
        }

        ImageLoader.loadImage(at: destinationAppIconURL, for: destinationAppIcon)

        let progressView = UIView()
        progressView.backgroundColor = KinUI.Colors.purple
        progressView.widthAnchor.constraint(equalToConstant: 66).isActive = true
        progressView.heightAnchor.constraint(equalToConstant: 2).isActive = true

        let stackView = UIStackView(arrangedSubviews: [thisAppIcon, progressView, destinationAppIcon])
        stackView.distribution = .fill
        stackView.alignment = .center
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal

        return stackView
    }
}
