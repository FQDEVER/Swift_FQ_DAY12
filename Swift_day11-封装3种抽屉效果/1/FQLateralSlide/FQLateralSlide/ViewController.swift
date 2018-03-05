//
//  ViewController.swift
//  FQ_TrasitionVc
//
//  Created by mac on 2018/1/23.
//  Copyright © 2018年 mac. All rights reserved.
//
//使用转场动画实现侧滑的效果

import UIKit


 class ViewController: UIViewController,UIViewControllerTransitioningDelegate {//把代理方法给抽出来.其次.把下面这个属性也抽出来
    
    var contextTransition : UIPercentDrivenInteractiveTransition? = nil
    var displayLink : CADisplayLink? = nil
    var remainingProgress : CGFloat = 0.0
    var currentProgress : CGFloat = 0.0
    var isFinish : Bool = true
    

    override func viewDidLoad() {
        super.viewDidLoad()
        self.transitioningDelegate = self

        let ges = UIPanGestureRecognizer(target: self, action: #selector(clickPanGesture(panGesture:)))

        self.view.addGestureRecognizer(ges)

    }
    
    //左边转场
     func clickLeftTransition() {
        FQ_SlideConfiguration.shared.transitionDirection = .Left
        FQ_SlideConfiguration.shared.currentDirection = .Left
        self.startPresent()
    }
    //右边转场
     func clickRightTransition() {
        FQ_SlideConfiguration.shared.transitionDirection = .Right
        FQ_SlideConfiguration.shared.currentDirection = .Right
        self.startPresent()
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
            self.contextTransition = UIPercentDrivenInteractiveTransition()
            self.startPresent()
        }else if panGesture.state == .changed {
            self.contextTransition?.update(fmin(fmax(progress, 0.0), 1.0))
        }else if(panGesture.state == .cancelled || panGesture.state == .ended){
            self.continueWithTheTransition(progress: progress, isFinish: progress > 0.5)
            FQ_SlideConfiguration.shared.currentDirection = FQ_SlideConfiguration.shared.transitionDirection
            FQ_SlideConfiguration.shared.transitionDirection = .None
        }
       
    }
    
    
    func startPresent() {
        let nextViewC = NextViewController()
        nextViewC.transitioningDelegate = self
        self.modalPresentationStyle = .custom 
        self .present(nextViewC, animated: true, completion: nil)
    }
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        let transition = FQ_LateralSlideTransition()
        transition.isPresent = true
        return transition
    }
    
    func interactionControllerForPresentation(using animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        return self.contextTransition
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
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
                self.contextTransition?.finish()
                self.stopDisplayerLink()
                self.contextTransition = nil
                
            }else{
                self.contextTransition?.update(self.currentProgress)
            }
        }else{ //不是完成
            self.currentProgress -= 1.0 / 60.0
            
            if self.currentProgress < 0 {
                self.contextTransition?.cancel()
                self.stopDisplayerLink()
                self.contextTransition = nil
            
            }else{
                self.contextTransition?.update(self.currentProgress)
            }
        }
    }
    
}

