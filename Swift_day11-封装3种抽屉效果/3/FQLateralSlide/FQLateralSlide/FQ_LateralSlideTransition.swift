
//
//  FQ_LateralSlideTransition.swift
//  FQLateralSlide
//
//  Created by mac on 2018/1/24.
//  Copyright © 2018年 mac. All rights reserved.
//

import UIKit

let ScreenW = UIScreen.main.bounds.size.width
let ScreenH = UIScreen.main.bounds.size.height

let MaskCoverViewPanGestureRecognizer = "MaskCoverViewPanGestureRecognizer"
let MaskCoverViewTapGestureRecognizer = "MaskCoverViewTapGestureRecognizer"
var CWLateralSlideAnimatorKey         = "CWLateralSlideAnimatorKey"



//UIViewController的分类
extension UIViewController {
    
    /// 显示出侧滑控制器的方法
    ///
    /// - Parameters:
    ///   - configuration: 侧滑的相关配置
    ///   - drawerVc: 侧滑出的控制器
    func showLateralSlide(drawerVc: UIViewController) {
        
        let transitionAnim = objc_getAssociatedObject(self, &CWLateralSlideAnimatorKey) as! FQ_TransitionAnimation
        drawerVc.transitioningDelegate = transitionAnim
        transitionAnim.toDriven?.toVc = drawerVc
        self.present(drawerVc, animated: true, completion: nil)
    }
    
    //给当前控制器添加手势.并且配置默认设置
    func addGestureRecognizer(clickBlock : @escaping (FQTransitionDirectionType)->()) {
        
        //还需要获取
        let fromDriven = FQ_PercentDrivenInteractive()
        fromDriven.fromVc = self
        let toDriven = FQ_PercentDrivenInteractive()
        
        let transitionAnim = FQ_TransitionAnimation.initWithDrivenInterative(fromDriven: fromDriven, toDriven: toDriven)
        
        self.transitioningDelegate = transitionAnim
        
        fromDriven.clickPresentBlock = clickBlock
        
        objc_setAssociatedObject(self, &CWLateralSlideAnimatorKey, transitionAnim, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        
    }
    
    //单独写一个push的方法
    func fq_PushOtherVc(pushVc : UIViewController){
        
        let rootVc = UIApplication.shared.keyWindow?.rootViewController
        
        var navigationVc : UINavigationController? = nil
        //获取当前最顶层的navigationVc
        if (rootVc?.isKind(of:UITabBarController.self) == true) {
            
            let tabBarVc = rootVc as! UITabBarController
            let index = tabBarVc.selectedIndex
            let selectVc = tabBarVc.childViewControllers[index]
            if selectVc.isKind(of: UINavigationController.self) == true{
                navigationVc = (selectVc as! UINavigationController)
            }else{
                return
            }
        }else if(rootVc?.isKind(of:UINavigationController.self) == true){
            navigationVc = rootVc as? UINavigationController
        }else{
            return
        }
        self.dismiss(animated:true , completion: nil) //必须要动画.保证遮罩能收回
        //由这个控制器去跳转
        navigationVc?.pushViewController(pushVc, animated: false)
    }
    
    func clickLeftTransition(drawerVc :  UIViewController) {
        FQ_SlideConfiguration.transDirection(.Left)
        self.showLateralSlide(drawerVc: drawerVc)
    }
    
    func clickRightTransition(drawerVc : UIViewController) {
        FQ_SlideConfiguration.transDirection(.Right)
        self.showLateralSlide(drawerVc: drawerVc)
    }
    
}



class FQ_TransitionAnimation : NSObject,UIViewControllerTransitioningDelegate {
    
    var fromDriven : FQ_PercentDrivenInteractive? = nil
    var toDriven : FQ_PercentDrivenInteractive? = nil
    
    //----------------->
    
    class func initWithDrivenInterative(fromDriven : FQ_PercentDrivenInteractive,toDriven : FQ_PercentDrivenInteractive) -> (FQ_TransitionAnimation) {
        let transtionAnimation = FQ_TransitionAnimation()
        transtionAnimation.fromDriven = fromDriven
        transtionAnimation.toDriven = toDriven
        transtionAnimation.fromDriven?.isPresent = true
        transtionAnimation.toDriven?.isPresent = false
        return transtionAnimation
    }
    
    //---------------->present
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        
        return FQ_LateralSlideTransition.initWithLateralSlideTransition(isPresent: true)
    }
    
