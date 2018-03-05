//
//  FQ_ToViewController.swift
//  YX_Animation
//
//  Created by mac on 2018/2/26.
//  Copyright © 2018年 mac. All rights reserved.
//

//添加手势驱动


import UIKit



class FQ_ToViewController: UIViewController,UIViewControllerTransitioningDelegate,UIViewControllerPreviewingDelegate {
    func previewingContext(_ previewingContext: UIViewControllerPreviewing, viewControllerForLocation location: CGPoint) -> UIViewController? {
        return nil
    }
    
    func previewingContext(_ previewingContext: UIViewControllerPreviewing, commit viewControllerToCommit: UIViewController) {}
    
    
    @IBOutlet weak var backCoverView: UIView!
    
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var contentLabel: UILabel!
    
    @IBOutlet weak var backBtn: UIButton!
    
    var backColor : UIColor!
    var titleStr : String!
    var bool : Bool = false
    
    var contextTransition : UIPercentDrivenInteractiveTransition? = nil
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
//        添加一个向下轻扫的手势//init(target: self, action: #selector(handerPanGesture:))
        
        let gesture = UIPanGestureRecognizer(target: self, action: #selector(handerPanGesture(pan:)))
        self.view.addGestureRecognizer(gesture)
    
    }
    

    override func viewWillAppear(_ animated: Bool) {
   
        super.viewWillAppear(animated)
        if titleStr != nil {
            self.titleLabel.text  = titleStr
            
        }
        
        if backColor != nil {
            self.backCoverView.backgroundColor = backColor
        }
        
    }
    
    
    
    @objc func handerPanGesture(pan : UIPanGestureRecognizer) {
        
        print("手势驱动")
        
        let offY = pan.translation(in: pan.view).y
       
        let progress = fabs((offY / (ScreenH - 40)))
        switch pan.state {
        case .began:
            
            //获取当前的手势状态
            self.contextTransition = UIPercentDrivenInteractiveTransition()
            self.dismissToVc()
            
            break
        case .changed:
            self.contextTransition?.update(progress)
            break
        case .ended:
            if progress > 0.5
            {
                self.contextTransition?.finish()
            }else{
                self.contextTransition?.cancel()
            }
            self.contextTransition = nil
            break
        case .failed:
            if progress > 0.5
            {
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
    
    //点击返回按钮
    @IBAction func clickBackBtn(_ sender: UIButton) {
        self.transitioningDelegate = self
        self.dismiss(animated: true, completion: nil)
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        
    
        if dismissed.isKind(of: FQ_ToViewController.self) {
            let transition = FQ_Transition()
            transition.isPresent = false
            return transition
        }else{
            return nil
        }
    }
    
    func interactionControllerForDismissal(using animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        return self.contextTransition
    }
    
    
    
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

}
extension FQ_ToViewController{
    //重写previewActionItems
    override var previewActionItems: [UIPreviewActionItem] {
        let action1 = UIPreviewAction(title: "跳转", style: .default) { (action, previewViewController) in
            let showVC = ViewController()
            showVC.hidesBottomBarWhenPushed = true
            previewViewController.navigationController?.pushViewController(showVC, animated: true)
        }
        let action3 = UIPreviewAction(title: "取消", style: .destructive) { (action, previewViewController) in
            print("我是取消按钮")
        }
        ////该按钮可以是一个组，点击该组时，跳到组里面的按钮。
        let subAction1 = UIPreviewAction(title: "测试1", style: .selected) { (action, previewViewController) in
            print("我是测试按钮1")
        }
        let subAction2 = UIPreviewAction(title: "测试2", style: .selected) { (action, previewViewController) in
            print("我是测试按钮2")
        }
        let subAction3 = UIPreviewAction(title: "测试3", style: .selected) { (action, previewViewController) in
            print("我是测试按钮3")
        }
        let groupAction = UIPreviewActionGroup(title: "更多", style: .default, actions: [subAction1, subAction2, subAction3])
        return [action1, action3, groupAction]
    }
    
}
