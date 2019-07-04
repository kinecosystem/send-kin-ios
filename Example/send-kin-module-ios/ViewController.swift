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
        let button = UIButton(type: .system)
        button.setTitle("Transfer Kin", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(startSendKin), for: .primaryActionTriggered)
        view.addSubview(button)
        view.centerXAnchor.constraint(equalTo: button.centerXAnchor).isActive = true
        view.centerYAnchor.constraint(equalTo: button.centerYAnchor).isActive = true
    }

    @objc func startSendKin() {
        KinSendModule.start(with: self)
    }
}

extension ViewController: SendKinFlowDelegate {
    func sendKin(amount: UInt, to address: String, app: App, completion: @escaping (Bool) -> Void) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 4) {
            completion(true)
        }
    }
}
