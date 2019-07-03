//
//  AppCell.swift
//  Pods-send-kin-module-ios_Example
//
//  Created by Natan Rolnik on 02/07/19.
//

import UIKit

class AppCell: UITableViewCell {
    static let reuseIdentifier = "AppCell"
    var iconURL: URL?
    let iconImageView = UIImageView()
    let nameLabel = UILabel()
    let subtitleLabel = UILabel()

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        commonInit()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func commonInit() {
        nameLabel.textColor = KinUI.Colors.black
        nameLabel.font = KinUI.Fonts.sailec(size: 16)

        subtitleLabel.textColor = KinUI.Colors.gray
        subtitleLabel.font = KinUI.Fonts.sailec(size: 12)

        iconImageView.translatesAutoresizingMaskIntoConstraints = false

        let stackView = UIStackView(arrangedSubviews: [nameLabel, subtitleLabel])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.distribution = .fillProportionally
        stackView.spacing = 8

        contentView.addSubview(iconImageView)
        contentView.addSubview(stackView)

        NSLayoutConstraint.activate([
            iconImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 18),
            iconImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            iconImageView.widthAnchor.constraint(equalToConstant: 52),
            iconImageView.heightAnchor.constraint(equalToConstant: 52),
            stackView.leadingAnchor.constraint(equalTo: iconImageView.trailingAnchor, constant: 12),
            stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -18),
            stackView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
            ])
    }
}

class AppCellFactory {
    class func setupCell(_ cell: AppCell, app: App) {
        cell.nameLabel.text = app.metadata.appName
        ImageLoader.loadImage(at: app.metadata.iconURL, for: cell.iconImageView)

        if app.transferData?.sendEnabled == "true" {
            cell.subtitleLabel.isHidden = true
        } else {
            cell.subtitleLabel.isHidden = false
            cell.subtitleLabel.text = "Coming soon"
        }
    }
}