    func interactionControllerForPresentation(using animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        return  self.fromDriven
    }
    
    //----------------->dismiss
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return FQ_LateralSlideTransition.initWithLateralSlideTransition(isPresent: false)
    }
    
    func interactionControllerForDismissal(using animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        return  self.toDriven
    }
    
    
}

class FQ_PercentDrivenInteractive : UIPercentDrivenInteractiveTransition {
    
    typealias ClickPresentBlock = (_ transitionDirection : FQTransitionDirectionType)->()
    var clickPresentBlock : ClickPresentBlock? = nil
    private var displayLink : CADisplayLink? = nil
    private var remainingProgress : CGFloat = 0.0
    private var currentProgress : CGFloat = 0.0
    private var isFinish : Bool = true
    var isPresent : Bool = false
    var isAddNotification : Bool = false
    weak var fromVc : UIViewController? = nil{
        didSet{
            let ges = UIPanGestureRecognizer(target: self, action: #selector(clickPanGesture(panGesture:)))
            fromVc?.view.addGestureRecognizer(ges)
        }
    }
    weak var toVc : UIViewController? = nil {
        didSet{
            let ges = UIPanGestureRecognizer(target: self, action: #selector(clickPanGesture(panGesture:)))
            self.toVc?.view.addGestureRecognizer(ges)
            
            if self.isAddNotification == false {
                NotificationCenter.default.addObserver(self, selector: #selector(dismissToVc), name: NSNotification.Name(rawValue: MaskCoverViewTapGestureRecognizer), object: nil)
                NotificationCenter.default.addObserver(self, selector: #selector(notificationPanGesture(notification:)), name: NSNotification.Name(rawValue: MaskCoverViewPanGestureRecognizer), object: nil)
                self.isAddNotification = true
            }
        }
    }
    
    
    @objc func dismissToVc() {
        self.toVc?.dismiss(animated: true, completion: nil)
    }
    
    
    @objc func notificationPanGesture(notification : Notification)
    {
        let panGesture = notification.object as! UIPanGestureRecognizer
        self.clickPanGesture(panGesture: panGesture)
    }
    
    
    @objc func clickPanGesture(panGesture : UIPanGestureRecognizer) {
        
        let offX = panGesture.translation(in: panGesture.view).x
        var progress =  offX / ScreenW
        if((FQ_SlideConfiguration.shared.transitionDirection == .Left  && self.isPresent == false)||(FQ_SlideConfiguration.shared.transitionDirection == .Right && self.isPresent == true)){
            progress = -progress
        }
        if panGesture.state == .began {
            if FQ_SlideConfiguration.shared.transitionDirection == .None{
                if self.isPresent {
                    if offX >= 0  {
                        FQ_SlideConfiguration.shared.transitionDirection = .Left
                    }else{
                        FQ_SlideConfiguration.shared.transitionDirection = .Right
                    }
                }else{
                    FQ_SlideConfiguration.shared.transitionDirection = FQ_SlideConfiguration.shared.currentDirection
                }
            }
            
            if self.isPresent == true{
                self.clickPresentBlock!(FQ_SlideConfiguration.shared.transitionDirection)
            }else{
                
                self.toVc?.dismiss(animated: true, completion: nil)
            }
            
        }else if panGesture.state == .changed {
            self.update(fmin(fmax(progress, 0.0), 1.0))
        }else if(panGesture.state == .cancelled || panGesture.state == .ended){
            self.continueWithTheTransition(progress: fmin(fmax(progress, 0.0), 1.0), isFinish: fmin(fmax(progress, 0.0), 1.0) > 0.5)
        }
        
    }
    
    private func continueWithTheTransition(progress: CGFloat,isFinish : Bool) {
        
        self.currentProgress = progress
        self.isFinish = isFinish
        self.startDisplayerLink()
    }
    
    private func startDisplayerLink() {
        if (self.displayLink == nil) {
            self.displayLink = CADisplayLink(target: self, selector: #selector(updateDisplayerToProgress))
            self.displayLink?.add(to: .current, forMode: .commonModes)
        }
    }
    
    private func stopDisplayerLink() {
        self.displayLink?.remove(from: .current, forMode: .commonModes)
        self.displayLink?.invalidate()
        self.displayLink = nil
        FQ_SlideConfiguration.shared.currentDirection = FQ_SlideConfiguration.shared.transitionDirection
        FQ_SlideConfiguration.shared.transitionDirection = .None
    }
    
    //更新当前的值
    @objc func updateDisplayerToProgress() {
        
        if self.isFinish {
            self.currentProgress += 1.0 / 60.0
            
            if self.currentProgress > 1 {
                self.finish()
                self.stopDisplayerLink()
            }else{
                self.update(self.currentProgress)
            }
            
        }else{
            self.currentProgress -= 1.0 / 60.0
            
            if self.currentProgress < 0 {
                self.cancel()
                self.stopDisplayerLink()
            }else{
                self.update(self.currentProgress)
            }
        }
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: MaskCoverViewPanGestureRecognizer), object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: MaskCoverViewTapGestureRecognizer), object: nil)
    }
    
}


class MaskCoverView : UIView {
    
    
    static let shared = MaskCoverView.init(frame: CGRect.zero)
    
    private var panGesture : UIPanGestureRecognizer? = nil
    
    private override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.black
        let panGes = UIPanGestureRecognizer(target: self, action: #selector(handPanGestureRecognizer(panGesture:)))
        self.addGestureRecognizer(panGes)
        self.panGesture = panGes
        let tapGes = UITapGestureRecognizer(target: self, action: #selector(clickMaskCover(tapGesture:)))
        tapGes.numberOfTapsRequired = 1
        self.addGestureRecognizer(tapGes)
    }
    
    @objc func handPanGestureRecognizer(panGesture : UIPanGestureRecognizer) {
        
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: MaskCoverViewPanGestureRecognizer), object: panGesture)
    }
    
    @objc func clickMaskCover(tapGesture : UITapGestureRecognizer){
        
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: MaskCoverViewTapGestureRecognizer), object: self)
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}



