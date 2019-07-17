//
//  SendKinFlow.swift
//  SendKin
//
//  Created by Natan Rolnik on 04/07/19.
//

import UIKit

public typealias GetAddressFlowCompletion = (GetAddressFlowTypes.Result) -> Void

class GetAddressFlow {
    private(set) var state = GetAddressFlowTypes.State.idle {
        didSet {
            if let result = state.toResult {
                completion?(result)
                completion = nil
                state = .idle
            }
        }
    }

    private var timeoutDispatchWorkItem: DispatchWorkItem?

    private var completion: GetAddressFlowCompletion?

    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    init() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(appDidBecomeActive),
                                               name: UIApplication.didBecomeActiveNotification,
                                               object: nil)
    }

    func startMoveKinFlow(to destinationApp: App, completion: @escaping GetAddressFlowCompletion) {
        self.completion = completion

        guard let url = LaunchURLBuilder.requestAddressURL(for: destinationApp) else {
            state = .error(.invalidURLScheme)
            return
        }

        let bundleId = destinationApp.bundleId
        state = .launchingApp

        func triedToLaunchApp(success: Bool) {
            guard success else {
                state = .error(.appLaunchFailed(destinationApp))
                return
            }

            state = .waitingForAddress(bundleId: bundleId)
        }

        if #available(iOS 10.0, *) {
            UIApplication.shared.open(url, completionHandler: triedToLaunchApp)
        } else {
            let success = UIApplication.shared.openURL(url)
            triedToLaunchApp(success: success)
        }
    }

    func canHandleURL(_ url: URL) -> Bool {
        guard url.host == Constants.urlHost, url.path == Constants.receiveAddressURLPath else {
            return false
        }

        return true
    }

    func handleURL(_ url: URL, from appBundleId: String) {
        timeoutDispatchWorkItem?.cancel()

        guard case let GetAddressFlowTypes.State.waitingForAddress(bundleId) = state else {
            return
        }

        guard bundleId == appBundleId else {
            state = .error(.bundleIdMismatch)
            return
        }

        do {
            let extractResult = try extractQueryItems(from: url)

            switch extractResult {
            case .address(let rawAddress):
                let address = try validateKinAddress(from: rawAddress)
                state = .success(address)
            case .badStatus(let status):
                setState(for: status)
            }
        } catch let error as GetAddressFlowTypes.Error {
            state = .error(error)
        } catch { }
    }

    private func setState(for invalidStatus: String) {
        switch invalidStatus {
        case Constants.receiveAddressStatusNoAccount: state = .error(.noAccount)
        case Constants.receiveAddressStatusCancelled: state = .cancelled
        case Constants.receiveAddressStatusInvalid: state = .error(.invalidLaunchParameters)
        default: state = .error(.invalidLaunchParameters)
        }
    }

    enum ExtractAddressResult {
        case badStatus(String)
        case address(String)
    }

    private func extractQueryItems(from url: URL) throws -> ExtractAddressResult {
        guard canHandleURL(url),
            let urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: false),
            let queryItems = urlComponents.queryItems,
            let statusQueryItem = queryItems.first(where: {
                $0.name == Constants.receiveAddressStatusQueryItem
            }),
            let status = statusQueryItem.value else {
                throw GetAddressFlowTypes.Error.invalidHandleURL
        }

        guard status == Constants.receiveAddressStatusOk else {
            return .badStatus(status)
        }

        let addressQueryItem = queryItems.first(where: { $0.name == Constants.receiveAddressQueryItem })

        guard let addressString = addressQueryItem?.value else {
            throw GetAddressFlowTypes.Error.invalidAddress
        }

        return .address(addressString)
    }

    private func validateKinAddress(from addressString: String) throws -> PublicAddress {
//        guard let publicAddress = PublicAddress(rawValue: addressString),
//            addressString == publicAddress.asString else {
//                throw GetAddressFlowTypes.Error.invalidAddress
//        }

        return addressString
    }

    @objc func appDidBecomeActive() {
        guard case GetAddressFlowTypes.State.waitingForAddress = state else {
            return
        }

        let item = DispatchWorkItem {
            self.state = .error(.timeout)
        }

        timeoutDispatchWorkItem = item
        DispatchQueue.main.asyncAfter(deadline: .now() + Constants.didBecomeActiveTimeout,
                                      execute: item)
    }
}
