//
//  SpinningCollectionLayoutAttributes.swift
//  SpinningCollection_Swift
//
//  Created by mac on 2018/1/8.
//  Copyright © 2018年 mac. All rights reserved.
//

import UIKit

class SpinningCollectionLayoutAttributes: UICollectionViewLayoutAttributes {

        //添加两个属性.一个是锚点一个是角度.
    var anchorPoint : CGPoint = CGPoint(x: 0.5, y: 0.5)
    var angle : CGFloat = 0.0


    override func copy(with zone: NSZone?) -> Any {
        let copiedAttributes: SpinningCollectionLayoutAttributes =
            super.copy(with:zone) as! SpinningCollectionLayoutAttributes
        copiedAttributes.anchorPoint = self.anchorPoint
        copiedAttributes.angle = self.angle
        return copiedAttributes
    }

}
