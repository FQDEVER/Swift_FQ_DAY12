//
//  CircleTransitions.swift
//  CircleTransitions
//
//  Created by mac on 2018/1/16.
//  Copyright © 2018年 mac. All rights reserved.
//

//问题一.使用UIBaseAnimation做转场动画以后.手势驱动失效了.使用UIViewAnimation才有

import UIKit

let ScrrenW = UIScreen.main.bounds.size.width
let ScrrenH = UIScreen.main.bounds.size.height

class CircleTransitions: NSObject,UIViewControllerAnimatedTransitioning,CAAnimationDelegate {
    
    var isPushVc = false
    var transition : (Any)? = nil
    
     func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.33
    }

    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        self.transition = transitionContext
        if isPushVc == true {
            self.pushAnimationTransition(transitionContext: transitionContext)
        }else{
            self.popAnimationTransition(transitionContext: transitionContext)
        }
    }
    
    //push跳转
    private func pushAnimationTransition(transitionContext: UIViewControllerContextTransitioning) {
        let fromVc : ViewController = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.from) as! ViewController
        let toVc : NextViewController = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.to) as! NextViewController
        
        //获取中间的过渡 容器
        let animationView = transitionContext.containerView
        let fromView = fromVc.view
        let toView = toVc.view
        animationView.addSubview(fromView!)
        animationView.addSubview(toView!)

        let toBtn = toVc.nextBtn
    
        let maskLayer = CAShapeLayer()
        toView?.layer.mask = maskLayer
        //获取最新的半径长度
        let newRadius = sqrt((ScrrenW - toBtn.frame.maxX)*(ScrrenW - toBtn.frame.maxX) + (ScrrenH - toBtn.frame.maxY)*(ScrrenH - toBtn.frame.maxY))
        let startPath = UIBezierPath.init(ovalIn: toBtn.frame)
        let endPath = UIBezierPath.init(ovalIn: toBtn.frame.insetBy(dx: -newRadius, dy:-newRadius))

        maskLayer.path = endPath.cgPath
        let animationV = CABasicAnimation(keyPath: "path")
        animationV.fromValue = startPath.cgPath
        animationV.toValue = endPath.cgPath
        animationV.duration = self.transitionDuration(using: transitionContext)
        animationV.timingFunction = CAMediaTimingFunction.init(name: kCAMediaTimingFunctionEaseInEaseOut)
        animationV.isRemovedOnCompletion = false
        animationV.fillMode = kCAFillModeForwards
        animationV.delegate = self
        animationV.setValue(transitionContext, forKey:"transitionContext")
        maskLayer.add(animationV, forKey: "path")
        
        
        
        
//
//        fromView?.alpha = 1.0
//        toView?.alpha = 0.0
//        UIView.animate(withDuration: self.transitionDuration(using: transitionContext), animations: {
//            fromView?.alpha = 0.0
//            toView?.alpha = 1.0
//        }) { (bool) in
//            transitionContext.completeTransition(true)
//        }
    }
    
    //pop回调
    private func popAnimationTransition(transitionContext: UIViewControllerContextTransitioning) {
    
        let formVc  = transitionContext.viewController(forKey: .from) as! NextViewController
        let toVc = transitionContext.viewController(forKey: .to) as! ViewController
        
        let toView = toVc.view
        let fromView = formVc.view
        
        let animationView = transitionContext.containerView
        let fromBtn = formVc.nextBtn
        let toBtn = toVc.firstBtn
        
        animationView.addSubview(toView!)
        animationView.addSubview(fromView!)
        
      
//      开始动画.最开始是多少
        let maskLayer = CAShapeLayer()
//        //根据fromBtn获取其半径
        let newRadius = sqrt((ScrrenW - fromBtn.frame.maxX) * (ScrrenW - fromBtn.frame.maxX) + (ScrrenH - fromBtn.frame.maxY) * (ScrrenH - fromBtn.frame.maxY))
        fromView?.layer.mask = maskLayer

        let startPath = UIBezierPath.init(ovalIn: toBtn.frame.insetBy(dx: -newRadius, dy:-newRadius))
        let endPath   = UIBezierPath.init(ovalIn: fromBtn.frame)

        maskLayer.path = startPath.cgPath

        let baseAnimation = CABasicAnimation(keyPath: "path")
        baseAnimation.toValue = endPath.cgPath
        baseAnimation.fromValue = startPath.cgPath
        baseAnimation.duration = self.transitionDuration(using: transitionContext)
        baseAnimation.timingFunction = CAMediaTimingFunction.init(name: kCAMediaTimingFunctionEaseInEaseOut)
        baseAnimation.delegate = self
        baseAnimation.isRemovedOnCompletion = false
        baseAnimation.fillMode = kCAFillModeForwards
        baseAnimation.setValue(transitionContext, forKey:"transitionContext")
        maskLayer.add(baseAnimation, forKey: "path")
        

//        fromView?.alpha = 1.0
//        toView?.alpha = 0.0
//        UIView.animate(withDuration: self.transitionDuration(using: transitionContext), animations: {
////            fromView?.alpha = 0.0
////            toView?.alpha = 1.0
//
//        }) { (bool) in
//
//            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
//            transitionContext.viewController(forKey: UITransitionContextViewControllerKey.from)?.view.layer.mask = nil
//            transitionContext.viewController(forKey: UITransitionContextViewControllerKey.to)?.view.layer.mask = nil
//
//        }
    }
    
    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
    
        let transitionContext: UIViewControllerContextTransitioning = anim.value(forKey: "transitionContext") as! UIViewControllerContextTransitioning

        if isPushVc {
           
            transitionContext.completeTransition(true)
           
        }else{
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        }
        transitionContext.viewController(forKey: UITransitionContextViewControllerKey.to)?.view.layer.mask = nil
        transitionContext.viewController(forKey: UITransitionContextViewControllerKey.from)?.view.layer.mask = nil
    }
}
