//
//  SendKinTypes.swift
//  SendKin
//
//  Created by Natan Rolnik on 04/07/19.
//

import Foundation

public protocol SendKinFlowDelegate: class {
    func sendKin(amount: UInt64, to address: String, app: App, completion: @escaping (Result<Void, Error>) -> Void)
    var balance: UInt64 { get }
}

public protocol ReceiveKinFlowDelegate: class {
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
