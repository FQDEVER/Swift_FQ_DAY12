
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
        
        //点击这个就应该让其pop回去
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: MaskCoverViewPanGestureRecognizer), object: panGesture)
    }
    
    @objc func clickMaskCover(tapGesture : UITapGestureRecognizer){
        
        //点击tap手势
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: MaskCoverViewTapGestureRecognizer), object: self)
    }
    

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
   
    
}



class FQ_LateralSlideTransition: NSObject,UIViewControllerAnimatedTransitioning {
    
    //添加一个属性
    var isPresent : Bool = true
    
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
    
////方案三 形变出现
//    //转场动画的present部分
//    func isPresentToVc(transitionContext : UIViewControllerContextTransitioning) {
//
//        //获取初始值
//        let fromVc = transitionContext.viewController(forKey: .from)
//        let toVc   = transitionContext.viewController(forKey: .to) as! NextViewController
//
//        //获取fromVc的截图view
//        let containerView = transitionContext.containerView
//        containerView.backgroundColor = UIColor.white
//        containerView .addSubview((toVc.view)!)
//        containerView .addSubview((fromVc?.view)!)
//        //不要使用全屏在外面.然后整个push出来.这样会导致一个问题.那就是中间会闪屏
//        fromVc?.view.frame = containerView.bounds
//
//        let num = TransitionDirection == .Left ? 1 : -1
//        let leftViewX = TransitionDirection == .Left ? 0 : ScreenW * 0.25
//
//        toVc.view.frame = CGRect(x: -CGFloat(num) * ScreenW * 0.75 * 0.5, y: 0, width: ScreenW, height: ScreenH)
//        toVc.leftView.frame = CGRect(x: leftViewX, y: 100, width: ScreenW * 0.75, height: ScreenH - 200)
//
//
//        let ImageView = UIImageView(image: UIImage(named: "0000"))
//        ImageView.frame = containerView.bounds
//        ImageView.transform = CGAffineTransform(scaleX: 1.4, y: 1.4)
//        containerView.addSubview(ImageView)
//        containerView.insertSubview(ImageView, at: 0)
//        ImageView.tag = 100
//
//
//        let maskView = MaskCoverView.shared
//        maskView.alpha = 0.0
//        maskView.frame = (fromVc?.view.bounds)!
//        fromVc?.view.addSubview(maskView)
//
//        let t1 = CGAffineTransform(translationX: CGFloat(num) * ScreenW * 0.75, y: 0)
//        let t2 = CGAffineTransform(scaleX: 1.0, y: 0.8)
//        let concatTrans = t1.concatenating(t2)
//
//
//        let toT1 = CGAffineTransform(translationX:CGFloat(num) * ScreenW * 0.75 * 0.5  , y: 0)
//
//        UIView.animateKeyframes(withDuration: self.transitionDuration(using: transitionContext), delay: 0, options: .layoutSubviews, animations: {
//            UIView.addKeyframe(withRelativeStartTime: 0, relativeDuration: 1.0, animations: {
//                fromVc?.view.transform = concatTrans
//                toVc.view.transform = toT1
//                ImageView.transform = CGAffineTransform.identity
//                maskView.alpha = 0.3
//            })
//        }) { (bool) in
//            if !transitionContext.transitionWasCancelled{
//                transitionContext.completeTransition(true)
//                containerView.addSubview((fromVc?.view)!)
//            }else{
//                transitionContext.completeTransition(false)
//                maskView.removeFromSuperview()
//            }
//        }
//    }
//
//    func isDismissToVc(transitionContext : UIViewControllerContextTransitioning) {
//
//        //获取初始值
//        let fromVc = transitionContext.viewController(forKey: .from)
//        let toVc   = transitionContext.viewController(forKey: .to)
//
//
//        let containerView = transitionContext.containerView
//        //获取截图View
//        containerView .addSubview((fromVc?.view)!)
//        containerView .addSubview((toVc?.view)!)
//        containerView.backgroundColor = UIColor.white
//
//        let maskView = MaskCoverView.shared
//        let imgView =  containerView.viewWithTag(100)
//
//        UIView.animate(withDuration: self.transitionDuration(using: transitionContext), animations: {
//
//            fromVc?.view.transform = CGAffineTransform.identity
//            toVc?.view.transform = CGAffineTransform.identity
//            maskView.alpha = 0.0
//            imgView?.transform = CGAffineTransform(scaleX: 1.4, y: 1.4)
//
//        }) { (bool) in
//            if !transitionContext.transitionWasCancelled{
//                transitionContext.completeTransition(true)
//                maskView.removeFromSuperview()
//            }else{
//                transitionContext.completeTransition(false)
//                maskView.alpha = 0.3
//            }
//        }
//
//
//    }
    
//方案二:在上层侧滑出来.下层不变

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
        let toVc   = transitionContext.viewController(forKey: .to) as! NextViewController

