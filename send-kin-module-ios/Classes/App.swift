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

        enum CodingKeys: String, CodingKey {
            case appName = "app_name"
            case url = "app_url"
            case iconURL = "icon_url"
        }
    }

    struct TransferData: Codable {
        let urlScheme: String
        let sendEnabled: String?

        enum CodingKeys: String, CodingKey {
            case urlScheme = "url_scheme"
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
    var urlScheme: String? {
        return transferData?.urlScheme
    }

    var bundleId: String {
        return identifier
    }

    var name: String {
        return metadata.appName
    }
}
