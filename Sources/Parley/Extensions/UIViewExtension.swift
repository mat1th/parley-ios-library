import UIKit

extension UIView {

    func present(_ viewControllerToPresent: UIViewController, animated: Bool, completion: (() -> Void)? = nil) {    
        if let owningViewController = self.parentViewController {
            owningViewController.present(viewControllerToPresent, animated: animated, completion: completion)
        } else {
            if let rootViewController = activeSceneRootViewController { 
                let presentingVC = self.findTopViewController(from: rootViewController)
                presentingVC.present(viewControllerToPresent, animated: animated, completion: completion)
            }
        }
    }
    
    var activeSceneRootViewController: UIViewController? {
        guard let windowScene = UIApplication.shared.connectedScenes.first(where: {
            $0.activationState == .foregroundActive
        }) as? UIWindowScene else { return nil }
        return windowScene.windows.first(where: \.isKeyWindow)?.rootViewController
    }
    
    var parentViewController: UIViewController? {
        var responder: UIResponder? = self
        while let nextResponder = responder?.next {
            if let viewController = nextResponder as? UIViewController {
                return viewController
            }
            responder = nextResponder
        }
        return nil
    }
    
    func findTopViewController(from viewController: UIViewController) -> UIViewController {
        if let presented = viewController.presentedViewController {
            return findTopViewController(from: presented)
        }
        
        if let navigationController = viewController as? UINavigationController {
            if let topVC = navigationController.topViewController {
                return findTopViewController(from: topVC)
            }
        }
        
        if let tabBarController = viewController as? UITabBarController {
            if let selected = tabBarController.selectedViewController {
                return findTopViewController(from: selected)
            }
        }
        
        return viewController
    }

    func watchForVoiceOverDidChangeNotification(observer: AnyObject) {
        NotificationCenter.default.addObserver(
            observer,
            selector: #selector(voiceOverDidChangeNotificationCallback),
            name: UIAccessibility.voiceOverStatusDidChangeNotification,
            object: nil
        )

        // Run callback function immediately
        voiceOverDidChangeNotificationCallback()
    }

    @objc
    private func voiceOverDidChangeNotificationCallback() {
        voiceOverDidChange(isVoiceOverRunning: UIAccessibility.isVoiceOverRunning)
    }

    /// Called when VoiceOver status changed.
    /// - Important: Call `watchForVoiceOverDidChangeNotification(observer:)` to get callbacks.
    @objc
    func voiceOverDidChange(isVoiceOverRunning: Bool) { }
    
    func pinToSides(in view: UIView, insets: UIEdgeInsets = .zero) {        
        NSLayoutConstraint.activate([
            self.topAnchor.constraint(equalTo: view.topAnchor, constant: insets.top),
            self.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: insets.right),
            self.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: insets.bottom),
            self.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: insets.left),
        ])
    }
    
    func hasUserIntrefaceStyleChanged(_ previousTraitCollection: UITraitCollection) -> Bool {
        traitCollection.userInterfaceStyle != previousTraitCollection.userInterfaceStyle
    }
}
