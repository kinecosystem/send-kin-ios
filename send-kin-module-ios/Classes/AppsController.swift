//
//  Networking.swift
//  Pods-send-kin-module-ios_Example
//
//  Created by Natan Rolnik on 30/06/19.
//

import Foundation

private struct AppResponse: Codable {
    let version: Int
    let apps: [App]
}

enum NetworkingError: Error {
    case internalInconsistency
    case noData
    case underlying(Error)
    case invalidStatusCode(Int)
}

class AppsController {
    let urlSession = URLSession(configuration: .default)
    let baseURL: URL
    let fileManager = FileManager.default

    var cacheURL: URL {
        return fileManager.urls(for: .cachesDirectory,
                                        in: .userDomainMask)[0]
            .appendingPathComponent("KinSendModule")
    }

    var appsResponseCacheURL: URL {
        return cacheURL.appendingPathComponent("AppsResponse.json")
    }

    init(baseURL: URL) {
        self.baseURL = baseURL

        if !fileManager.fileExists(atPath: cacheURL.path) {
            try? fileManager.createDirectory(at: cacheURL, withIntermediateDirectories: true, attributes: nil)
        }
    }

    public func getApps(completion: @escaping (Result<[App], NetworkingError>) -> Void) {
        guard
            let data = fileManager.contents(atPath: appsResponseCacheURL.path),
            let cachedResponse = try? JSONDecoder().decode(AppResponse.self, from: data) else {
            fetchAppsFromRemote(completion: completion)
            return
        }

        completion(.success(cachedResponse.apps))
        fetchAppsFromRemote(completion: completion, currentVersion: cachedResponse.version)
    }

    private func fetchAppsFromRemote(completion: @escaping (Result<[App], NetworkingError>) -> Void, currentVersion: Int? = nil) {
        urlSession.dataTask(with: baseURL.appendingPathComponent("iOS.json")) { data, response, error in
            func callCompletionOnMain(_ result: Result<[App], NetworkingError>) {
                DispatchQueue.main.async {
                    completion(result)
                }
            }

            if let error = error {
                DispatchQueue.main.async {
                    callCompletionOnMain(.failure(.underlying(error)))
                }
                return
            }

            guard let response = response as? HTTPURLResponse else {
                callCompletionOnMain(.failure(.internalInconsistency))
                return
            }

            guard let data = data else {
                callCompletionOnMain(.failure(.noData))
                return
            }

            guard (200..<300).contains(response.statusCode) else {
                callCompletionOnMain(.failure(.invalidStatusCode(response.statusCode)))
                return
            }

            do {
                let appsResponse = try JSONDecoder().decode(AppResponse.self, from: data)

                if appsResponse.version != currentVersion {
                    callCompletionOnMain(.success(appsResponse.apps))
                    try? data.write(to: self.appsResponseCacheURL)
                }
            } catch {
                callCompletionOnMain(.failure(.underlying(error)))
            }
        }.resume()
    }
}
