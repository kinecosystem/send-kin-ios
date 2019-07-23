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
        // Override point for customization after application launch.
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

extension UIViewController {
    var sendKin: SendKin {
        return (UIApplication.shared.delegate as! AppDelegate).sendKin
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
