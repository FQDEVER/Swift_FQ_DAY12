//
//  ViewController.swift
//  CircleTransitions
//
//  Created by mac on 2018/1/16.
//  Copyright © 2018年 mac. All rights reserved.
//

import UIKit

class ViewController: UIViewController,UINavigationControllerDelegate {

    //创建一个按钮
    let firstBtn : UIButton = UIButton(type: UIButtonType.custom)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.orange
        firstBtn.backgroundColor = UIColor.white
        firstBtn.frame = CGRect(x: 100, y: 100, width:100 , height: 100)
        firstBtn.layer.cornerRadius = 50
        firstBtn.layer.masksToBounds = true
        self.view.addSubview(firstBtn)
        firstBtn.addTarget(self, action: #selector(clickFirstBtn), for: UIControlEvents.touchUpInside)
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.navigationController?.delegate = self
    }
    
    //push代理
    func navigationController(_ navigationController: UINavigationController, animationControllerFor operation: UINavigationControllerOperation, from fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        if (operation == UINavigationControllerOperation.push && fromVC.isKind(of: ViewController.self) && toVC.isKind(of: NextViewController.self)) {
            let transitions = CircleTransitions()
            transitions.isPushVc = true
            return transitions
        }else{
           return nil
        }
    }
    
    //跳转到下一个控制器
    @objc func clickFirstBtn() {
        
        self.navigationController!.pushViewController(NextViewController(), animated: true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

