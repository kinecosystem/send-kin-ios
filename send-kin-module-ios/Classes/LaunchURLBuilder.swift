//
//  LaunchURLBuilder.swift
//  SendKin
//
//  Created by Natan Rolnik on 04/07/19.
//

import Foundation

class LaunchURLBuilder {
    static func requestAddressURL(for app: App, memo: String) -> URL? {
        guard let urlScheme = app.urlScheme, !urlScheme.isEmpty else {
            return nil
        }

        guard let appURLScheme = Bundle.firstAppURLScheme else {
            let message =
            """
            MoveKin couldn't find a URL scheme to be used to launch this app back and receive data from \(app.name)".
            Add a URL scheme to this app's info.plist and try again.
            """

            fatalError(message)
        }

        var components = URLComponents.moveKin(scheme: urlScheme, path: Constants.requestAddressURLPath)
        components.queryItems = [URLQueryItem(name: Constants.callerAppNameQueryItem, value: Bundle.appName),
                                 URLQueryItem(name: Constants.callerAppURLSchemeQueryItem, value: appURLScheme),
                                 URLQueryItem(name: Constants.callerAppFutureMemoQueryItem, value: memo)]

        return components.url
    }

    static func provideAddressURL(address: String, urlScheme: String) -> URL {
        var components = URLComponents.moveKin(scheme: urlScheme, path: Constants.receiveAddressURLPath)
        components.queryItems = [URLQueryItem(name: Constants.receiveAddressQueryItem,
                                              value: address),
                                 URLQueryItem(name: Constants.receiveAddressStatusQueryItem,
                                              value: Constants.receiveAddressStatusOk)]

        return components.url!
    }

    static func provideAddressCancelledURL(urlScheme: String) -> URL {
        var urlComponents = URLComponents.moveKin(scheme: urlScheme, path: Constants.receiveAddressURLPath)
        urlComponents.queryItems = [URLQueryItem(name: Constants.receiveAddressStatusQueryItem,
                                                 value: Constants.receiveAddressStatusCancelled)]

        return urlComponents.url!
    }

    static func provideAddressInvalidURL(urlScheme: String) -> URL {
        var urlComponents = URLComponents.moveKin(scheme: urlScheme, path: Constants.receiveAddressURLPath)
        urlComponents.queryItems = [URLQueryItem(name: Constants.receiveAddressStatusQueryItem,
                                                 value: Constants.receiveAddressStatusInvalid)]

        return urlComponents.url!
    }

    static func provideAddressNoAccount(urlScheme: String) -> URL {
        var urlComponents = URLComponents.moveKin(scheme: urlScheme, path: Constants.receiveAddressURLPath)
        urlComponents.queryItems = [URLQueryItem(name: Constants.receiveAddressStatusQueryItem,
                                                 value: Constants.receiveAddressStatusNoAccount)]

        return urlComponents.url!
    }
}

private extension URLComponents {
    static func moveKin(scheme: String, path: String) -> URLComponents {
        var components = URLComponents()
        components.scheme = scheme
        components.host = Constants.urlHost
        components.path = path

        return components
    }
}
