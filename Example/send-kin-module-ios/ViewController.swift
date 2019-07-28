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
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }

        let button = appDelegate.sendKin.transferButton
        button.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(button)
        view.centerXAnchor.constraint(equalTo: button.centerXAnchor).isActive = true
        view.centerYAnchor.constraint(equalTo: button.centerYAnchor).isActive = true
    }
}
