//
//  NextViewController.swift
//  CircleTransitions
//
//  Created by mac on 2018/1/16.
//  Copyright © 2018年 mac. All rights reserved.
//

import UIKit

class NextViewController: UIViewController,UINavigationControllerDelegate {
    //创建一个按钮
    let nextBtn : UIButton = UIButton(type: UIButtonType.custom)
    var transitionContext : UIPercentDrivenInteractiveTransition? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.green
        nextBtn.backgroundColor = UIColor.yellow
        nextBtn.frame = CGRect(x: 100, y: 100, width:100 , height: 100)
        nextBtn.layer.cornerRadius = 50
        nextBtn.layer.masksToBounds = true
        self.view.addSubview(nextBtn)
        nextBtn.addTarget(self, action: #selector(clickNextBtn), for: UIControlEvents.touchUpInside)
        
        //添加手势驱动
        let edgePan = UIScreenEdgePanGestureRecognizer(target: self, action: #selector(edgePanGesture(_:)))
        edgePan.edges = UIRectEdge.left
        
        self.view.addGestureRecognizer(edgePan)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
         self.navigationController?.delegate = self
    }
    
    @objc func edgePanGesture(_ edgePan : UIScreenEdgePanGestureRecognizer) {
        
        //获取当前的进度
        let progress = edgePan.translation(in: self.view).x / self.view.bounds.size.width
        print("===========\(progress)")

        if edgePan.state == .began {
            self.transitionContext = UIPercentDrivenInteractiveTransition()
            self.navigationController?.popViewController(animated: true)
        }else if(edgePan.state == .changed){
            self.transitionContext?.update(progress)
        }else if(edgePan.state == .cancelled || edgePan.state == .ended){//失败或者取消
            if progress > 0.5{
                self.transitionContext?.finish()
            }else{
                self.transitionContext?.cancel()
            }
            self.transitionContext = nil
        }else{
            print("\(edgePan.state)")
        }
    }
    
    func navigationController(_ navigationController: UINavigationController, interactionControllerFor animationController: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        if animationController.isKind(of:CircleTransitions.self) {
            return self.transitionContext
        }else{
            return nil
        }
    }
    
    func navigationController(_ navigationController: UINavigationController, animationControllerFor operation: UINavigationControllerOperation, from fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        if operation == .pop && fromVC.isKind(of: NextViewController.self) && toVC.isKind(of: ViewController.self) {
            let circleTransition = CircleTransitions()
            circleTransition.isPushVc = false
            return circleTransition
        }else{
            return nil
        }
    }
    
   @objc func clickNextBtn() {
        
        self.navigationController?.popViewController(animated: true)
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
