//
//  App.swift
//  Pods-send-kin-module-ios_Example
//
//  Created by Natan Rolnik on 01/07/19.
//

import Foundation

public struct App: Codable {
    struct Metadata: Codable {
        let appName: String
        let url: URL
        let iconURL: URL
        let urlScheme: String = ""
        let bundleId: String = ""

        enum CodingKeys: String, CodingKey {
            case appName = "app_name"
            case url = "app_url"
            case iconURL = "icon_url"
            case urlScheme = "url_scheme"
            case bundleId = "bundle_id"
        }
    }

    struct TransferData: Codable {
        let launchActivity: String
        let sendEnabled: String?

        enum CodingKeys: String, CodingKey {
            case launchActivity = "launch_activity"
            case sendEnabled = "send_enabled"
        }
    }

    let identifier: String
    let memo: String
    let metadata: Metadata
    let transferData: TransferData?

    enum CodingKeys: String, CodingKey {
        case identifier
        case memo
        case metadata = "meta_data"
        case transferData = "transfer_data"
    }
}

extension App: Equatable {
    public static func ==(lhs: App, rhs: App) -> Bool {
        return lhs.identifier == rhs.identifier
    }
}

extension App {
    var urlScheme: String {
        return "sendkin-receiver" //metadata.urlScheme
    }

    var bundleId: String {
        return "org.kinecosystem.kinReceiver" //metadata.bundleId
    }

    var name: String {
        return metadata.appName
    }
}
