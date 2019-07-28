//
//  SendKinTypes.swift
//  SendKin
//
//  Created by Natan Rolnik on 04/07/19.
//

import Foundation

public protocol SendKinFlowDelegate: class {
    func sendKin(amount: UInt64, to receiverAddress: String, receiverApp: App, memo: String, completion: @escaping (Result<Void, Error>) -> Void)
    var balance: UInt64 { get }
    var kinAppId: String { get }
}

public protocol ReceiveKinFlowDelegate: class {
    func handlePossibleIncomingTransaction(senderAppName: String, senderAppId: String, memo: String)
    func provideUserAddress(addressHandler: @escaping (String?) -> Void)
}

public typealias PublicAddress = String

public struct GetAddressFlowTypes {
    public enum Result {
        case success(PublicAddress)
        case cancelled
        case error(Error)
    }

    public enum Error: Swift.Error {
        case invalidURLScheme
        case appLaunchFailed(App)
        case noAccount
        case bundleIdMismatch
        case cancelled
        case invalidHandleURL
        case invalidLaunchParameters
        case invalidAddress
        case timeout
    }

    public enum State {
        case idle
        case launchingApp
        case waitingForAddress(bundleId: String)
        case error(Error)
        case success(PublicAddress)
        case cancelled
    }
}

extension GetAddressFlowTypes.Error: Equatable {
    public static func == (lhs: GetAddressFlowTypes.Error, rhs: GetAddressFlowTypes.Error) -> Bool {
        switch (lhs, rhs) {
        case (.invalidURLScheme, .invalidURLScheme),
             (.bundleIdMismatch, .bundleIdMismatch),
             (.invalidHandleURL, .invalidHandleURL),
             (.invalidAddress, .invalidAddress),
             (.timeout, .timeout):
            return true
        case (.appLaunchFailed(let lApp), .appLaunchFailed(let rApp)):
            return lApp == rApp
        default:
            return false
        }
    }
}

extension GetAddressFlowTypes.State: Equatable {
    public static func == (lhs: GetAddressFlowTypes.State, rhs: GetAddressFlowTypes.State) -> Bool {
        switch (lhs, rhs) {
        case (.idle, .idle), (.launchingApp, .launchingApp), (.cancelled, .cancelled): return true
        case (.success(let la), .success(let ra)): return ra == la
        case (.waitingForAddress(let lb), .waitingForAddress(let rb)): return lb == rb
        case (.error(let le), .error(let re)): return le == re
        default: return false
        }
    }
}

extension GetAddressFlowTypes.State {
    var toResult: GetAddressFlowTypes.Result? {
        switch self {
        case .success(let address):
            return .success(address)
        case .error(let error):
            return .error(error)
        case .cancelled:
            return .cancelled
        case .idle, .launchingApp, .waitingForAddress:
            return nil
        }
    }
}

enum SendKinFlowError {
    case cancelled
    case noWalletInDestination
    case appNotInstalled
    case couldNotEstablishConnection
}

extension SendKinFlowError {
    func errorMessage(for appName: String) -> String? {
        switch self {
        case .appNotInstalled:
            return "In order to transfer Kin, \(appName) needs to be installed first."
        case .noWalletInDestination:
            return "To send Kin, first please log in to \(appName), then try again."
        case .couldNotEstablishConnection:
            return "We couldn't connect to \(appName). Please try again later."
        case .cancelled:
            return nil
        }
    }
}

extension GetAddressFlowTypes.Error {
    var toSendKinFlowError: SendKinFlowError? {
        switch self {
        case .bundleIdMismatch,
             .invalidAddress,
             .invalidHandleURL,
             .invalidLaunchParameters,
             .invalidURLScheme,
             .timeout:
            return .couldNotEstablishConnection
        case .noAccount:
            return .noWalletInDestination
        case .appLaunchFailed:
            return .appNotInstalled
        case .cancelled: return nil
        }
    }
}
