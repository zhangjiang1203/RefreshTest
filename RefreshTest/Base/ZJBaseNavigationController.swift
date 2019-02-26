//
//  ZJBaseNavigationController.swift
//  RefreshTest
//
//  Created by zxd on 2019/2/19.
//  Copyright © 2019 张江. All rights reserved.
//

import UIKit

enum UINavigationStyle {
    case theme
    case clear
    case white
}

class ZJBaseNavigationController: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()
//        self.navigationBar.isTranslucent = false
        
        //自定义返回手势
        guard let interactionGes = self.interactivePopGestureRecognizer else {return}
        guard let targetView = interactionGes.view else {return}
        guard let internalTargets = interactionGes.value(forKeyPath: "targets") as? [NSObject] else {return}
        guard let internalTarget = internalTargets.first?.value(forKey: "target") else {return}
        let action = Selector(("handleNavigationTransition:"))
        
        let fullScreenGesture = UIPanGestureRecognizer.init(target: internalTarget, action: action)
        fullScreenGesture.delegate = self
        targetView.addGestureRecognizer(fullScreenGesture)
        interactionGes.isEnabled = false
    }
    
    override func pushViewController(_ viewController: UIViewController, animated: Bool) {
        if viewControllers.count > 0 { viewController.hidesBottomBarWhenPushed = true }
        super.pushViewController(viewController, animated: animated)
    }

}

extension ZJBaseNavigationController:UIGestureRecognizerDelegate{
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        let isLeftToRight = UIApplication.shared.userInterfaceLayoutDirection == .leftToRight
        guard let ges = gestureRecognizer as? UIPanGestureRecognizer else {
            return true
        }
        if ges.translation(in: gestureRecognizer.view).x * (isLeftToRight ? 1 : -1) <= 0 || disablePopGesture{
            return false
        }
        return viewControllers.count != 1
    }
}


// MARK: - navigation的拓展方法
extension UINavigationController{
    private struct AssociatedKeys{
        static var disablePopGesture:Void?
        static var backDropKey: Void?
    }
    
    var disablePopGesture : Bool{
        get{
            return objc_getAssociatedObject(self, &AssociatedKeys.disablePopGesture) as? Bool ?? false
        }
        set{
            objc_setAssociatedObject(self, &AssociatedKeys.disablePopGesture, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }

    /// 设置导航栏的样式
    ///
    /// - Parameter style: 样式枚举值
    func barStyle(_ style:UINavigationStyle) {
        switch style {
        case .theme:
            setBarColor(color: UIColor.hex(hexString: "ff4a61"), alpha: 1)
        case .clear:
            setBarColor(color: UIColor.hex(hexString: "ff4a61"), alpha: 0)
        case .white:
            setBarColor(color: .white, alpha: 1)
        }
    }
    
    /// 设置导航栏颜色+透明度
    func setBarColor(image: UIImage?=nil, color: UIColor?, alpha: CGFloat) {
        // 去掉阴影
        navigationBar.shadowImage = UIImage()
        // 把视觉曾遍历设置为纯透明
        for v: UIView in navigationBar.subviews[0].subviews {
            if v.tag != 10054 {
                v.alpha = 0
            }
        }
        // 添加新的视觉图层
        if backdropImageView?.superview == nil {
            backdropImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: screenWidth, height:(isIphoneX ? 88 : 64)))
            navigationBar.subviews[0].insertSubview(backdropImageView!, at: 0)
        }
        backdropImageView?.tag = 10054
        backdropImageView?.image = image
        backdropImageView?.backgroundColor = color ?? UIColor.white
        backdropImageView?.alpha = alpha
    }
    
    // 添加一层UIImageView层, 用于展示 (纯色背景 || 指定图片 || 完全透明)
    var backdropImageView: UIImageView? {
        get {
            return objc_getAssociatedObject(self, &AssociatedKeys.backDropKey) as? UIImageView
        }
        set {
            objc_setAssociatedObject(self, &AssociatedKeys.backDropKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
        
        
    }
}

extension UIColor {
    convenience init(r:UInt32 ,g:UInt32 , b:UInt32 , a:CGFloat = 1.0) {
        self.init(red: CGFloat(r) / 255.0,
                  green: CGFloat(g) / 255.0,
                  blue: CGFloat(b) / 255.0,
                  alpha: a)
    }
    
    class var random: UIColor {
        return UIColor(r: arc4random_uniform(256),
                       g: arc4random_uniform(256),
                       b: arc4random_uniform(256))
    }
    
    func image() -> UIImage {
        let rect = CGRect(x: 0, y: 0, width: 1, height: 1)
        UIGraphicsBeginImageContext(rect.size)
        let context = UIGraphicsGetCurrentContext()
        context!.setFillColor(self.cgColor)
        context!.fill(rect)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image!
    }
    
    class func hex(hexString: String) -> UIColor {
        var cString: String = hexString.trimmingCharacters(in: .whitespacesAndNewlines)
        if cString.count < 6 { return UIColor.black }
        
        let index = cString.index(cString.endIndex, offsetBy: -6)
        let subString = cString[index...]
        if cString.hasPrefix("0X") { cString = String(subString) }
        if cString.hasPrefix("#") { cString = String(subString) }
        
        if cString.count != 6 { return UIColor.black }
        
        var range: NSRange = NSMakeRange(0, 2)
        let rString = (cString as NSString).substring(with: range)
        range.location = 2
        let gString = (cString as NSString).substring(with: range)
        range.location = 4
        let bString = (cString as NSString).substring(with: range)
        
        var r: UInt32 = 0x0
        var g: UInt32 = 0x0
        var b: UInt32 = 0x0
        
        Scanner(string: rString).scanHexInt32(&r)
        Scanner(string: gString).scanHexInt32(&g)
        Scanner(string: bString).scanHexInt32(&b)
        
        return UIColor(r: r, g: g, b: b)
    }
}



