//
//  ViewController.swift
//  FQ_TrasitionVc
//
//  Created by mac on 2018/1/23.
//  Copyright © 2018年 mac. All rights reserved.
//
//使用转场动画实现侧滑的效果

import UIKit

//let CWLateralSlideMaskViewKey = "CWLateralSlideMaskViewKey"
var CWLateralSlideAnimatorKey = "CWLateralSlideAnimatorKey"


//遵守TransitioningDelegate的代理
class FQ_TransitionAnimation : NSObject,UIViewControllerTransitioningDelegate {
    
//    var fromDrivenInteractive : FQ_PercentDrivenInteractive? = nil
//    var toDrivenInteractive : FQ_PercentDrivenInteractive? = nil
    var drivenInteractive : FQ_PercentDrivenInteractive? = nil
    class func initWithDrivenInterative(drivenInteractive : FQ_PercentDrivenInteractive) -> (FQ_TransitionAnimation) {
        let transtionAnimation = FQ_TransitionAnimation()
//        isFrom ? (transtionAnimation.fromDrivenInteractive = drivenInteractive) : (transtionAnimation.toDrivenInteractive = drivenInteractive)
        transtionAnimation.drivenInteractive = drivenInteractive
        return transtionAnimation
    }

    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {

        return FQ_LateralSlideTransition.initWithLateralSlideTransition(isPresent: true)
    }
    
    func interactionControllerForPresentation(using animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        return  self.drivenInteractive
    }
    
    
    
}

class FQ_PercentDrivenInteractive : UIPercentDrivenInteractiveTransition {

    
    var displayLink : CADisplayLink? = nil
    var remainingProgress : CGFloat = 0.0
    var currentProgress : CGFloat = 0.0
    var isFinish : Bool = true
    var contextVc : UIViewController? = nil { //这个是跳转到下一个的控制器
        didSet{
            //添加手势.这个
//            let ges = UIPanGestureRecognizer(target: self, action: #selector(clickPanGesture(panGesture:)))
//            self.contextVc?.view.addGestureRecognizer(ges)

            //        self.contextVc?.transitioningDelegate = self //这一步到下一个控制器分类走

        }
    }

    typealias ClickPresentBlock = (_ transitionDirection : FQTransitionDirectionType)->()
    var clickPresentBlock : ClickPresentBlock? = nil

    
    class func initWithContextVc(configuration : FQ_SlideConfiguration)->(FQ_PercentDrivenInteractive){
        return FQ_PercentDrivenInteractive()
    }
    
