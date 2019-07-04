//
//  AppListViewController.swift
//  Pods-send-kin-module-ios_Example
//
//  Created by Natan Rolnik on 01/07/19.
//

import UIKit

public enum KinSendModule {
    public static func start(with delegate: SendKinFlowDelegate) {
        let appListViewController = AppListViewController()
        appListViewController.sendKinDelegate = delegate
        let navigationController = UINavigationController(rootViewController: appListViewController)
        navigationController.navigationBar.tintColor = KinUI.Colors.black
        navigationController.navigationBar.titleTextAttributes = [.foregroundColor: KinUI.Colors.black,
                                                                  .font: KinUI.Fonts.sailec(size: 18)]
        UIApplication.shared.keyWindow?.rootViewController?.present(navigationController, animated: true)
    }
}

extension UIViewController {
    @objc func dismissAnimated() {
        dismiss(animated: true)
    }
}

class AppListViewController: UIViewController {
    let tableView = UITableView()
    let getAddressFlow = GetAddressFlow()
    weak var sendKinDelegate: SendKinFlowDelegate?

    var apps = [App]()

    override public func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .red
        title = "Transfer Kin to"
        setupTableView()

        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .stop,
                                                           target: self,
                                                           action: #selector(dismissAnimated))
        let appController = AppsController(baseURL: URL(string: "https://discover.kin.org")!)
        appController.getApps { [weak self] result in
            switch result {
            case .success(let apps): self?.apps = apps
            case .failure(let error): print(error)
            }
            self?.tableView.reloadData()
        }
    }

    private func setupTableView() {
        tableView.separatorInset = .zero
        tableView.backgroundColor = KinUI.Colors.veryLightGray
        tableView.register(AppCell.self, forCellReuseIdentifier: AppCell.reuseIdentifier)
        tableView.register(UITableViewHeaderFooterView.self,
                           forHeaderFooterViewReuseIdentifier: "UITableViewHeaderFooterView")
        tableView.dataSource = self
        tableView.delegate = self
        tableView.rowHeight = 76
        tableView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(tableView)
        NSLayoutConstraint.activate([
            view.leadingAnchor.constraint(equalTo: tableView.leadingAnchor),
            view.trailingAnchor.constraint(equalTo: tableView.trailingAnchor),
            view.topAnchor.constraint(equalTo: tableView.topAnchor),
            view.bottomAnchor.constraint(equalTo: tableView.bottomAnchor)
        ])
    }
}

extension AppListViewController: UITableViewDataSource {
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return apps.count
    }

    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: AppCell.reuseIdentifier, for: indexPath) as! AppCell
        AppCellFactory.setupCell(cell, app: apps[indexPath.row])

        return cell
    }
}

extension AppListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        guard sendKinDelegate != nil else {
            return
        }

        let app = apps[indexPath.row]
        getAddressFlow.startMoveKinFlow(to: app) { result in
            switch result {
            case .cancelled: print("Cancelled")
            case .success(let address): print("Got address: \(address)")
            case .error(let error): print("Error: \(error)")
            }
        }
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: "UITableViewHeaderFooterView") else {
            return nil
        }

        let contentView = header.contentView

        //UITableViewHeaderFooterView's textLabel doesn't allow more than one line.
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.setTextApplyingLineSpacing("At the moment you can only transfer Kin to your own wallets in other apps.")
        label.numberOfLines = 0
        label.textAlignment = .left
        label.font = KinUI.Fonts.sailec(size: 14)
        label.textColor = KinUI.Colors.gray

        contentView.addSubview(label)
        label.leadingAnchor.constraint(equalTo: contentView.leadingAnchor,
                                       constant: 18).isActive = true
        label.trailingAnchor.constraint(equalTo: contentView.trailingAnchor,
                                        constant: -18).isActive = true
        contentView.centerYAnchor.constraint(equalTo: label.centerYAnchor).isActive = true

        contentView.backgroundColor = KinUI.Colors.veryLightGray

        return header
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 66
    }
}
