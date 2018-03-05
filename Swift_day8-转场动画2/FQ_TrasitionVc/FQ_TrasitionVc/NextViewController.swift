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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.orange
        let ges = UIPanGestureRecognizer(target: self, action: #selector(clickPanGesture(panGesture:)))
        self.view.addGestureRecognizer(ges)
    }


@objc func clickPanGesture(panGesture : UIPanGestureRecognizer) {
    
    let offY = panGesture.translation(in: panGesture.view).y
    
    let progress = (offY / 400)//这个地方还需要继续测试
    print("==========\(offY) =====\(progress)")
    switch panGesture.state {
    case .began:
        self.contextTransition = UIPercentDrivenInteractiveTransition()
        self.dismissToVc()
        break
    case .changed:
        self.contextTransition?.update(progress)
        break
    case .ended:
        if progress > 0.5{
            self.contextTransition?.finish()
        }else{
            self.contextTransition?.cancel()
        }
        self.contextTransition = nil
        break
    case .cancelled:
        if progress > 0.5{
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

    
    func dismissToVc() {
        self.transitioningDelegate = self
        self.dismiss(animated: true, completion: nil)
    }
    
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {

        let transition = FQ_Transition()
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
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
