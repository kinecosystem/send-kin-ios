//
//  SendKinInputViewController.swift
//  SendKin
//
//  Created by Natan Rolnik on 07/07/19.
//

import UIKit

class SendKinInputViewController: UIViewController {
    weak var delegate: SendKinFlowDelegate?
    let destinationAddress: String
    let amountViewController = KinAmountInputViewController()
    let actionBar = KinInputActionBar(title: "Transfer Kin")
    let currentBalance: UInt64
    let destinationApp: App
    let thisAppIconURL: URL?

    let availableKinLabel = with(UILabel()) {
        $0.font = KinUI.Fonts.sailec(size: 16)
        $0.textColor = KinUI.Colors.black
        $0.text = "Total Kin Available"
    }

    let balanceLabel = with(KinAmountLabel()) {
        $0.isBold = false
        $0.textColor = KinUI.Colors.purple
        $0.size = .small
    }

    init(destinationAddress: String, destinationApp: App, thisAppIconURL: URL?, delegate: SendKinFlowDelegate) {
        self.destinationAddress = destinationAddress
        self.destinationApp = destinationApp
        self.delegate = delegate
        self.thisAppIconURL = thisAppIconURL
        currentBalance = delegate.balance
        balanceLabel.amount = UInt64(currentBalance)

        super.init(nibName: nil, bundle: nil)

        actionBar.isEnabled = false
        actionBar.delegate = self
        amountViewController.delegate = self
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func loadView() {
        view = UIView()
        view.backgroundColor = .white
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .stop,
                                                           target: self,
                                                           action: #selector(dismissAnimated))
        title = "Send Kin to \(destinationApp.name)"

        addActionBar()
        addAmountViewController()
        addBalanceLabel()
    }

    private func addActionBar() {
        actionBar.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(actionBar)
        NSLayoutConstraint.activate([
            view.leadingAnchor.constraint(equalTo: actionBar.leadingAnchor),
            view.trailingAnchor.constraint(equalTo: actionBar.trailingAnchor),
            view.bottomAnchor.constraint(equalTo: actionBar.bottomAnchor),
        ])
    }

    private func addAmountViewController() {
        guard let aView = amountViewController.view else {
            return
        }

        aView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(aView)
        addChild(amountViewController)
        amountViewController.didMove(toParent: self)

        NSLayoutConstraint.activate([
            aView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            aView.topAnchor.constraint(equalTo: view.topAnchor),
            aView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            actionBar.topAnchor.constraint(equalTo: aView.bottomAnchor)
            ])
    }

    private func addBalanceLabel() {
        let stackView = UIStackView(arrangedSubviews: [availableKinLabel, balanceLabel])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.spacing = 4
        stackView.axis = .horizontal
        stackView.alignment = .center
        view.addSubview(stackView)

        NSLayoutConstraint.activate([
            view.centerXAnchor.constraint(equalTo: stackView.centerXAnchor),
            amountViewController.keyboard.topAnchor.constraint(equalTo: stackView.bottomAnchor, constant: 42)
            ])
    }

    fileprivate func addAndAnimateView(_ aView: UIView) {
        view.addSubview(aView)

        actionBar.leadingAnchor.constraint(equalTo: aView.leadingAnchor).isActive = true
        actionBar.trailingAnchor.constraint(equalTo: aView.trailingAnchor).isActive = true
        actionBar.heightAnchor.constraint(equalTo: aView.heightAnchor).isActive = true
        let topConstraint = actionBar.bottomAnchor.constraint(equalTo: aView.topAnchor)
        topConstraint.isActive = true
        view.layoutIfNeeded()

        UIView.animate(withDuration: 0.2) {
            topConstraint.isActive = false
            self.actionBar.topAnchor.constraint(equalTo: aView.topAnchor).isActive = true
            self.view.layoutIfNeeded()
        }
    }

    fileprivate func animateOutAndRemoveView(_ aView: UIView) {
        let toDisable = view.constraints.first(where: {
            ($0.firstItem as? UIView) == actionBar
                && ($0.secondItem as? UIView) == aView
                && $0.secondAttribute == .top
                && $0.firstAttribute == .top
        })

        UIView.animate(withDuration: 0.2, animations: {
            toDisable?.isActive = false
            self.actionBar.bottomAnchor.constraint(equalTo: aView.topAnchor).isActive = true
            self.view.layoutIfNeeded()
        }, completion: { _ in
            aView.removeFromSuperview()
        })
    }

    fileprivate func transferSucceeded(amount: UInt64) {
        navigationItem.leftBarButtonItem?.isEnabled = true
        let sendKinDoneView = SendKinDoneView(amount: amount, destinationAppName: destinationApp.name, delegate: self)
        sendKinDoneView.translatesAutoresizingMaskIntoConstraints = false
        addAndAnimateView(sendKinDoneView)
    }

    fileprivate func transferFailed(error: Error) {
        if let transferInProgressView = view.subviews.first(where: { $0 is SendKinInProgressView}) {
            animateOutAndRemoveView(transferInProgressView)
        }

        let transferFailedView = TransferFailedView(error: error, delegate: self)
        transferFailedView.translatesAutoresizingMaskIntoConstraints = false
        addAndAnimateView(transferFailedView)
    }
}

extension SendKinInputViewController: KinAmountInputDelegate {
    func amountInputDidChange(_ amount: UInt64) {
        actionBar.isEnabled = amount > 0 && amount <= currentBalance
    }
}

extension SendKinInputViewController: KinInputActionBarDelegate {
    func kinInputActionBarDidTap() {
        amountViewController.isEnabled = false
        actionBar.isEnabled = false
        navigationItem.leftBarButtonItem?.isEnabled = false
        let amount = amountViewController.amount
        let progressView = SendKinInProgressView(thisAppIconURL: thisAppIconURL,
                                                 destinationAppIconURL: destinationApp.metadata.iconURL,
                                                 destinationAppName: destinationApp.name,
                                                 amount: amount)
        progressView.translatesAutoresizingMaskIntoConstraints = false
        addAndAnimateView(progressView)

        delegate?.sendKin(amount: amount, to: destinationAddress, app: destinationApp) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success: self?.transferSucceeded(amount: amount)
                case .failure(let error): self?.transferFailed(error: error)
                }
            }
        }
    }
}

extension SendKinInputViewController: SendKinDoneDelegate {
    func sendKinDoneDidTapClose() {
        dismissAnimated()
    }

    func sendKinDoneDidTapLaunchApp() {
        guard
            let urlScheme = destinationApp.urlScheme,
            !urlScheme.isEmpty,
            let url = URL(string: "\(urlScheme)://") else {
                dismissAnimated()
                return
        }

        if #available(iOS 10.0, *) {
            UIApplication.shared.open(url, completionHandler: nil)
        } else {
            UIApplication.shared.openURL(url)
        }

        dismiss(animated: false, completion: nil)
    }
}

extension SendKinInputViewController: TransferFailedViewDelegate {
    func transferFailedViewDidTapClose(_ transferFailedView: TransferFailedView) {
        actionBar.isEnabled = false
        amountViewController.isEnabled = true
        amountViewController.amount = 0
        navigationItem.leftBarButtonItem?.isEnabled = true

        animateOutAndRemoveView(transferFailedView)
    }
}
