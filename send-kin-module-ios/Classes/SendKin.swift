//
//  SendKin.swift
//  SendKin
//
//  Created by Natan Rolnik on 07/07/19.
//

import UIKit

public final class SendKin {
    private let provideAddressFlow = ProvideAddressFlow()
    private let getAddressFlow = GetAddressFlow()
    public weak var delegate: SendKinFlowDelegate?

    public init() {}

    public func start() {
        _start()
    }

    @objc private func _start(presenter: UIViewController? = nil) {
        guard let rootViewController = UIApplication.shared.keyWindow?.rootViewController else {
            return
        }

        guard let delegate = delegate else {
            print("SendKin received start but no delegate (SendKinFlowDelegate) was set in SendKin")
            return
        }

        let appListViewController = AppListViewController(getAddressFlow: getAddressFlow, sendKinDelegate: delegate)
        let navigationController = UINavigationController(navigationBarClass: SendKinNavigationBar.self,
                                                          toolbarClass: nil)
        navigationController.viewControllers = [appListViewController]

        var presenter = rootViewController
        while let nextPresenter = presenter.presentedViewController {
            presenter = nextPresenter
        }

        presenter.present(navigationController, animated: true)
    }

    public func canHandleURL(_ url: URL) -> Bool {
        return provideAddressFlow.canHandleURL(url) || getAddressFlow.canHandleURL(url)
    }

    private lazy var _transferButton: UIButton = {
        let b = TransferButton(type: .custom)
        b.addTarget(self, action: #selector(_start), for: .primaryActionTriggered)
        return b
    }()

    public var transferButton: UIView {
        return _transferButton
    }

    public func handleURL(_ url: URL,
                   from appBundleId: String,
                   receiveDelegate: ReceiveKinFlowDelegate) {
        if provideAddressFlow.canHandleURL(url) {
            provideAddressFlow.handleURL(url, from: appBundleId, receiveDelegate: receiveDelegate)
        } else if getAddressFlow.canHandleURL(url) {
            getAddressFlow.handleURL(url, from: appBundleId)
        }
    }
}
