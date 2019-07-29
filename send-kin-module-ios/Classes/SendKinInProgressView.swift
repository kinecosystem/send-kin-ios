//
//  SendKinInProgressView.swift
//  SendKin
//
//  Created by Natan Rolnik on 11/07/19.
//

import UIKit

private let progressViewWidth: CGFloat = 66
private let progressPillWidth: CGFloat = 8

class SendKinInProgressView: UIView {
    let thisAppIconURL: URL?
    let destinationAppIconURL: URL
    let destinationAppName: String
    let amount: UInt64

    private var isAnimating = false

    let progressView = with(UIView()) {
        $0.clipsToBounds = true
        $0.backgroundColor = KinUI.Colors.gray
        $0.widthAnchor.constraint(equalToConstant: progressViewWidth).isActive = true
        $0.heightAnchor.constraint(equalToConstant: 2).isActive = true
    }

    let progressPill = with(UIView()) {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.backgroundColor = KinUI.Colors.white
        $0.widthAnchor.constraint(equalToConstant: progressPillWidth).isActive = true
        $0.layer.cornerRadius = 1
        $0.transform = .init(translationX: -progressPillWidth, y: 0)
    }

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

        progressView.addSubview(progressPill)
        progressPill.heightAnchor.constraint(equalTo: progressView.heightAnchor).isActive = true
        progressPill.leadingAnchor.constraint(equalTo: progressView.leadingAnchor).isActive = true

        let stackView = UIStackView(arrangedSubviews: [thisAppIcon, progressView, destinationAppIcon])
        stackView.distribution = .fill
        stackView.alignment = .center
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal

        return stackView
    }

    func startAnimating() {
        isAnimating = true
        moveProgressView()
    }

    func stopAnimating() {
        isAnimating = false
        progressPill.layer.removeAllAnimations()
    }

    func moveProgressView() {
        guard isAnimating else {
            return
        }

        progressPill.transform = .init(translationX: -progressPillWidth, y: 0)

        UIView.animate(withDuration: 0.8, animations: { [weak self] in
            self?.progressPill.transform = .init(translationX: progressViewWidth, y: 0)
            }, completion: { [weak self] _ in
                self?.moveProgressView()
        })
    }
}
