//
//  MJControllerManager.swift
//  Alamofire
//
//  Created by Podul on 2018/2/27.
//

import Foundation

public struct Test {
    var s_topWindow: UIWindow?
    lazy var dicForListVC = [String: Any]()
    var viewShareMask: UIView?
    static var dicVCs = [String: UIViewController]()
    public static let shared = Test()
    private init() {}
}

// MARK: - Window 相关
extension Test {
    public static var topWindow: UIWindow? {
        if Test.shared.s_topWindow == nil {
            WindowAction.shared.changeKeyWindow()
        }
        return Test.shared.s_topWindow
    }
    
    public static var mainWindow: UIWindow? {
        return (UIApplication.shared.delegate?.window)!
    }
}

// MARK: - Controller 相关
extension Test {
    public static var isInRootViewController: Bool {
        return rootViewController.presentedViewController == nil
    }
    
    public static var rootViewController: UIViewController {
        return (mainWindow?.rootViewController)!
    }
    
    /// 最顶层界面
    public static var topViewController: UIViewController {
        var topVC: UIViewController?
        var navVC = rootViewController
        while navVC.presentedViewController != nil {
            navVC = navVC.presentedViewController!
        }
        if navVC is UINavigationController {
            topVC = (navVC as! UINavigationController).topViewController
        }else {
            topVC = navVC
        }
        while (topVC is UINavigationController) || (topVC is UITabBarController) {
            if topVC is UITabBarController {
                let tabBarVC = topVC as! UITabBarController
                var selectedIndex = tabBarVC.selectedIndex
                if selectedIndex <= 0 || selectedIndex >= (tabBarVC.viewControllers?.count)! {
                    selectedIndex = 0
                }
                topVC = tabBarVC.viewControllers?[selectedIndex]
            }else {
                let navVC = topVC as! UINavigationController
                topVC = navVC.topViewController
            }
        }
        return topVC!
    }
    
    /// 最顶层容器界面
    public static var topContainerController: UINavigationController? {
        var topVC = topWindow?.rootViewController
        var presentVC = topVC?.presentedViewController
        while presentVC != nil {
            topVC = presentVC
            presentVC = topVC?.presentedViewController
        }
        return topVC as? UINavigationController
    }
    
    public static func popToRootViewController(animated: Bool = true) {
        var navVC = mainWindow?.rootViewController as? UINavigationController
        if navVC?.presentedViewController != nil {
            navVC?.dismiss(animated: animated, completion: nil)
        }
        if !(navVC?.viewControllers.isEmpty)! {
            navVC?.popToRootViewController(animated: animated)
        }
        let aVC = navVC?.viewControllers[0]
        if aVC is UITabBarController {
            navVC = aVC as? UINavigationController
            navVC?.popToRootViewController(animated: animated)
            
        }
    }
    
    public static func getViewController(name aVCName: String) -> UIViewController? {
        if aVCName.isEmpty {
            return nil
        }
        // Swift 中，自己的类要加命名空间
        let namespace = Bundle.main.infoDictionary?[kCFBundleExecutableKey as String] as! String
        //        let classVC: AnyClass? = NSClassFromString(namespace + "." + aVCName)
        guard let classVC = NSClassFromString(namespace + "." + aVCName) else { return nil }
        // 存在该类
        let filePath = Bundle.main.path(forResource: aVCName, ofType: "nib")
        guard let type = classVC as? UIViewController.Type else { return nil }
        var aVC: UIViewController?
        if (filePath?.isEmpty)! {
            aVC = type.init()
        }else {
            aVC = type.init(nibName: aVCName, bundle: nil)
        }
        return aVC
    }
    
    public static func getUniqueViewController(name aVCName: String) -> UIViewController? {
        var aVC = dicVCs[aVCName]
        if aVC != nil {
            return aVC
        }
        aVC = getViewController(name: aVCName)
        if aVC != nil {
            dicVCs[aVCName] = aVC
        }
        return aVC
    }
}

// MARK: - Share
extension Test {
    public typealias ShareComplete = (_ isSuccess: Bool, _ message: String, _ data: Any?) -> ()
    public static func showShareView(withContents shareContents: Array<Any>, onView aView: UIView?, excludedList: Array<UIActivityType>? = nil, completion: ShareComplete?) {
        let activityVC = UIActivityViewController(activityItems: shareContents, applicationActivities: nil)
        activityVC.excludedActivityTypes = excludedList
        // 没有适配 iOS 8.0 以下，所以不用判断
        if UIDevice.current.userInterfaceIdiom == .pad {
            if aView != nil {
                activityVC.popoverPresentationController?.sourceView = aView
            }else {
                activityVC.popoverPresentationController?.sourceView = topViewController.view
            }
            activityVC.popoverPresentationController?.sourceRect = (activityVC.popoverPresentationController?.sourceView?.bounds)!
        }
        activityVC.completionWithItemsHandler = {(activityType, completed, _, _) in
            if completed {
                print("分享成功")
            }
            if completion != nil {
                completion!(completed, "", activityType)
            }
        }
        topViewController.present(activityVC, animated: true, completion: nil)
    }
}


// MARK: - Private
private class WindowAction: NSObject {
    public static let shared = WindowAction()
    var s_topWindow: UIWindow?
    private override init() {
        super.init()
        NotificationCenter.default.addObserver(self, selector: .changeKeyWindow, name: .UIWindowDidBecomeKey, object: nil)
    }
    deinit {
        NotificationCenter.default.removeObserver(self, name: .UIWindowDidBecomeKey, object: nil)
    }
}

// MARK: -  Action
@objc extension WindowAction {
    // MARK: - Notification
    func changeKeyWindow(_ notification: Notification? = nil) {
        let mainWindow = Test.mainWindow
        var topWindow = UIApplication.shared.keyWindow
        if topWindow != mainWindow {
            let windows = UIApplication.shared.windows.sorted {
                ($0.windowLevel > $1.windowLevel)
            }
            // Swift 特性，不知道有没有用
            for aWindow in windows where
                aWindow.isKind(of: NSClassFromString("UITextEffectsWindow")!) &&
                    aWindow.windowLevel <= UIWindowLevelNormal + 10 &&
                    aWindow.rootViewController != nil &&
                    !aWindow.rootViewController!.view.isHidden {
                        topWindow = aWindow
                        break
            }
        }
        s_topWindow = topWindow
    }
}

/// Selector extension
private extension Selector {
    static let changeKeyWindow = #selector(WindowAction.changeKeyWindow(_:))
}
