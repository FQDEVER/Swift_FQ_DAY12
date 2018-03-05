//
//  FQ_AnimationFlowLayout.swift
//  YX_Animation
//
//  Created by mac on 2018/2/2.
//  Copyright © 2018年 mac. All rights reserved.
//

import UIKit

let space = CGFloat(10)

class FQ_AnimationFlowLayout: UICollectionViewFlowLayout {

    
    override func prepare() {
        super.prepare()
    }
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        
        let attributItems : [UICollectionViewLayoutAttributes] = super.layoutAttributesForElements(in: CGRect(origin: CGPoint.zero, size: self.collectionViewContentSize))!
        
        for (_ ,attributItem ) in attributItems.enumerated() {
            if attributItem.representedElementCategory == UICollectionElementCategory.cell{
                
                var cellFrame = attributItem.frame
                let offY = (self.collectionView?.contentOffset.y)!
                let bottomOffY = offY + (self.collectionView?.bounds.size.height)! - self.collectionViewContentSize.height
                
                if offY <= 0 { //如果小于零.即向下拉
                    cellFrame.origin.y += offY //保证collectionView不做偏移
                    //偏移指定的值
                    cellFrame.origin.y += fabs(CGFloat(attributItem.indexPath.row + 1) * offY / space)
                }else if(bottomOffY >= 0){//在底部.上推
                    cellFrame.origin.y += bottomOffY //保证collectionView不做偏移
                    //偏移指定的值
                    cellFrame.origin.y -= CGFloat(attributItems.count - attributItem.indexPath.row) * bottomOffY / space //
                }
                attributItem.frame = cellFrame
            }
        }
    
        return attributItems
    }
    
    override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        
      return true
    }
    
}

