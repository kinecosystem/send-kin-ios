//
//  ProvideAddressFlow.swift
//  SendKin
//
//  Created by Natan Rolnik on 04/07/19.
//

import UIKit

class ProvideAddressFlow {
    public init() {}

    private var presenter: UIViewController? {
        guard let appDelegate = UIApplication.shared.delegate,
            var viewController = appDelegate.window??.rootViewController else {
                return nil
        }

        while let presented = viewController.presentedViewController {
            viewController = presented
        }

        return viewController
    }

    func canHandleURL(_ url: URL) -> Bool {
        guard url.host == Constants.urlHost, url.path == Constants.requestAddressURLPath else {
            return false
        }

        return true
    }

    func handleURL(_ url: URL,
                   from appBundleId: String,
                   receiveDelegate: ReceiveKinFlowDelegate) {
        guard url.host == Constants.urlHost, url.path == Constants.requestAddressURLPath else {
            return
        }

        guard let urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: false),
            let queryItems = urlComponents.queryItems,
            let appURLScheme = queryItems.first(where: { $0.name == Constants.callerAppURLSchemeQueryItem })?.value,
            let memo = queryItems.first(where: { $0.name == Constants.callerAppFutureMemoQueryItem })?.value else {
                return
        }

        guard
            let appName = queryItems.first(where: { $0.name == Constants.callerAppNameQueryItem })?.value,
            let presenter = presenter else {
                let url = LaunchURLBuilder.provideAddressInvalidURL(urlScheme: appURLScheme)
                if #available(iOS 10.0, *) {
                    UIApplication.shared.open(url)
                } else {
                    UIApplication.shared.openURL(url)
                }
                return
        }

        receiveDelegate.handlePossibleIncomingTransaction(with: memo)

        let viewController = AcceptReceiveKinViewController()
        viewController.appName = appName
        viewController.cancelledBlock = { [unowned viewController] in
            viewController.dismiss(animated: true, completion: nil)
            ProvideAddressFlow.cancel(urlScheme: appURLScheme)
        }

        viewController.acceptedBlock = { [unowned viewController] in
            viewController.dismiss(animated: true, completion: nil)
            ProvideAddressFlow.accept(delegate: receiveDelegate, urlScheme: appURLScheme)
        }

        let navigationController = UINavigationController(navigationBarClass: SendKinNavigationBar.self,
                                                          toolbarClass: nil)
        navigationController.viewControllers = [viewController]
        presenter.present(navigationController, animated: false)
    }

    private static func cancel(urlScheme: String) {
        let url = LaunchURLBuilder.provideAddressCancelledURL(urlScheme: urlScheme)
        if #available(iOS 10.0, *) {
            UIApplication.shared.open(url)
        } else {
            UIApplication.shared.openURL(url)
        }
    }

    private static func accept(delegate: ReceiveKinFlowDelegate, urlScheme: String) {
        delegate.provideUserAddress { address in
            DispatchQueue.main.async {
                let url: URL

                if let address = address {
                    url = LaunchURLBuilder.provideAddressURL(address: address, urlScheme: urlScheme)
                } else {
                    url = LaunchURLBuilder.provideAddressNoAccount(urlScheme: urlScheme)
                }

                if #available(iOS 10.0, *) {
                    UIApplication.shared.open(url)
                } else {
                    UIApplication.shared.openURL(url)
                }
            }
        }
    }
}