        //获取fromVc的截图view
        let containerView = transitionContext.containerView
        containerView.backgroundColor = UIColor.white
        fromVc?.view.frame = containerView.bounds
        
        if FQ_SlideConfiguration.shared.currentPresetType == .DoubleSliding || FQ_SlideConfiguration.shared.currentPresetType == .ScaleSliding
        {
            containerView .addSubview((toVc.view))
            containerView .addSubview((fromVc?.view)!)
        }else{
            containerView .addSubview((fromVc?.view)!)
            containerView .addSubview((toVc.view)!)
        }
        
        //不要使用全屏在外面.然后整个push出来.这样会导致一个问题.那就是中间会闪
        var toVcTransform = CGAffineTransform.identity
        var fromVcTransform = CGAffineTransform.identity
        let scaleBackImg = UIImageView(image: FQ_SlideConfiguration.shared.scaleBackImg)

        
        if FQ_SlideConfiguration.shared.currentPresetType == .SingleSliding {
            let toVcX = num > 0 ? -ScreenW * 0.75 : ScreenW
            toVc.view.frame = CGRect(x:toVcX, y: 0, width: ScreenW * 0.75, height: ScreenH)
            toVcTransform = CGAffineTransform(translationX: CGFloat(num) * ScreenW * 0.75, y: 0)
        }else if(FQ_SlideConfiguration.shared.currentPresetType == .ScaleSliding){

            let leftViewX = FQ_SlideConfiguration.shared.transitionDirection == .Left ? 0 : ScreenW * 0.25

            toVc.view.frame = CGRect(x: -CGFloat(num) * ScreenW * 0.75 * 0.5, y: 0, width: ScreenW, height: ScreenH)
            toVc.leftView.frame = CGRect(x: leftViewX, y: 100, width: ScreenW * 0.75, height: ScreenH - 200)

            scaleBackImg.frame = containerView.bounds
            scaleBackImg.transform = CGAffineTransform(scaleX: 1.4, y: 1.4)
            containerView.addSubview(scaleBackImg)
            containerView.insertSubview(scaleBackImg, at: 0)
            scaleBackImg.tag = 100

            let t1 = CGAffineTransform(translationX: CGFloat(num) * ScreenW * 0.75, y: 0)
            let t2 = CGAffineTransform(scaleX: 1.0, y: 0.8)
            fromVcTransform = t1.concatenating(t2)

            toVcTransform = CGAffineTransform(translationX:CGFloat(num) * ScreenW * 0.75 * 0.5  , y: 0)

        }else{
            let leftViewX = FQ_SlideConfiguration.shared.transitionDirection == .Left ? 0 : ScreenW * 0.25
            toVc.view.frame = CGRect(x: -CGFloat(num) * ScreenW * 0.75 * 0.5, y: 0, width: ScreenW, height: ScreenH)
            toVc.leftView.frame = CGRect(x: leftViewX, y: 0, width: ScreenW * 0.75, height: ScreenH)
            
            toVcTransform = CGAffineTransform(translationX:CGFloat(num) * ScreenW * 0.75 * 0.5, y: 0)
            fromVcTransform = CGAffineTransform(translationX: CGFloat(num) * ScreenW * 0.75, y: 0)
        }

        let maskView = MaskCoverView.shared
        maskView.alpha = 0.0
        maskView.frame = (fromVc?.view.bounds)!
        maskView.backgroundColor = FQ_SlideConfiguration.shared.coverColor
        fromVc?.view.addSubview(maskView)

