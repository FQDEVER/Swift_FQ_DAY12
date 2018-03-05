//
//  ViewController.swift
//  FQ_TrasitionVc
//
//  Created by mac on 2018/1/23.
//  Copyright © 2018年 mac. All rights reserved.
//
//使用转场动画实现侧滑的效果

import UIKit


class ViewController: UIViewController,UIViewControllerTransitioningDelegate {

    var contextTransition : UIPercentDrivenInteractiveTransition? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.transitioningDelegate = self
        // Do any additional setup after loading the view, typically from a nib.
        
        //添加手势
        
        let ges = UIPanGestureRecognizer(target: self, action: #selector(clickPanGesture(panGesture:)))
        self.view.addGestureRecognizer(ges)
    }
    
    @objc func clickPanGesture(panGesture : UIPanGestureRecognizer) {

        let offY = panGesture.translation(in: panGesture.view).y
        let progress =  min((-offY / ScreenH) , 0.2166)

        switch panGesture.state {
        case .began:
            self.contextTransition = UIPercentDrivenInteractiveTransition()
            self.startPresent()
            break
        case .changed:
            self.contextTransition?.update(progress)
            break
        case .ended:
            if progress > 0.1083{
                self.contextTransition?.finish()
            }else{
                self.contextTransition?.cancel()
            }
            self.contextTransition = nil
            break
        case .cancelled:
            if progress > 0.1083{
                self.contextTransition?.finish()
            }else{
                self.contextTransition?.cancel()
            }
            self.contextTransition = nil
            break
        default:
            break
        }
    }

    func startPresent() {
        let nextViewC = NextViewController()
        nextViewC.transitioningDelegate = self
        self .present(nextViewC, animated: true, completion: nil)
    }
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        let transition = FQ_Transition()
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


}

