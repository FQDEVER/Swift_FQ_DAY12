//
//  ViewController.swift
//  Test_Position_AnchorPoint
//
//  Created by mac on 2018/1/9.
//  Copyright © 2018年 mac. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    let testView  = UIView(frame: CGRect(x: 100, y: 100, width: 100, height: 100))
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        testView.backgroundColor = UIColor.red
        testView.layer.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        print("\(testView.center)---->\(testView.layer.position)---->\(testView.frame)")
        self.view.addSubview(testView)
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
//        let oldRect = testView.frame
        testView.layer.anchorPoint = CGPoint(x:0.5, y: 0)
//        testView.frame = oldRect
        print("\(testView.center)---->\(testView.layer.position)---->\(testView.frame)")
        
//        结论: anchorPoint是相对bounds的比例值
//               position是相对父容器的坐标点
//         positionX = bounds.W * anchorPointX + frame.X
//         positionY = bounds.H * anchorPointY + frame.Y
//        当anchorPoint的值变化时.position的值没有变化.所以根据公式:
//        此时frame.Y = positionY - bounds.H * anchorPointY
//        获取与中心点的关系:
//        self.center.y += (anchorPointY - 0.5) * bounds.H
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

