//
//  KinAlertController.swift
//  SendKin
//
//  Created by Natan Rolnik on 25/07/19.
//

import UIKit

class KinAlertAction {
    let title: String
    let handler: (() -> Void)?

    init(title: String, handler: (() -> Void)? = nil) {
        self.title = title
        self.handler = handler
    }
}

class FormsheetPresentationController: UIPresentationController {
    let dimmingView = UIView()
    var allowsBackrgoundTapToDismiss = false

    override init(presentedViewController: UIViewController,
                  presenting presentingViewController: UIViewController?) {
        super.init(presentedViewController: presentedViewController,
                   presenting: presentingViewController)

        setupDimmingView()
    }

    func setupDimmingView() {
        let tapRecognizer = UITapGestureRecognizer(target: self,
                                                   action: #selector(dimmingViewTapped(_:)))
        dimmingView.addGestureRecognizer(tapRecognizer)
        dimmingView.backgroundColor = UIColor.lightGray.withAlphaComponent(0.5)
    }

    @objc func dimmingViewTapped(_ tapRecognizer: UITapGestureRecognizer) {
        if allowsBackrgoundTapToDismiss {
            presentingViewController.dismiss(animated: true, completion: nil)
        }
    }

    override func presentationTransitionWillBegin() {
        guard let containerView = self.containerView else {
            return
        }

        presentedView?.layer.cornerRadius = 8
        presentedView?.layer.shadowColor = UIColor.gray.cgColor
        presentedView?.layer.shadowRadius = 6
        presentedView?.layer.shadowOffset = .init(width: 1, height: 1)
        presentedView?.layer.shadowOpacity = 0.5
        dimmingView.frame = containerView.bounds
        dimmingView.alpha = 0.0

        containerView.insertSubview(dimmingView, at: 0)

        presentedViewController.transitionCoordinator?.animate(alongsideTransition: { _ in
            self.dimmingView.alpha = 1.0
        }, completion: nil)
    }

    override func dismissalTransitionWillBegin() {
        presentedViewController.transitionCoordinator?.animate(alongsideTransition: { _ in
            self.dimmingView.alpha = 0.0
        }, completion: nil)
    }

    override func containerViewWillLayoutSubviews() {
        guard let containerView = containerView else {
            return
        }

        dimmingView.frame = containerView.bounds
        presentedView?.frame = frameOfPresentedViewInContainerView
    }

    override func size(forChildContentContainer container: UIContentContainer,
                       withParentContainerSize parentSize: CGSize) -> CGSize {
        return presentedViewController.preferredContentSize
    }

    override var frameOfPresentedViewInContainerView: CGRect {
        var presentedViewFrame = CGRect.zero

        guard let containerBounds = containerView?.bounds else {
            return presentedViewFrame
        }

        let presentedViewFrameSize = size(forChildContentContainer: presentedViewController,
                                          withParentContainerSize: containerBounds.size)
        presentedViewFrame.size = presentedViewFrameSize
        presentedViewFrame.origin.x = (containerBounds.width - presentedViewFrameSize.width) / 2
        presentedViewFrame.origin.y = (containerBounds.height - presentedViewFrameSize.height) / 2

        return presentedViewFrame
    }
}

private class KinAlertTransitionAnimator: NSObject, UIViewControllerAnimatedTransitioning {
    let isPresenting: Bool

    init(isPresenting: Bool) {
        self.isPresenting = isPresenting

        super.init()
    }

    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return isPresenting ? 0.5 : 0.25
    }

    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        if isPresenting {
            animatePresentation(using: transitionContext)
        } else {
            animateDismissal(using: transitionContext)
        }
    }

    private func animatePresentation(using transitionContext: UIViewControllerContextTransitioning) {
        guard
            let toVC = transitionContext.viewController(forKey: .to),
            let toView = transitionContext.view(forKey: .to) else {
                return
        }

        let containerView = transitionContext.containerView
        toView.frame = transitionContext.finalFrame(for: toVC)
        toView.transform = .init(scaleX: 0.9, y: 0.9)
        toView.alpha = 0.7

        containerView.addSubview(toView)

        toView.setNeedsLayout()
        toView.layoutIfNeeded()

        UIView.animate(withDuration: transitionDuration(using: transitionContext),
                       delay: 0,
                       usingSpringWithDamping: 0.8,
                       initialSpringVelocity: 0.8,
                       options: [], animations: {
                        toView.transform = .identity
        }, completion: { _ in
            let didComplete = !transitionContext.transitionWasCancelled
            transitionContext.completeTransition(didComplete)
        })
    }

    private func animateDismissal(using transitionContext: UIViewControllerContextTransitioning) {
        guard let fromView = transitionContext.view(forKey: .from) else {
            return
        }

        UIView.animate(withDuration: transitionDuration(using: transitionContext), animations: {
            fromView.alpha = 0
            fromView.transform = .init(scaleX: 0.93, y: 0.93)
        }, completion: { _ in
            fromView.removeFromSuperview()
            let didComplete = !transitionContext.transitionWasCancelled
            transitionContext.completeTransition(didComplete)
        })
    }
}

