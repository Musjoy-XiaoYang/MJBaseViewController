//
//  MJNavigationController.swift
//  FBSnapshotTestCase
//
//  Created by Podul on 2018/2/28.
//

import UIKit

let BACK_ITEM_TAG = 1000

open class MJNavigationController: UINavigationController {
    /// 当前是否显示
    public var isViewShow: Bool = false
    
    /// 是否已经显示过
    public var isViewHadShow: Bool = false
    
    override open func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    open override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        isViewShow = true
        isViewHadShow = true
    }
    
    override open func viewWillDisappear(_ animated: Bool) {
        isViewShow = false
        super.viewWillDisappear(animated)
    }

    override open func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

// MARK: - navigationItem 相关
extension MJNavigationController {
    public func showBackButtonWith(_ viewController: UIViewController, action: Selector? = nil) {
        let action: Selector = action == nil ? .back : action!
        guard let leftItem = createButtonWith(viewController, action: action) else { return }
        viewController.navigationItem.setLeftBarButton(leftItem, animated: true)
    }
    
    public func showLeftButtonWith(_ viewController: UIViewController, title: String?, action: Selector) -> UIBarButtonItem {
        let leftItem = UIBarButtonItem(title: title, style: .plain, target: viewController, action: action)
        viewController.navigationItem.setLeftBarButton(leftItem, animated: true)
        return leftItem
    }
    
    public func showLeftButtonWith(_ viewController: UIViewController, image: UIImage?, action: Selector) -> UIBarButtonItem {
        let leftItem = UIBarButtonItem(image: image, style: .plain, target: viewController, action: action)
        viewController.navigationItem.setLeftBarButton(leftItem, animated: true)
        return leftItem
    }
    
    public func showRightButtonWith(_ viewController: UIViewController, title: String?, action: Selector) -> UIBarButtonItem {
        let rightItem = UIBarButtonItem(title: title, style: .plain, target: viewController, action: action)
        viewController.navigationItem.setRightBarButton(rightItem, animated: true)
        return rightItem
    }
    
    public func showRightButtonWith(_ viewController: UIViewController, image: UIImage?, action: Selector) -> UIBarButtonItem {
        let rightItem = UIBarButtonItem(image: image, style: .plain, target: viewController, action: action)
        viewController.navigationItem.setLeftBarButton(rightItem, animated: true)
        return rightItem
    }
    
    private func createButtonWith(_ target: Any, action: Selector) -> UIBarButtonItem? {
        let backImage = UIImage(named: "nav_back")
        guard let image = backImage else { return nil }
        let backNav = UIBarButtonItem(image: image, style: .plain, target: target, action: action)
        return backNav
    }
    
}

// MARK: - Action
@objc extension MJNavigationController {
    public func back() -> Bool {
        if viewControllers.isEmpty {
            dismiss(animated: true, completion: nil)
            return false
        }else {
            guard let vc = viewControllers.last! as? MJBaseViewController else { return false }
            if vc.isViewHadShow {
                popViewController(animated: true)
            }
        }
        return true
    }
    
    public func clickLeftItem() -> Bool {
        guard let topVC = topViewController else { return false }
        guard !viewControllers.isEmpty else { return false }
        guard let vc = viewControllers.last! as? MJBaseViewController else { return false }
        if vc.isViewHadShow {
            if topVC.navigationItem.hidesBackButton {
                return back()
            }
        }
        let leftItem = topVC.navigationItem.leftBarButtonItem
        if leftItem?.tag == BACK_ITEM_TAG {
            return back()
        }
        return false
    }
}

// MARK: - UIGestureRecognizerDelegate
extension MJNavigationController {
    /// 判断能否滑动返回
    public func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        if viewControllers.count <= 1 {
            return false
        }else {
            let lastVC = viewControllers.last!
            let secondLastVC = viewControllers[viewControllers.count - 2]
            if lastVC.canSlipOut(gestureRecognizer) && secondLastVC.canSlipOut(gestureRecognizer) {
                return true
            }
            return false
        }
    }
}

// MARK: - UIViewController extension
extension UIViewController: UIGestureRecognizerDelegate {
    public var navController: MJNavigationController? {
        var viewController = self.parent
        while !(viewController == nil || (viewController is MJNavigationController)) {
            viewController = viewController?.parent
        }
        return viewController as? MJNavigationController
    }
    
    /// 是否可以滑出
    open func canSlipOut(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
    
    /// 是否可以滑入
    open func canSlipIn(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}

// MARK: - Selector extension
fileprivate extension Selector {
    static let back = #selector(MJNavigationController.back)
}