    func addGesture(fromVc : UIViewController) {
        //添加手势.这个
        let ges = UIPanGestureRecognizer(target: self, action: #selector(clickPanGesture(panGesture:)))
        fromVc.view.addGestureRecognizer(ges)
    }
    

    
    
    @objc func clickPanGesture(panGesture : UIPanGestureRecognizer) {
        
        let offX = panGesture.translation(in: panGesture.view).x
        var progress =  offX / ScreenW
    
        if(FQ_SlideConfiguration.shared.transitionDirection == .Right){
            progress = -progress
        }
        
        if panGesture.state == .began {
            if FQ_SlideConfiguration.shared.transitionDirection == .None{
                if offX >= 0  {
                    FQ_SlideConfiguration.shared.transitionDirection = .Left
                }else{
                    FQ_SlideConfiguration.shared.transitionDirection = .Right
                }
            }
            //首先在这里创建.随后回调preset的方法
//            self.percentDriven = UIPercentDrivenInteractiveTransition()
//            self.startPresent()
            //回调整个手势方法
            self.clickPresentBlock!(FQ_SlideConfiguration.shared.transitionDirection) //在这里获取上述的transition
            
            
        }else if panGesture.state == .changed {
            self.update(fmin(fmax(progress, 0.0), 1.0))
        }else if(panGesture.state == .cancelled || panGesture.state == .ended){
            self.continueWithTheTransition(progress: progress, isFinish: progress > 0.5)
            FQ_SlideConfiguration.shared.currentDirection = FQ_SlideConfiguration.shared.transitionDirection
            FQ_SlideConfiguration.shared.transitionDirection = .None
        }
        
    }
    
    
//    func startPresent() {
//        let nextViewC = NextViewController()
//        nextViewC.transitioningDelegate = self
//        self.modalPresentationStyle = .custom
//        self .present(nextViewC, animated: true, completion: nil)
//    }
    

  
    
    func continueWithTheTransition(progress: CGFloat,isFinish : Bool) {
        
        self.currentProgress = progress
        self.isFinish = isFinish
        self.startDisplayerLink()
    }
    
    func startDisplayerLink() {
        
        self.displayLink = CADisplayLink(target: self, selector: #selector(updateDisplayerToProgress))
        self.displayLink?.add(to: .current, forMode: .commonModes)
        
    }
    
    func stopDisplayerLink() {
        self.displayLink?.invalidate()
        self.displayLink = nil
    }
    
    //更新当前的值
    @objc func updateDisplayerToProgress() {
        
        if self.isFinish { //如果是完成
            self.currentProgress += 1.0 / 60.0
            
            if self.currentProgress > 1 {
                self.finish()
                self.stopDisplayerLink()
                
            }else{
                self.update(self.currentProgress)
            }
        }else{ //不是完成
            self.currentProgress -= 1.0 / 60.0
            
            if self.currentProgress < 0 {
                self.cancel()
                self.stopDisplayerLink()
                
            }else{
                self.update(self.currentProgress)
            }
        }
    }
    
    
}

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
        
        self.present(drawerVc, animated: true, completion: nil)
    }
    
    //给当前控制器添加手势
    func addGestureRecognizer(clickBlock : @escaping (FQTransitionDirectionType)->()) {

        //还需要获取
        let percentDriven = FQ_PercentDrivenInteractive()
        percentDriven.addGesture(fromVc: self)
        
        let transitionAnim = FQ_TransitionAnimation.initWithDrivenInterative(drivenInteractive: percentDriven)
        self.transitioningDelegate = transitionAnim
        
        percentDriven.clickPresentBlock = clickBlock
        
        objc_setAssociatedObject(self, &CWLateralSlideAnimatorKey, transitionAnim, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        
    }
    
    //左边转场
    func clickLeftTransition(drawerVc :  UIViewController) {
        FQ_SlideConfiguration.shared.transitionDirection = .Left
        FQ_SlideConfiguration.shared.currentDirection = .Left
        self.showLateralSlide(drawerVc: drawerVc)
    }
    //右边转场
    func clickRightTransition(drawerVc : UIViewController) {
        FQ_SlideConfiguration.shared.transitionDirection = .Right
        FQ_SlideConfiguration.shared.currentDirection = .Right
        self.showLateralSlide(drawerVc: drawerVc)
    }

}

class ViewController: UIViewController{
    
    override func viewDidLoad() {
        super.viewDidLoad()
        FQ_SlideConfiguration.shared.currentLateralSpreadsType = .Different
        FQ_SlideConfiguration.shared.leftPresetType = .ScaleSliding
        FQ_SlideConfiguration.shared.rightPresetType = .SingleSliding
        self.addGestureRecognizer { transitionDirection in
            if(transitionDirection == .Left){
                self.clickLeft()
            }else{
                self.clickRight()
            }
        }
    }
    
    @IBAction func clickLeft() {
        let nextVc = NextViewController()
        self.clickLeftTransition(drawerVc: nextVc)
    }