        UIView.animateKeyframes(withDuration: self.transitionDuration(using: transitionContext), delay: 0, options: .layoutSubviews, animations: {
            UIView.addKeyframe(withRelativeStartTime: 0, relativeDuration: 1.0, animations: {

                toVc.view.transform = toVcTransform
                maskView.alpha = FQ_SlideConfiguration.shared.coverAlpha
                
//                if CurrentPresetType == .SingleSliding {
//                }else if(CurrentPresetType == .ScaleSliding){
                    fromVc?.view.transform = fromVcTransform
                    scaleBackImg.transform = CGAffineTransform.identity
//                }else{
//                    fromVc?.view.transform = fromVcTransform
//                }
                
            })
        }) { (bool) in
            if !transitionContext.transitionWasCancelled{
                transitionContext.completeTransition(true)
                containerView.addSubview((fromVc?.view)!)
                if FQ_SlideConfiguration.shared.currentPresetType == .SingleSliding{
                    containerView.insertSubview((fromVc?.view)!, at: 0)
                }
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
        let imgView =  containerView.viewWithTag(100)

        UIView.animate(withDuration: self.transitionDuration(using: transitionContext), animations: {

            fromVc?.view.transform = CGAffineTransform.identity
            maskView.alpha = 0.0
//            if CurrentPresetType == .SingleSliding {
//            }else if(CurrentPresetType == .ScaleSliding){
                toVc?.view.transform = CGAffineTransform.identity
                imgView?.transform = CGAffineTransform(scaleX: 1.4, y: 1.4)
//            }else{
//                toVc?.view.transform = CGAffineTransform.identity
//            }
            
        }) { (bool) in
            if !transitionContext.transitionWasCancelled{
                transitionContext.completeTransition(true)
                maskView.removeFromSuperview()
            }else{
                transitionContext.completeTransition(false)
                maskView.alpha = FQ_SlideConfiguration.shared.coverAlpha
            }
        }
    }


////方案一:同时侧滑出来的情况
//
//
//    //转场动画的present部分
//    func isPresentToVc(transitionContext : UIViewControllerContextTransitioning) {
//
//        //获取初始值
//        let fromVc = transitionContext.viewController(forKey: .from)
//        let toVc   = transitionContext.viewController(forKey: .to) as! NextViewController
//
//        //获取fromVc的截图view
//        let containerView = transitionContext.containerView
//        containerView.backgroundColor = UIColor.white
//        containerView .addSubview((toVc.view))
//        containerView .addSubview((fromVc?.view)!)
//        //不要使用全屏在外面.然后整个push出来.这样会导致一个问题.那就是中间会闪屏
//        fromVc?.view.frame = containerView.bounds
//
//        let leftViewX = TransitionDirection == .Left ? 0 : ScreenW * 0.25
//
//        let num = TransitionDirection == .Left ? 1 : -1
//
//        toVc.view.frame = CGRect(x: -CGFloat(num) * ScreenW * 0.75 * 0.5, y: 0, width: ScreenW, height: ScreenH)
//        toVc.leftView.frame = CGRect(x: leftViewX, y: 0, width: ScreenW * 0.75, height: ScreenH)
//
//        let maskView = MaskCoverView.shared
//        maskView.alpha = 0.0
//        maskView.frame = (fromVc?.view.bounds)!
//        fromVc?.view.addSubview(maskView)
//
//        UIView.animateKeyframes(withDuration: self.transitionDuration(using: transitionContext), delay: 0, options: .layoutSubviews, animations: {
//             UIView.addKeyframe(withRelativeStartTime: 0, relativeDuration: 1.0, animations: {
//                toVc.view.transform = CGAffineTransform(translationX:CGFloat(num) * ScreenW * 0.75 * 0.5, y: 0)
//                fromVc?.view.transform = CGAffineTransform(translationX: CGFloat(num) * ScreenW * 0.75, y: 0)
//                maskView.alpha = 0.3
//             })
//        }) { (bool) in
//            if !transitionContext.transitionWasCancelled{
//                transitionContext.completeTransition(true)
//                containerView.addSubview((fromVc?.view)!)
//            }else{
//                transitionContext.completeTransition(false)
//                maskView.removeFromSuperview()
//            }
//        }
//    }
//
//    func isDismissToVc(transitionContext : UIViewControllerContextTransitioning) {
//
//        //获取初始值
//        let fromVc = transitionContext.viewController(forKey: .from)
//        let toVc   = transitionContext.viewController(forKey: .to)
//
//
//        let containerView = transitionContext.containerView
//        //获取截图View
//        containerView .addSubview((fromVc?.view)!)
//        containerView .addSubview((toVc?.view)!)
//        containerView.backgroundColor = UIColor.white
//
//        let maskView = MaskCoverView.shared
//
//        UIView.animate(withDuration: self.transitionDuration(using: transitionContext), animations: {
//
//            fromVc?.view.transform = CGAffineTransform.identity
//            toVc?.view.transform = CGAffineTransform.identity
//            maskView.alpha = 0.0
//
//        }) { (bool) in
//            if !transitionContext.transitionWasCancelled{
//                transitionContext.completeTransition(true)
//                maskView.removeFromSuperview()
//            }else{
//
//                transitionContext.completeTransition(false)
//                maskView.alpha = 0.3
//            }
//        }
//
//
//    }
}