private class KinAlertControllerPresenter: UIViewController {
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
}

class KinAlertController: UIViewController {
    let tapHandler: (() -> Void)?

    private let actionButton: UIButton = {
        let b = UIButton(type: .system)
        b.tintColor = KinUI.Colors.purple
        b.setTitleColor(KinUI.Colors.purple, for: .normal)
        b.titleLabel?.font = KinUI.Fonts.sailecMedium(size: 16)
        b.layer.cornerRadius = 4
        b.layer.borderWidth = 1
        b.layer.borderColor = KinUI.Colors.purple.cgColor

        return b
    }()

    private let label: UILabel = {
        let l = UILabel()
        l.font = KinUI.Fonts.sailec(size: 16)
        l.textColor = KinUI.Colors.black
        l.textAlignment = .center
        l.numberOfLines = 0

        return l
    }()

    private let stackView: UIStackView

    func showInNewWindow() {
        let presenter = KinAlertControllerPresenter()
        presenter.view.backgroundColor = .clear

        let alertWindow = UIWindow()
        alertWindow.backgroundColor = .clear
        alertWindow.rootViewController = presenter
        alertWindow.makeKeyAndVisible()

        presenter.present(self, animated: true)
    }

    init(title: String?, message: String?, action: KinAlertAction) {
        let attributedText = NSMutableAttributedString()

        if let title = title {
            attributedText.append(.init(string: title, attributes: [.font: KinUI.Fonts.sailecBold(size: 16)]))
        }

        if title != nil && message != nil {
            attributedText.append(.init(string: "\n\n"))
        }

        if let message = message {
            attributedText.append(.init(string: message))
        }

        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 4
        paragraphStyle.alignment = .center
        attributedText.addAttribute(.paragraphStyle,
                                    value: paragraphStyle,
                                    range: NSRange(location: 0, length: attributedText.string.count))

        label.attributedText = attributedText

        tapHandler = action.handler
        actionButton.setTitle(action.title, for: .normal)
        actionButton.backgroundColor = .white

        stackView = UIStackView(arrangedSubviews: [label, actionButton])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.spacing = 18
        stackView.axis = .vertical
        stackView.distribution = .fill
        stackView.alignment = .fill

        super.init(nibName: nil, bundle: nil)

        actionButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        actionButton.addTarget(self, action: #selector(buttonTapped), for: .primaryActionTriggered)

        transitioningDelegate = self
        modalPresentationStyle = .custom
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white
        view.addSubview(stackView)

        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 18),
            stackView.topAnchor.constraint(equalTo: view.topAnchor, constant: 18),
            view.trailingAnchor.constraint(equalTo: stackView.trailingAnchor, constant: 18),
            view.bottomAnchor.constraint(equalTo: stackView.bottomAnchor, constant: 18)
            ])
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override var preferredContentSize: CGSize {
        get {
            let parentViewSize = parent?.view.frame.size ?? (UIApplication.shared.keyWindow?.rootViewController?.view.frame.size ?? .zero)
            let width = min(280, parentViewSize.width * 0.76)

            let stackViewHeight = stackView.systemLayoutSizeFitting(CGSize(width: width - 36,
                                                                           height: CGFloat.greatestFiniteMagnitude)).height
            return CGSize(width: width, height: stackViewHeight + 36)
        }
        set {
            super.preferredContentSize = newValue
        }
    }

    @objc func buttonTapped() {
        dismiss(animated: true) {
            self.tapHandler?()
        }
    }
}

extension KinAlertController: UIViewControllerTransitioningDelegate {
    func presentationController(forPresented presented: UIViewController,
                                presenting: UIViewController?,
                                source: UIViewController) -> UIPresentationController? {
        if presented is KinAlertController {
            return FormsheetPresentationController(presentedViewController: presented,
                                                   presenting: presenting)
        }

        return nil
    }

    func animationController(forPresented presented: UIViewController,
                             presenting: UIViewController,
                             source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return KinAlertTransitionAnimator(isPresenting: true)
    }

    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return KinAlertTransitionAnimator(isPresenting: false)
    }
}