    @IBAction func clickRight() {
        let nextVc = NextViewController()
        self.clickRightTransition(drawerVc: nextVc)
    }
    
}

// class ViewController: UIViewController,UIViewControllerTransitioningDelegate {//把代理方法给抽出来.其次.把下面这个属性也抽出来
//
//    var contextTransition : UIPercentDrivenInteractiveTransition? = nil
//    var displayLink : CADisplayLink? = nil
//    var remainingProgress : CGFloat = 0.0
//    var currentProgress : CGFloat = 0.0
//    var isFinish : Bool = true
//
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        self.transitioningDelegate = self
//
//        let ges = UIPanGestureRecognizer(target: self, action: #selector(clickPanGesture(panGesture:)))
//
//        self.view.addGestureRecognizer(ges)
//
//    }
//
//    //左边转场
//     func clickLeftTransition() {
//        FQ_SlideConfiguration.shared.transitionDirection = .Left
//        FQ_SlideConfiguration.shared.currentDirection = .Left
//        self.startPresent()
//    }
//    //右边转场
//     func clickRightTransition() {
//        FQ_SlideConfiguration.shared.transitionDirection = .Right
//        FQ_SlideConfiguration.shared.currentDirection = .Right
//        self.startPresent()
//    }
//
//    @objc func clickPanGesture(panGesture : UIPanGestureRecognizer) {
//
//        let offX = panGesture.translation(in: panGesture.view).x
//        var progress =  offX / ScreenW
//
//
//        if(FQ_SlideConfiguration.shared.transitionDirection == .Right){
//            progress = -progress
//        }
//
//        if panGesture.state == .began {
//            if FQ_SlideConfiguration.shared.transitionDirection == .None{
//                if offX >= 0  {
//                    FQ_SlideConfiguration.shared.transitionDirection = .Left
//                }else{
//                    FQ_SlideConfiguration.shared.transitionDirection = .Right
//                }
//            }
//            self.contextTransition = UIPercentDrivenInteractiveTransition()
//            self.startPresent()
//        }else if panGesture.state == .changed {
//            self.contextTransition?.update(fmin(fmax(progress, 0.0), 1.0))
//        }else if(panGesture.state == .cancelled || panGesture.state == .ended){
//            self.continueWithTheTransition(progress: progress, isFinish: progress > 0.5)
//            FQ_SlideConfiguration.shared.currentDirection = FQ_SlideConfiguration.shared.transitionDirection
//            FQ_SlideConfiguration.shared.transitionDirection = .None
//        }
//
//    }
//
//
//    func startPresent() {
//        let nextViewC = NextViewController()
//        nextViewC.transitioningDelegate = self
//        self.modalPresentationStyle = .custom
//        self .present(nextViewC, animated: true, completion: nil)
//    }
//
//    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
//        let transition = FQ_LateralSlideTransition()
//        transition.isPresent = true
//        return transition
//    }
//
//    func interactionControllerForPresentation(using animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
//        return self.contextTransition
//    }
//
//    override func didReceiveMemoryWarning() {
//        super.didReceiveMemoryWarning()
//        // Dispose of any resources that can be recreated.
//    }
//
//    func continueWithTheTransition(progress: CGFloat,isFinish : Bool) {
//
//        self.currentProgress = progress
//        self.isFinish = isFinish
//        self.startDisplayerLink()
//    }
//
//    func startDisplayerLink() {
//
//        self.displayLink = CADisplayLink(target: self, selector: #selector(updateDisplayerToProgress))
//        self.displayLink?.add(to: .current, forMode: .commonModes)
//
//    }
//
//    func stopDisplayerLink() {
//        self.displayLink?.invalidate()
//        self.displayLink = nil
//    }
//
//    //更新当前的值
//    @objc func updateDisplayerToProgress() {
//
//        if self.isFinish { //如果是完成
//            self.currentProgress += 1.0 / 60.0
//
//            if self.currentProgress > 1 {
//                self.contextTransition?.finish()
//                self.stopDisplayerLink()
//                self.contextTransition = nil
//
//            }else{
//                self.contextTransition?.update(self.currentProgress)
//            }
//        }else{ //不是完成
//            self.currentProgress -= 1.0 / 60.0
//
//            if self.currentProgress < 0 {
//                self.contextTransition?.cancel()
//                self.stopDisplayerLink()
//                self.contextTransition = nil
//
//            }else{
//                self.contextTransition?.update(self.currentProgress)
//            }
//        }
//    }
//
//}


