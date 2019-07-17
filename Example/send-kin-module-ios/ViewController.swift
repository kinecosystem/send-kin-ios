//
//  ViewController.swift
//  send-kin-module-ios
//
//  Created by natanrolnik on 06/30/2019.
//  Copyright (c) 2019 natanrolnik. All rights reserved.
//

import UIKit
import SendKin

class ViewController: UIViewController {
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        setupSendKin()
    }

    func setupSendKin() {
        sendKin.delegate = self
        let button = sendKin.transferButton
        button.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(button)
        view.centerXAnchor.constraint(equalTo: button.centerXAnchor).isActive = true
        view.centerYAnchor.constraint(equalTo: button.centerYAnchor).isActive = true
    }
}

extension ViewController: SendKinFlowDelegate {
    func sendKin(amount: UInt64, to address: String, memo: String, completion: @escaping (Result<Void, Error>) -> Void) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 4) {
            if Int.random(in: 0...100) < 10 {
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
}