class FQ_LateralSlideTransition: NSObject,UIViewControllerAnimatedTransitioning {
    
    var isPresent : Bool = true
    
    class func initWithLateralSlideTransition(isPresent : Bool) -> FQ_LateralSlideTransition {
        let slideTransition = FQ_LateralSlideTransition()
        slideTransition.isPresent = isPresent
        return slideTransition
    }
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return FQ_SlideConfiguration.shared.animationDuration
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        
        if isPresent {
            self.isPresentToVc(transitionContext: transitionContext)
        }else{
            self.isDismissToVc(transitionContext: transitionContext)
        }
        
    }
    
//    //这种操作其宽度为0.75的方式不可行.需要将宽度还是调整到全屏宽.这样可以兼容系统present方法
//    //转场动画的present部分
//    func isPresentToVc(transitionContext : UIViewControllerContextTransitioning) {
//
//        if  FQ_SlideConfiguration.shared.currentLateralSpreadsType == .Default {
//            FQ_SlideConfiguration.shared.currentPresetType = .DoubleSliding
//        }else if(FQ_SlideConfiguration.shared.currentLateralSpreadsType == .Different){
//            FQ_SlideConfiguration.shared.currentPresetType = FQ_SlideConfiguration.shared.transitionDirection == .Left ? FQ_SlideConfiguration.shared.leftPresetType : FQ_SlideConfiguration.shared.rightPresetType
//        }else if(FQ_SlideConfiguration.shared.currentLateralSpreadsType == .SingleLeft){
//            FQ_SlideConfiguration.shared.currentPresetType = FQ_SlideConfiguration.shared.leftPresetType
//            FQ_SlideConfiguration.shared.transitionDirection = .Left
//            FQ_SlideConfiguration.shared.currentDirection = .Left
//        }else if(FQ_SlideConfiguration.shared.currentLateralSpreadsType == .SingleRight){
//            FQ_SlideConfiguration.shared.currentPresetType = FQ_SlideConfiguration.shared.rightPresetType
//            FQ_SlideConfiguration.shared.transitionDirection = .Right
//            FQ_SlideConfiguration.shared.currentDirection = .Right
//        }
//
//        let num = FQ_SlideConfiguration.shared.transitionDirection == .Left ? 1 : -1
//
//        //获取初始值
//        let fromVc = transitionContext.viewController(forKey: .from)
//        let toVc   = transitionContext.viewController(forKey: .to)
//
//        //获取fromVc的截图view
//        let containerView = transitionContext.containerView
//        containerView.backgroundColor = UIColor.white
//        fromVc?.view.frame = containerView.bounds
//
//        if FQ_SlideConfiguration.shared.currentPresetType == .DoubleSliding || FQ_SlideConfiguration.shared.currentPresetType == .ScaleSliding
//        {
//            containerView .addSubview((toVc?.view)!)
//            containerView .addSubview((fromVc?.view)!)
//        }else{
//            containerView .addSubview((fromVc?.view)!)
//            containerView .addSubview((toVc?.view)!)
//        }
//
//        //不要使用全屏在外面.然后整个push出来.这样会导致一个问题.那就是中间会闪
//        var toVcTransform = CGAffineTransform.identity
//        var fromVcTransform = CGAffineTransform.identity
//        let scaleBackImg = UIImageView(image: FQ_SlideConfiguration.shared.scaleBackImg)
//
//
//        if FQ_SlideConfiguration.shared.currentPresetType == .SingleSliding {
//            let toVcX = num > 0 ? -ScreenW * 0.75 : ScreenW
//            toVc?.view.frame = CGRect(x:toVcX, y: 0, width: ScreenW , height: ScreenH)
//            toVcTransform = CGAffineTransform(translationX: CGFloat(num) * ScreenW * 0.75, y: 0)
//        }else if(FQ_SlideConfiguration.shared.currentPresetType == .ScaleSliding){
//
//            toVc?.view.frame = CGRect(x: -CGFloat(num) * ScreenW * 0.75 * 0.5, y: 0, width: ScreenW, height: ScreenH)
//            scaleBackImg.frame = containerView.bounds
//            scaleBackImg.transform = CGAffineTransform(scaleX: 1.4, y: 1.4)
//            containerView.addSubview(scaleBackImg)
//            containerView.insertSubview(scaleBackImg, at: 0)
//            scaleBackImg.tag = 90000
//
//            let t1 = CGAffineTransform(translationX: CGFloat(num) * ScreenW * 0.75, y: 0)
//            let t2 = CGAffineTransform(scaleX: 1.0, y: 0.8)
//            fromVcTransform = t1.concatenating(t2)
//
//            toVcTransform = CGAffineTransform(translationX:CGFloat(num) * ScreenW * 0.75 * 0.5  , y: 0)
//
//        }else{
//
//            toVc?.view.frame = CGRect(x: num > 0 ? -ScreenW * 0.75 * 0.5 : (1 - 0.75 * 0.5) * ScreenW , y: 0, width: ScreenW, height: ScreenH)
//
//            toVcTransform = CGAffineTransform(translationX:CGFloat(num) * ScreenW * 0.75 * 0.5, y: 0)
//            fromVcTransform = CGAffineTransform(translationX: CGFloat(num) * ScreenW * 0.75, y: 0)
//        }
//
//        let maskView = MaskCoverView.shared
//        maskView.alpha = 0.0
//        maskView.frame = (fromVc?.view.bounds)!
//        maskView.backgroundColor = FQ_SlideConfiguration.shared.coverColor
//        fromVc?.view.addSubview(maskView)
//
//        UIView.animateKeyframes(withDuration: self.transitionDuration(using: transitionContext), delay: 0, options: .layoutSubviews, animations: {
//            UIView.addKeyframe(withRelativeStartTime: 0, relativeDuration: 1.0, animations: {
//
//                toVc?.view.transform = toVcTransform
//                maskView.alpha = FQ_SlideConfiguration.shared.coverAlpha
//                fromVc?.view.transform = fromVcTransform
//                scaleBackImg.transform = CGAffineTransform.identity
//
//            })
//        }) { (bool) in
//            if !transitionContext.transitionWasCancelled{
//
//                transitionContext.completeTransition(true)
//                containerView.addSubview((fromVc?.view)!)
//                if FQ_SlideConfiguration.shared.currentPresetType == .ScaleSliding{
//
//                    if (fromVc?.isKind(of: UINavigationController.self))!{
//
//                        let naviVc = fromVc as! UINavigationController
//                        let array = (naviVc.navigationBar.subviews) as NSArray
//                        let backView = UIView()
//                        backView.backgroundColor = UIColor.white
//                        naviVc.navigationBar.insertSubview(backView, at: 0)
//                        backView.tag = 388888
//                        array.enumerateObjects({ (obj , idx , stop ) in
//
//                            let object = obj as AnyObject
//                            let objClass : AnyClass? = NSClassFromString("_UIBarBackground")
//                            let objBarClass : AnyClass? = NSClassFromString("_UINavigationBarBackground")
//                            if objClass != nil{
//                                let isOK = object.isKind(of: objClass!) as Bool
//                                if (isOK) {
//                                    let backgroundView = object as! UIView
//                                    //                                var temFrame  = CGRect(origin: backgroundView.frame.origin, size: backgroundView.frame.size)
//                                    //                                temFrame.size.height = 100
//                                    //                                backgroundView.frame = temFrame
//                                    backView.frame = backgroundView.frame
//                                }
//                            }
//
//                            if objBarClass != nil {
//                                let isBarOK = object.isKind(of: objBarClass!)  as Bool
//                                if (isBarOK) {
//                                    let backgroundView = object as! UIView
//                                    //                                var temFrame  = CGRect(origin: backgroundView.frame.origin, size: backgroundView.frame.size)
//                                    //                                temFrame.size.height = 64
//                                    //                                backgroundView.frame = temFrame
//                                    backView.frame = backgroundView.frame
//                                }
//                            }
//
//                        })
//                    }
//                }
//                if FQ_SlideConfiguration.shared.currentPresetType == .SingleSliding{
//                    containerView.insertSubview((fromVc?.view)!, at: 0)
//                }
//
//
//            }else{
//                transitionContext.completeTransition(false)
//                maskView.removeFromSuperview()
//            }
//        }
//    }
    
    
    //这种操作其宽度为0.75的方式不可行.需要将宽度还是调整到全屏宽.这样可以兼容系统present方法
    //转场动画的present部分
    func isPresentToVc(transitionContext : UIViewControllerContextTransitioning) {

        if  FQ_SlideConfiguration.shared.currentLateralSpreadsType == .Default {
            FQ_SlideConfiguration.shared.currentPresetType = .DoubleSliding
        }else if(FQ_SlideConfiguration.shared.currentLateralSpreadsType == .Different){
            FQ_SlideConfiguration.shared.currentPresetType = FQ_SlideConfiguration.shared.transitionDirection == .Left ? FQ_SlideConfiguration.shared.leftPresetType : FQ_SlideConfiguration.shared.rightPresetType
        }else if(FQ_SlideConfiguration.shared.currentLateralSpreadsType == .SingleLeft){
            FQ_SlideConfiguration.shared.currentPresetType = FQ_SlideConfiguration.shared.leftPresetType
            FQ_SlideConfiguration.shared.transitionDirection = .Left
            FQ_SlideConfiguration.shared.currentDirection = .Left
        }else if(FQ_SlideConfiguration.shared.currentLateralSpreadsType == .SingleRight){
            FQ_SlideConfiguration.shared.currentPresetType = FQ_SlideConfiguration.shared.rightPresetType
            FQ_SlideConfiguration.shared.transitionDirection = .Right
            FQ_SlideConfiguration.shared.currentDirection = .Right
        }

        let num = FQ_SlideConfiguration.shared.transitionDirection == .Left ? 1 : -1

        //获取初始值
        let fromVc = transitionContext.viewController(forKey: .from)
        let toVc   = transitionContext.viewController(forKey: .to)

        //获取fromVc的截图view
        let containerView = transitionContext.containerView
        containerView.backgroundColor = UIColor.white
        fromVc?.view.frame = containerView.bounds

        if FQ_SlideConfiguration.shared.currentPresetType == .DoubleSliding || FQ_SlideConfiguration.shared.currentPresetType == .ScaleSliding
        {
            containerView .addSubview((toVc?.view)!)
            containerView .addSubview((fromVc?.view)!)
        }else{
            containerView .addSubview((fromVc?.view)!)
            containerView .addSubview((toVc?.view)!)
        }

        //不要使用全屏在外面.然后整个push出来.这样会导致一个问题.那就是中间会闪
        var toVcTransform = CGAffineTransform.identity
        var fromVcTransform = CGAffineTransform.identity
        let scaleBackImg = UIImageView(image: FQ_SlideConfiguration.shared.scaleBackImg)


        if FQ_SlideConfiguration.shared.currentPresetType == .SingleSliding {
            let toVcX = num > 0 ? -ScreenW * 0.75 : ScreenW * 0.75
            toVc?.view.frame = CGRect(x:toVcX, y: 0, width: ScreenW, height: ScreenH)
            
            for subView in (toVc?.view.subviews)! {
                print("subView ==== > %@",subView)
                var subViewFrame = subView.frame
                if subViewFrame.size.width >= ScreenW * 0.75 {
                    subViewFrame.size.width = ScreenW * 0.75
                }
                if num < 0 {
                    subViewFrame.origin.x = ScreenW * 0.25
                }
                subView.frame = subViewFrame
            }
   
            toVcTransform = CGAffineTransform(translationX: CGFloat(num) * ScreenW * 0.75, y: 0)
        }else if(FQ_SlideConfiguration.shared.currentPresetType == .ScaleSliding){

            toVc?.view.frame = CGRect(x: -CGFloat(num) * ScreenW * 0.75 * 0.5, y: 0, width: ScreenW, height: ScreenH)
            scaleBackImg.frame = containerView.bounds
            scaleBackImg.transform = CGAffineTransform(scaleX: 1.4, y: 1.4)
            containerView.addSubview(scaleBackImg)
            containerView.insertSubview(scaleBackImg, at: 0)
            scaleBackImg.tag = 90000
            
            for subView in (toVc?.view.subviews)! {
                print("subView ==== > %@",subView)
                var subViewFrame = subView.frame
                if subViewFrame.size.width >= ScreenW * 0.75 {
                    subViewFrame.size.width = ScreenW * 0.75
                }
                if num < 0 {
                    subViewFrame.origin.x = ScreenW * 0.25
                }
                subView.frame = subViewFrame
            }


            let t1 = CGAffineTransform(translationX: CGFloat(num) * ScreenW * 0.75, y: 0)
            let t2 = CGAffineTransform(scaleX: 1.0, y: 0.8)
            fromVcTransform = t1.concatenating(t2)

            toVcTransform = CGAffineTransform(translationX:CGFloat(num) * ScreenW * 0.75 * 0.5  , y: 0)

        }else{
            
            toVc?.view.frame = CGRect(x: num > 0 ? -ScreenW * 0.75 * 0.5 : 0.5 * 0.75 * ScreenW , y: 0, width: ScreenW, height: ScreenH)
            
            for subView in (toVc?.view.subviews)! {
                print("subView ==== > %@",subView)
                var subViewFrame = subView.frame
                if subViewFrame.size.width >= ScreenW * 0.75 {
                    subViewFrame.size.width = ScreenW * 0.75
                }
                if num < 0 {
                    subViewFrame.origin.x = ScreenW * 0.25
                }
                subView.frame = subViewFrame
            }

            toVcTransform = CGAffineTransform(translationX:CGFloat(num) * ScreenW * 0.75 * 0.5, y: 0)
            fromVcTransform = CGAffineTransform(translationX: CGFloat(num) * ScreenW * 0.75, y: 0)
        }
        toVc?.view.setNeedsLayout()

        let maskView = MaskCoverView.shared
        maskView.alpha = 0.0
        maskView.frame = (fromVc?.view.bounds)!
        maskView.backgroundColor = FQ_SlideConfiguration.shared.coverColor
        fromVc?.view.addSubview(maskView)

        UIView.animateKeyframes(withDuration: self.transitionDuration(using: transitionContext), delay: 0, options: .layoutSubviews, animations: {
            UIView.addKeyframe(withRelativeStartTime: 0, relativeDuration: 1.0, animations: {

                toVc?.view.transform = toVcTransform
                maskView.alpha = FQ_SlideConfiguration.shared.coverAlpha
                fromVc?.view.transform = fromVcTransform
                scaleBackImg.transform = CGAffineTransform.identity

            })
        }) { (bool) in
            if !transitionContext.transitionWasCancelled{

                transitionContext.completeTransition(true)
                 containerView.addSubview((fromVc?.view)!)
                if FQ_SlideConfiguration.shared.currentPresetType == .ScaleSliding{

                if (fromVc?.isKind(of: UINavigationController.self))!{

                    let naviVc = fromVc as! UINavigationController
                    let array = (naviVc.navigationBar.subviews) as NSArray
                    let backView = UIView()
                    backView.backgroundColor = UIColor.white
                    naviVc.navigationBar.insertSubview(backView, at: 0)
                    backView.tag = 388888
                    array.enumerateObjects({ (obj , idx , stop ) in

                        let object = obj as AnyObject
                        let objClass : AnyClass? = NSClassFromString("_UIBarBackground")
                        let objBarClass : AnyClass? = NSClassFromString("_UINavigationBarBackground")
                        if objClass != nil{
                            let isOK = object.isKind(of: objClass!) as Bool
                            if (isOK) {
                                let backgroundView = object as! UIView
//                                var temFrame  = CGRect(origin: backgroundView.frame.origin, size: backgroundView.frame.size)
//                                temFrame.size.height = 100
//                                backgroundView.frame = temFrame
                                backView.frame = backgroundView.frame
                            }
                        }

                        if objBarClass != nil {
                            let isBarOK = object.isKind(of: objBarClass!)  as Bool
                            if (isBarOK) {
                                let backgroundView = object as! UIView
//                                var temFrame  = CGRect(origin: backgroundView.frame.origin, size: backgroundView.frame.size)
//                                temFrame.size.height = 64
//                                backgroundView.frame = temFrame
                                backView.frame = backgroundView.frame
                            }
                        }

                    })
                }
                }
                //这个操作.主要是考虑到使用系统present以后.控制器又变为原来大小.maskCover的手势无效的情况
                if (FQ_SlideConfiguration.shared.currentPresetType == .SingleSliding) || (FQ_SlideConfiguration.shared.currentPresetType == .DoubleSliding){
                    containerView.insertSubview((fromVc?.view)!, at: 0)
//                    toVc?.view.addSubview(maskView)
//                    maskView.frame = CGRect(x:CGFloat(num) * ScreenW * 0.75, y: 0, width: ScreenW, height: ScreenH)
//                    toVc?.view.insertSubview(maskView, at: 0)
                }//else{

                    containerView.insertSubview((fromVc?.view)!, aboveSubview: scaleBackImg)
                    toVc?.view.addSubview(maskView)
                    maskView.frame = (fromVc?.view.frame)!
                    toVc?.view.insertSubview(maskView, at: 0)
               // }


            }else{
                transitionContext.completeTransition(false)
                maskView.removeFromSuperview()
            }
        }
    }
    
    
    func isDismissToVc(transitionContext : UIViewControllerContextTransitioning) {
        
        //获取初始值
        let fromVc = transitionContext.viewController(forKey: .from)
        let toVc   = transitionContext.viewController(forKey: .to)
        
        let containerView = transitionContext.containerView
        
        if FQ_SlideConfiguration.shared.currentPresetType == .DoubleSliding || FQ_SlideConfiguration.shared.currentPresetType == .ScaleSliding
        {
            containerView .addSubview((fromVc?.view)!)
            containerView .addSubview((toVc?.view)!)
        }else{
            containerView .addSubview((toVc?.view)!)
            containerView .addSubview((fromVc?.view)!)
            
        }
    
        containerView.backgroundColor = UIColor.white
        
        let maskView = MaskCoverView.shared
        let imgView =  containerView.viewWithTag(90000)
        let coverView = UIView()
        
        if FQ_SlideConfiguration.shared.currentPresetType == .ScaleSliding{
            coverView.backgroundColor = UIColor.black.withAlphaComponent(0.3)
            toVc?.view.addSubview(coverView)
            coverView.frame = (toVc?.view.bounds)!
        }
        
        UIView.animate(withDuration: self.transitionDuration(using: transitionContext), animations: {
            
            fromVc?.view.transform = CGAffineTransform.identity
            maskView.alpha = 0.0
            coverView.alpha = 0.0
            toVc?.view.transform = CGAffineTransform.identity
            imgView?.transform = CGAffineTransform(scaleX: 1.4, y: 1.4)
            
            if FQ_SlideConfiguration.shared.currentPresetType == .ScaleSliding{
                
                if (toVc?.isKind(of: UINavigationController.self))!{
                    let naviVc = toVc as! UINavigationController
                    naviVc.navigationBar.viewWithTag(388888)?.removeFromSuperview()
                }
            }
 
        }) { (bool) in
            if !transitionContext.transitionWasCancelled{
                transitionContext.completeTransition(true)
                maskView.removeFromSuperview()
                coverView.removeFromSuperview()
            }else{
                transitionContext.completeTransition(false)
                containerView.insertSubview((fromVc?.view)!, aboveSubview: (toVc?.view)!)
                maskView.alpha = FQ_SlideConfiguration.shared.coverAlpha
                coverView.removeFromSuperview()
            }
        }
    }
}

