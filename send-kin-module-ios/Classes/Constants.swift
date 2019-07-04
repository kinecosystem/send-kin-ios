//
//  Constants.swift
//  SendKin
//
//  Created by Natan Rolnik on 04/07/19.
//

import Foundation

internal struct Constants {
    static let urlHost = "org.kinecosystem.send-kin"
    static let requestAddressURLPath = "/request-address"
    static let callerAppNameQueryItem = "appName"
    static let callerAppURLSchemeQueryItem = "urlScheme"

    static let receiveAddressURLPath = "/receive-address"
    static let receiveAddressQueryItem = "address"
    static let receiveAddressStatusQueryItem = "status"
    static let receiveAddressStatusOk = "ok"
    static let receiveAddressStatusCancelled = "cancelled"
    static let receiveAddressStatusNoAccount = "no-account"
    static let receiveAddressStatusInvalid = "invalid-params"

    static let didBecomeActiveTimeout: TimeInterval = 1
}
