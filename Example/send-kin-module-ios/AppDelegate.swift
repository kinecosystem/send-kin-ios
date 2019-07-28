//
//  AppDelegate.swift
//  send-kin-module-ios
//
//  Created by natanrolnik on 06/30/2019.
//  Copyright (c) 2019 natanrolnik. All rights reserved.
//

import UIKit
import SendKin

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    let sendKin = SendKin()

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        sendKin.delegate = self

        return true
    }

    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {

        if sendKin.canHandleURL(url) {
            let sourceAppBundleId = (options[.sourceApplication] as? String) ?? ""
            sendKin.handleURL(url, from: sourceAppBundleId, receiveDelegate: self)
        }

        return true
    }
}

extension AppDelegate: ReceiveKinFlowDelegate {
    func handlePossibleIncomingTransaction(senderAppName: String,
                                           senderAppId: String,
                                           memo: String) {
        //here, your app should let your server know that a possible
        //incoming transaction might happen, so transaction history
        //gets updated accordingly
    }

    func provideUserAddress(addressHandler: @escaping (String?) -> Void) {
        addressHandler("GBI3QOSGYTHN7FJ724NGDB4CYFQO645HCZ7RZBWX5PFIA6SPJCXY26UF")
    }
}

extension AppDelegate: SendKinFlowDelegate {
    func sendKin(amount: UInt64, to receiverAddress: String, receiverApp: App, memo: String, completion: @escaping (Result<Void, Error>) -> Void) {
        //Here, call

        DispatchQueue.main.asyncAfter(deadline: .now() + 4) {
            if Int.random(in: 0...10) < 8 {
                completion(.success(()))
            } else {
                enum AnyError: Error { case some }
                completion(.failure(AnyError.some))
            }
        }
    }

    var balance: UInt64 {
        return 2500
    }

    var kinAppId: String {
        return "sksd"
    }
}
