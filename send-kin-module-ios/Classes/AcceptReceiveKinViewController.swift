//
//  AcceptReceiveKinViewController.swift
//  SendKin
//
//  Created by Natan Rolnik on 04/07/19.
//

import UIKit

class AcceptReceiveKinViewController: UIViewController {
    var appName = ""

    var acceptedBlock: (() -> Void)!
    var cancelledBlock: (() -> Void)!

    override func loadView() {
        view = UIView()
        view.backgroundColor = .white
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        setupSubviews()
        title = "Kin Ecosystem"
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .stop,
                                                           target: self,
                                                           action: #selector(cancel))
    }

    private func setupSubviews() {
        let kinImageView = UIImageView(image: UIImage(named: "KinEcosystemLogo",
                                                      in: Bundle(for: AcceptReceiveKinViewController.self),
                                                      compatibleWith: nil))
        let text = "In order to transfer Kin, \(appName) would like to receive your Kin account information (i.e. your public address and user ID) from \(Bundle.appName ?? "this app")."
        let transferLabel = UILabel()
        transferLabel.textAlignment = .center
        transferLabel.font = KinUI.Fonts.sailec(size: 16)
        transferLabel.setTextApplyingLineSpacing(text)
        transferLabel.numberOfLines = 0

        let button = UIButton(type: .custom)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setBackgroundImage(UIImage.from(KinUI.Colors.purple), for: .normal)
        button.layer.cornerRadius = 6
        button.layer.masksToBounds = true
        button.setTitle("I agree", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = KinUI.Fonts.sailecMedium(size: 16)
        button.addTarget(self, action: #selector(agreeTapped), for: .primaryActionTriggered)

        let stackView = UIStackView(arrangedSubviews: [kinImageView, transferLabel])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.spacing = 20

        view.addSubview(stackView)
        view.addSubview(button)

        let bottomAnchor: NSLayoutYAxisAnchor

        if #available(iOS 11.0, *) {
            bottomAnchor = view.safeAreaLayoutGuide.bottomAnchor
        } else {
            bottomAnchor = view.bottomAnchor
        }

        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 36),
            view.trailingAnchor.constraint(equalTo: stackView.trailingAnchor, constant: 36),
            stackView.topAnchor.constraint(greaterThanOrEqualTo: view.topAnchor, constant: 20),
            NSLayoutConstraint(item: stackView,
                               attribute: .centerY,
                               relatedBy: .equal,
                               toItem: view,
                               attribute: .centerY,
                               multiplier: 0.8,
                               constant: 0),
            button.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            button.heightAnchor.constraint(equalToConstant: 50),
            button.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.8),
            bottomAnchor.constraint(equalTo: button.bottomAnchor, constant: 42)
            ])
    }

    @objc private func cancel() {
        cancelledBlock()
    }

    @objc private func agreeTapped() {
        acceptedBlock()
    }
}
