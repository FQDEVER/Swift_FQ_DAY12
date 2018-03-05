//
//  FQ_SlideConfiguration.swift
//  FQLateralSlide
//
//  Created by mac on 2018/1/27.
//  Copyright © 2018年 mac. All rights reserved.
//

import UIKit

//转场的方向
public enum FQTransitionDirectionType : Int {
    
    case Left
    
    case Right
    
    case None
    
}

//侧滑的样式
public enum FQLateralSpreadsType : Int {
    
    case Default //侧滑使用默认样式
    
    case Same //左右侧滑样式相同
    
    case Different //左右侧滑样式不相同
    
    case SingleLeft //只侧滑左边
    
    case SingleRight //只侧滑右边
    
}

//转场样式
public enum FQTransitionPresetType : Int {
    
    case DoubleSliding = 1 //fromVc与toVc均正常滑动,
    
    case ScaleSliding //fromVc缩放滑动,toVc正常滑动
    
    case SingleSliding//fromVc不滑动,toVc正常滑动
    
}


class FQ_SlideConfiguration: NSObject {

    var coverColor : UIColor = UIColor.black                    //遮盖的颜色
    var coverAlpha : CGFloat = 0.3                              //遮盖的透明度
    var scaleBackImg : UIImage = UIImage(named: "0000")!        //缩放样式的背景图
    var animationDuration : TimeInterval = 0.33                      //动画时长
    var transitionDirection : FQTransitionDirectionType = .None //preset的方向
    var currentDirection : FQTransitionDirectionType = .None    //pop回来的方向
    var currentPresetType : FQTransitionPresetType = .SingleSliding //转场动画的样式
    var leftPresetType : FQTransitionPresetType = .ScaleSliding     //左边转场的样式
    var rightPresetType : FQTransitionPresetType = .SingleSliding   //右边转场的样式
    var currentLateralSpreadsType : FQLateralSpreadsType = .Default //转场侧滑的样式
    
    static let shared = FQ_SlideConfiguration.init()
    
    private override init() {
        super.init()
    }
    
    class func shortcutConfiguration(lateralSpreadsType:FQLateralSpreadsType?,currentPresetType:FQTransitionPresetType?) -> FQ_SlideConfiguration {
        let slideConfiguration = FQ_SlideConfiguration.shared
        if lateralSpreadsType != nil {slideConfiguration.currentLateralSpreadsType = lateralSpreadsType!}
        if currentPresetType != nil {slideConfiguration.currentPresetType = currentPresetType!}
        return slideConfiguration
    }
    
    
    /// 直接跳转的方向
    ///
    /// - Parameter directionType: 跳转方向
    class func transDirection(_ directionType : FQTransitionDirectionType) {
        
        let slideConfiguration = FQ_SlideConfiguration.shared
        slideConfiguration.transitionDirection = directionType
        slideConfiguration.currentDirection = directionType
    }

    
}
