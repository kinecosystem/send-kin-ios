//
//  With.swift
//  SendKin
//
//  Created by Natan Rolnik on 07/07/19.
//

import Foundation

@discardableResult
public func with<T>(_ value: T, _ builder: (T) -> Void) -> T {
    builder(value)
    return value
}

@discardableResult
public func with<T>(_ value: T, _ builder: (T) throws -> Void ) rethrows -> T {
    try builder(value)
    return value
}
