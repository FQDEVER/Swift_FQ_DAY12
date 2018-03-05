//
//  SpinningWheelCollectionLayout.swift
//  SpinningCollection_Swift
//
//  Created by mac on 2018/1/15.
//  Copyright © 2018年 mac. All rights reserved.
//

import UIKit
let ScreenW = UIScreen.main.bounds.size.width
let ScreenH = UIScreen.main.bounds.size.height
let Radius = CGFloat(500)
let CellSize = CGSize(width: 133, height: 173)
let CellItemOffAngle = tan(CellSize.width / Radius)

class SpinningWheelCollectionLayout: UICollectionViewLayout {
    
    
    var attributesList = NSMutableArray()
    
    override class var layoutAttributesClass : AnyClass{
        return SpinningCollectionLayoutAttributes.self
    }

//    需要根据当前的cell获取每一个cell的尺寸.
//    如果是当前cell尺寸为1
//    后面的依次减少
    
    override func prepare() {
        super.prepare()
        self.attributesList.removeAllObjects()
        let cellCount = (self.collectionView?.numberOfItems(inSection: 0))!
        if (cellCount > 0) {

            let sumAngle = CellItemOffAngle * CGFloat(cellCount - 1)
            let firstAngle = -(self.collectionView?.contentOffset.x)! * sumAngle / ((self.collectionView?.contentSize.width)! - ScreenW)
            for index in 0...cellCount-1 {
                let spinningAttributes = SpinningCollectionLayoutAttributes(forCellWith: IndexPath(item: index, section: 0))
                let centerX = (self.collectionView?.contentOffset.x)! + ScreenW * 0.5
                let anchorPointY = (Radius + CellSize.height) / CellSize.height
                spinningAttributes.center = CGPoint(x: centerX, y: (self.collectionView?.bounds.size.height)! * 0.5)
                spinningAttributes.anchorPoint = CGPoint(x: 0.5, y: anchorPointY)
                spinningAttributes.angle = (firstAngle + CGFloat(index) * CellItemOffAngle)
                spinningAttributes.transform = CGAffineTransform(rotationAngle: spinningAttributes.angle)
                spinningAttributes.size = CellSize
                self.attributesList.add(spinningAttributes)
            }
        }
        self.collectionView?.reloadData()
    }

    override var collectionViewContentSize: CGSize {
        return CGSize(width: CGFloat(collectionView!.numberOfItems(inSection:0)) * CellSize.width,height: self.collectionView!.bounds.height)
    }

    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {

        return self.attributesList as? [UICollectionViewLayoutAttributes]
    }


    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        return (self.attributesList[indexPath.row] as! UICollectionViewLayoutAttributes)
    }

    override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        return true
    }
}
