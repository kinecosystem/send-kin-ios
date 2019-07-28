# SendKin

<!-- [![Version](https://img.shields.io/cocoapods/v/SendKin.svg?style=flat)](https://cocoapods.org/pods/send-kin-module-ios)
[![License](https://img.shields.io/cocoapods/l/SendKin.svg?style=flat)](https://cocoapods.org/pods/send-kin-module-ios)
[![Platform](https://img.shields.io/cocoapods/p/SendKin.svg?style=flat)](https://cocoapods.org/pods/SendKin) -->

## Usage

To understand how to implement SendKin, run `pod install` in the Example directory and check the sample application, which has 2 targets: Sender and Receiver.

### Initial Setup

Before allowing your users to send and receive Kin to/from their wallets on other apps, there are 2 steps to be done.

1. Create your `SendKin` instance and hold a reference to it.

```swift
class AppDelegate: UIResponder, UIApplicationDelegate {
    let sendKin = SendKin()
    //...
}
```

2. If your app doesn't have yet a URL Scheme, add one in the Info tab of your main app target. Contact the Kin DevX team to add your app's info to the list of apps displayed by this module.

### Receiving Kin

Now, to receive Kin from other apps, implement the `ReceiveKinFlowDelegate`. It has has 2 simple methods: (1) provide the user's wallet address, if existing; (2) letting your server know that an incoming transaction might happen in the next few moments.

**Note: We do not necessarily recommend implementing the protocols in your app's AppDelegate, as shown in the sample code. We did so in the sample app to help understanding the separation of concerns in this module.**

```swift
extension AppDelegate: ReceiveKinFlowDelegate {
    func handlePossibleIncomingTransaction(senderAppName: String,
                                           senderAppId: String,
                                           memo: String) {
        //here, your app should let your server know that a possible
        //incoming transaction might happen, so transaction history
        //gets updated accordingly
    }

    func provideUserAddress(addressHandler: @escaping (String?) -> Void) {
        let userAddress = //access the user's public address, if he's created a wallet...
        addressHandler(userAddress)
    }
}

```

Your `AppDelegate` should be able to forward `application(_ app:, open url:, options:)` calls it may eventually receive. You can do it in the same way it's done in the sample app:

```swift
func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
    if sendKin.canHandleURL(url) {
        let sourceAppBundleId = (options[.sourceApplication] as? String) ?? ""
        sendKin.handleURL(url, from: sourceAppBundleId, receiveDelegate: self)
    }

    return true
}
```

### Sending Kin

Next, because `SendKin` is agnostic to the `KinSDK` transactions and balance operations, it needs a `SendKinFlowDelegate` to perform them in its behalf. Choose your class to implement the protocol by (1) actually sending Kin, (2) returning the balance and (3) the App Id configured in the KinSDK. The delegate receives all the needed information to perform sending Kin, as the receiver address, amount, and memo, while it is its responsibility to call the completion block with the `Result` upon success or failure.

```swift
func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
    sendKin.delegate = self

    return true
}
```

Finally, request the `transferButton` to add it to your UI. The button takes care of starting the flow by itself, so you don't need to add any action to it. If you prefer to initiate the flow from your own UI, call directly `sendKin.start()`. Using any of these options without setting the delegate before will not work.

```swift
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
```

## Installation

send-kin-module-ios is available through [CocoaPods](https://cocoapods.org). SPM and Carthage are not supported yet.

To install
it, simply add the following line to your Podfile:

```ruby
pod 'SendKin'
```

## License

SendKin is available under the MIT license. See the LICENSE file for more info.
