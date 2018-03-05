
//
//  FQ_Transition.swift
//  FQ_TrasitionVc
//
//  Created by mac on 2018/1/23.
//  Copyright © 2018年 mac. All rights reserved.
//

import UIKit

let ScreenW = UIScreen.main.bounds.size.width
let ScreenH = UIScreen.main.bounds.size.height

class FQ_Transition: NSObject,UIViewControllerAnimatedTransitioning {
    
    //添加一个属性
    var isPresent : Bool = true
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.33
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        
        if isPresent {
            self.isPresentToVc(transitionContext: transitionContext)
        }else{
            self.isDismissToVc(transitionContext: transitionContext)
        }
        
    }
    
    func isPresentToVc(transitionContext : UIViewControllerContextTransitioning) {
        
        //获取初始值
        let fromVc = transitionContext.viewController(forKey: .from)
        let toVc   = transitionContext.viewController(forKey: .to)
        
        //获取fromVc的截图view
        let snapshotView = fromVc?.view.snapshotView(afterScreenUpdates: false)
        snapshotView?.tag = 100
        fromVc?.view.isHidden = true
        let containerView = transitionContext.containerView
        containerView .addSubview(snapshotView!)
        containerView .addSubview((toVc?.view)!)
        
        toVc?.view.frame = CGRect(x: 0, y: ScreenH, width: ScreenW, height: 400)
        snapshotView?.frame = containerView.bounds
        
        
        UIView.animate(withDuration: self.transitionDuration(using: transitionContext), delay: 0, usingSpringWithDamping: 0.55, initialSpringVelocity: 1.0 / 0.55, options: .curveEaseIn, animations: {
            
            snapshotView?.transform =  CGAffineTransform(scaleX: 0.85, y: 0.85)
            
            toVc?.view.frame = CGRect(x: 0, y: ScreenH - 400, width: ScreenW, height: 400)
        }) { (bool) in
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
            if transitionContext.transitionWasCancelled
            {
                fromVc?.view.isHidden = false
                snapshotView?.removeFromSuperview()
            }
        }
        
    }
    
    func isDismissToVc(transitionContext : UIViewControllerContextTransitioning) {
        
        //获取初始值
        let fromVc = transitionContext.viewController(forKey: .from)
        let toVc   = transitionContext.viewController(forKey: .to)
        
        //获取fromVc的截图view
        toVc?.view.isHidden = true
        
        let containerView = transitionContext.containerView
        //获取截图View
        let snapshotView = containerView.viewWithTag(100)
        containerView .addSubview((fromVc?.view)!)
        containerView .addSubview((toVc?.view)!)
        
        fromVc?.view.frame = CGRect(x: 0, y: ScreenH - 400, width: ScreenW, height: 400)
        toVc?.view.frame = containerView.bounds
        
        //做动画
        UIView.animate(withDuration: self.transitionDuration(using: transitionContext), delay: 0.5, options: .curveEaseOut, animations: {
            
            snapshotView?.transform = CGAffineTransform.identity
        
            fromVc?.view.frame = CGRect(x: 0, y: ScreenH, width: ScreenW, height: 400)
            
        }) { (bool) in
            
            if transitionContext.transitionWasCancelled
            {
                transitionContext.completeTransition(false)
            }else{
                transitionContext.completeTransition(true)
                snapshotView?.removeFromSuperview()
                toVc?.view.isHidden = false
            }
        }
        
    }
}
