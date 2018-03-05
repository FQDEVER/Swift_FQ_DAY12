//
//  NextViewController.swift
//  FQ_TrasitionVc
//
//  Created by mac on 2018/1/23.
//  Copyright © 2018年 mac. All rights reserved.
//

import UIKit

class NextViewController: UIViewController,UIViewControllerTransitioningDelegate {
    
    var contextTransition : UIPercentDrivenInteractiveTransition? = nil
    var displayLink : CADisplayLink? = nil
    var remainingProgress : CGFloat = 0.0
    var currentProgress : CGFloat = 0.0
    var isFinish : Bool = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let ges = UIPanGestureRecognizer(target: self, action: #selector(clickPanGesture(panGesture:)))
        self.view.addGestureRecognizer(ges)
        
        let leftView = UIImageView(image: UIImage(named: "1111"))
        leftView.frame = CGRect(x: 0, y: 0, width:self.view.frame.size.width * 0.75, height: ScreenH)
        self.view.addSubview(leftView)
        leftView.backgroundColor = UIColor.orange
        leftView.contentMode = .scaleAspectFit
        
        //点击tap手势
        NotificationCenter.default.addObserver(self, selector: #selector(dismissToVc), name: NSNotification.Name(rawValue: MaskCoverViewTapGestureRecognizer), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(notificationPanGesture(notification:)), name: NSNotification.Name(rawValue: MaskCoverViewPanGestureRecognizer), object: nil)
    }
    
    
    deinit {
        //点击这个就应该让其pop回去
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: MaskCoverViewPanGestureRecognizer), object: nil)
        
        //点击tap手势
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: MaskCoverViewTapGestureRecognizer), object: nil)
        
        print("NextVc========释放了吗")
    }

    
    @objc func notificationPanGesture(notification : Notification)
    {
            let panGesture = notification.object as! UIPanGestureRecognizer
            self.clickPanGesture(panGesture: panGesture)
    }
    
    
    @objc func clickPanGesture(panGesture : UIPanGestureRecognizer) {
        
        let offX = -panGesture.translation(in: panGesture.view).x
        var progress = offX / ScreenW

        if(FQ_SlideConfiguration.shared.currentDirection == .Right){
            progress = -progress
        }

        if panGesture.state == .began {
            self.contextTransition = UIPercentDrivenInteractiveTransition()
            self.dismissToVc()
        }else if panGesture.state == .changed {
            self.contextTransition?.update(fmin(fmax(progress, 0.0), 1.0))
        }else if(panGesture.state == .cancelled || panGesture.state == .ended){
            //做完成时的动画
            FQ_SlideConfiguration.shared.transitionDirection = .None
            self.continueWithTheTransition(progress: progress, isFinish: progress > 0.5)
        }
    }
    
    @objc func dismissToVc() {
        self.transitioningDelegate = self
        self.dismiss(animated: true, completion: nil)
    }
    
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        
        let transition = FQ_LateralSlideTransition()
        transition.isPresent = false
        return transition
    }
    
    func interactionControllerForDismissal(using animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
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
    
    //开启定时器
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
        print("2222=================>>>>\(currentProgress)")
    }
}
