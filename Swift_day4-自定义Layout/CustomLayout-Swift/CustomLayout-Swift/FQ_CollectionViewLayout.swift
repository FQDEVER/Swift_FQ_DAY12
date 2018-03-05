//
//  FQ_CollectionViewLayout.swift
//  CustomLayout-Swift
//
//  Created by mac on 2018/1/6.
//  Copyright © 2018年 mac. All rights reserved.
//

import UIKit

let minContentH = CGFloat(100)
let maxContentH = CGFloat(280)

class FQ_CollectionViewLayout: UICollectionViewLayout {
    
    let scrollY = maxContentH - minContentH
    let attributesArray = NSMutableArray()
    
    override init() {
        super.init()
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func prepare() {
        super.prepare()
        
        self.attributesArray.removeAllObjects()
        
        let cellCount = self.collectionView?.numberOfItems(inSection: 0)
        var indexY = CGFloat(0)
        
        for index in 0...cellCount!-1 {
            
            let layoutAttributes = UICollectionViewLayoutAttributes(forCellWith: IndexPath.init(item: index, section: 0))
            
            var indexH = minContentH
            if (index == getSelectCurrentIndex()){
                indexY = (self.collectionView?.contentOffset.y)! - minContentH * self.getScrollProgress()
                
                indexH =  minContentH + (maxContentH - minContentH) * (min(1, 1-self.getScrollProgress()))
                
            }else if(index == getSelectCurrentIndex() + 1 && index != cellCount){
                
                indexH = minContentH + max((maxContentH - minContentH) * self.getScrollProgress(), 0)
            }
            
            let rect = CGRect(x: 0, y: indexY, width: (self.collectionView?.bounds.size.width)! , height: indexH)
            
            layoutAttributes.frame = rect
            
            self.attributesArray.add(layoutAttributes)
            
            indexY = indexY + indexH
        }
        self.collectionView?.reloadData()
    }
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        return (self.attributesArray.copy() as! [UICollectionViewLayoutAttributes])
    }
    
    override var collectionViewContentSize: CGSize{
        return CGSize(width: (self.collectionView?.bounds.size.width)!, height: minContentH * CGFloat(self.attributesArray.count - 1) + maxContentH + (self.collectionView?.bounds.size.height)! - maxContentH)
    }
    
    override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        return true
    }
    
    func getSelectCurrentIndex() -> Int {
        
        let selectIndex = Int((self.collectionView?.contentOffset.y)! / minContentH)
        
        return max(selectIndex, 0)
    }
    
    
    func getScrollProgress() -> CGFloat {
        
        let progress = (self.collectionView?.contentOffset.y)! / minContentH - CGFloat(self.getSelectCurrentIndex())
        return progress
    }
    
}
