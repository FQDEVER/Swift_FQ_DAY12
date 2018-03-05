//
//  FQ_CollectionView.swift
//  FQLateralSlide
//
//  Created by mac on 2018/2/1.
//  Copyright © 2018年 mac. All rights reserved.
//

import UIKit

class FQ_CollectionView: UICollectionView {

    //如果collection方向是水平..那就需要打开以后代码
//    override func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
//        if gestureRecognizer.isKind(of: UIPanGestureRecognizer.self) {
//            //获取对应的手势view
//            let panGesture = gestureRecognizer as! UIPanGestureRecognizer
//
//            if self.contentOffset.x == 0 && panGesture.translation(in: self).x > 0 { //代表此时在最左侧
//                return false
//            }else if(self.contentOffset.x + self.bounds.width == self.contentSize.width  && panGesture.translation(in: self).x < 0){
//                return false
//            }
//        }
//        return super.gestureRecognizerShouldBegin(gestureRecognizer)
//    }
}
