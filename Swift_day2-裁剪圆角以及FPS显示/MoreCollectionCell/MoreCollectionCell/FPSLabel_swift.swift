//
//  FPSLabel_swift.swift
//  MoreCollectionCell
//
//  Created by mac on 2018/1/2.
//  Copyright © 2018年 mac. All rights reserved.
//
//简易实现一个FPS显示label

import UIKit

let KSize = CGSize(width: 55, height: 20)

class FPSLabel_swift: UILabel {
    
    var link :CADisplayLink? = nil
    var count:CUnsignedLong = 0
    var lastTime : CFTimeInterval = 0
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.creatUIView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //初始化UI
    func creatUIView() {
        
        self.layer.cornerRadius = 5
        self.layer.masksToBounds = true
        self.textAlignment = .center
        self.isUserInteractionEnabled = false
        self.backgroundColor = UIColor(white: 0.000, alpha: 0.700)
        self.link = CADisplayLink(target: self, selector: #selector(tick(link:)))
        self.link?.add(to: RunLoop.main, forMode: .commonModes)
    }
    
    @objc func tick(link : CADisplayLink)  {
        if self.lastTime == 0 {
            self.lastTime = link.timestamp
            return
        }
        
        self.count += 1
        let delta = link.timestamp - self.lastTime
        if ( delta < 1 ) {
            return
        }
        self.lastTime = link.timestamp;
        let fps = CGFloat(self.count)/CGFloat(delta);
        self.count = 0;
        self.font = UIFont.systemFont(ofSize: 20)
        self.textColor = UIColor.white
        self.text = String.init(format: "%.02f", fps);
        print("========>\(fps)")
    }
    
    override func delete(_ sender: Any?) {
        self.link?.invalidate()
    }
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
