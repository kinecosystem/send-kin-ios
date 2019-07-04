//
//  Bundle+Extensions.swift
//  SendKin
//
//  Created by Natan Rolnik on 04/07/19.
//

import Foundation

extension Bundle {
    static var appName: String? {
        return main.infoDictionary?["CFBundleDisplayName"] as? String
            ?? main.infoDictionary?["CFBundleName"] as? String
    }

    static var firstAppURLScheme: String? {
        guard let urlTypes = Bundle.main.infoDictionary?["CFBundleURLTypes"] as? [AnyObject],
            let urlTypesDictionary = urlTypes.first as? [String: AnyObject],
            let urlSchemes = urlTypesDictionary["CFBundleURLSchemes"] as? [String] else {
                return nil
        }

        return urlSchemes.first
    }
}
