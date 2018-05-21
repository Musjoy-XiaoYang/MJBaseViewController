//
//  MJBaseViewController.swift
//  FBSnapshotTestCase
//
//  Created by Podul on 2018/2/27.
//
/// 屏幕高度
let kScreenHeight = UIScreen.main.bounds.size.height
/// 屏幕宽度
let kScreenWidth =  UIScreen.main.bounds.size.width

import UIKit

open class MJBaseViewController: UIViewController {
    
    private var delegate: KeyboardDelegate?
    
    /// 当前是否显示
    var isViewShow: Bool = false
    
    /// 是否已经显示过
    var isViewHadShow: Bool = false
    
    /// 顶部适配 Layout
    @IBOutlet var lytTop: NSLayoutConstraint?
    
    /// 底部适配 Layout
    @IBOutlet var lytBottom: NSLayoutConstraint?
    
    // MARK: - LifeCycle
    override open func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        viewConfig()
    }
    
    override open func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if !isViewHadShow {
            // 解决部分界面第一次显示 ScrollView 显示异常问题
            guard #available(iOS 9.0, *) else { return }
            guard let isHide = navigationController?.isNavigationBarHidden else { return }
            navigationController?.setNavigationBarHidden(!isHide, animated: false)
            navigationController?.setNavigationBarHidden(isHide, animated: true)
        }
    }
    
    override open func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        isViewHadShow = true
        isViewShow = true
        // 遵守了协议才添加通知
        if self is KeyboardDelegate {
            NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChangeFrame(_:)), name: .UIKeyboardWillChangeFrame, object: nil)
        }
    }
    
    override open func viewWillDisappear(_ animated: Bool) {
        isViewShow = false
        if self is KeyboardDelegate {
            NotificationCenter.default.removeObserver(self, name: .UIKeyboardWillChangeFrame, object: nil)
        }
        super.viewWillDisappear(animated)
    }

    override open func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

// MARK: - override
extension MJBaseViewController {
    /// 是否允许旋转
    override open var shouldAutorotate: Bool {
        if UI_USER_INTERFACE_IDIOM() == .phone {
            return false
        }
        return true
    }
    
    /// 旋转方向
    override open var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        if UI_USER_INTERFACE_IDIOM() == .phone {
            return .portrait
        }
        return .all
    }
    
    /// 状态栏颜色
    override open var preferredStatusBarStyle: UIStatusBarStyle {
        return .`default`
    }
}

// MARK: - Action
@objc extension MJBaseViewController {
    // MARK: - Notification
    /// 键盘高度发生变化
    func keyboardWillChangeFrame(_ notification: Notification) {
        delegate = self as? KeyboardDelegate
        let userInfo = notification.userInfo
        guard let duration = userInfo?[UIKeyboardAnimationDurationUserInfoKey] as? Float else { return }
        if duration > 0 {
            guard let aValue = userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue else { return }
            let keyboardRect = aValue.cgRectValue
            if keyboardRect.origin.y > kScreenHeight - 5 {
                // 键盘隐藏
                delegate?.keyboardWillHide(notification)
            }else {
                // 键盘显示
                delegate?.keyboardWillShow(notification)
            }
        }else {
            // 键盘高度变化，以后可修改为另一个方法
            delegate?.keyboardWillShow(notification)
        }
    }
}

// MARK: - View 相关
extension MJBaseViewController {
    private func viewConfig() {
        // 配置 lytTop 和 lytBottom
        func topLayout() {
            guard let topLyt = lytTop else { return }
            var topItem = topLyt.firstItem
            if topItem === view {
                topItem = topLyt.secondItem
            }
            guard let theView = topItem as? UIView else { return }
            let theLyt = NSLayoutConstraint(item: topLayoutGuide,
                                            attribute: .bottom,
                                            relatedBy: .equal,
                                            toItem: theView,
                                            attribute: .top,
                                            multiplier: 1,
                                            constant: 0)
            topLyt.isActive = false
            theLyt.isActive = true
            lytTop = theLyt
            view.setNeedsLayout()
        }
        
        func bottomLayout() {
            guard let bottomLyt = lytBottom else { return }
            var bottomItem = bottomLyt.firstItem
            if bottomItem === view {
                bottomItem = bottomLyt.secondItem
            }
            guard let theView1 = bottomItem as? UIView else { return }
            let theLyt1 = NSLayoutConstraint(item: theView1,
                                             attribute: .bottom,
                                             relatedBy: .equal,
                                             toItem: bottomLayoutGuide,
                                             attribute: .top,
                                             multiplier: 1,
                                             constant: 0)
            bottomLyt.isActive = false
            theLyt1.isActive = true
            lytBottom = theLyt1
            view.setNeedsLayout()
        }
    }
    
    /// 将该 aTopView 与 topLayoutGuide 相连，调用该函数前必须确保 aTopView 在 self.view 内
    public func alignTop(view aTopView: UIView!) {
        let theLyt = NSLayoutConstraint(item: topLayoutGuide,
                                        attribute: .bottom,
                                        relatedBy: .equal,
                                        toItem: aTopView,
                                        attribute: .top,
                                        multiplier: 1,
                                        constant: 0)
        theLyt.isActive = true
        if lytTop == nil {
            lytTop = theLyt
        }
    }
    
    /// 将该 aBottomView 与 bottomLayoutGuide 相连，调用该函数前必须确保 aBottomView 在 self.view 内
    public func alignBottom(view aBottomView: UIView!) {
        let theLyt = NSLayoutConstraint(item: aBottomView,
                                        attribute: .bottom,
                                        relatedBy: .equal,
                                        toItem: bottomLayoutGuide,
                                        attribute: .top,
                                        multiplier: 1,
                                        constant: 0)
        theLyt.isActive = true
        if lytBottom == nil {
            lytBottom = theLyt
        }
    }
}

//#if MOUDLE_NETWORKING
/// Loading
extension MJBaseViewController {
    private func loadingView() {
        
    }
}
//#endif

// MARK: - 键盘出现隐藏
public protocol KeyboardDelegate where Self: MJBaseViewController {
    /// 键盘出现
    func keyboardWillShow(_ notification: Notification)
    
    /// 键盘隐藏
    func keyboardWillHide(_ notification: Notification)
}

// MARK: - Selector extension
fileprivate extension Selector {
    static let keyboardWillChangeFrame = #selector(MJBaseViewController.keyboardWillChangeFrame(_:))
}

