//
//  SendKinNavigationBar.swift
//  SendKin
//
//  Created by Natan Rolnik on 07/07/19.
//

import UIKit

class SendKinNavigationBar: UINavigationBar {
    override init(frame: CGRect) {
        super.init(frame: frame)

        commonInit()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)

        commonInit()
    }

    func commonInit() {
        tintColor = KinUI.Colors.black
        titleTextAttributes = [.foregroundColor: KinUI.Colors.black,
                               .font: KinUI.Fonts.sailec(size: 18)]
    }
}
