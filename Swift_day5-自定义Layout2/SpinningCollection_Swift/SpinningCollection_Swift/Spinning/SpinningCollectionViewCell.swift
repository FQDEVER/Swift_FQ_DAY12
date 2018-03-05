//
//  SpinningCollectionViewCell.swift
//  SpinningCollection_Swift
//
//  Created by mac on 2018/1/10.
//  Copyright © 2018年 mac. All rights reserved.
//

import UIKit

class SpinningCollectionViewCell: UICollectionViewCell {
    
    let contentImgView = UIImageView()
    var imgNameStr : String{
        didSet{
            self.contentImgView.image = UIImage.init(named: imgNameStr)
        }
    }
    //创建cell.
    override init(frame: CGRect) {
        self.imgNameStr = ""
        super.init(frame: frame)
        self.contentImgView.frame = self.contentView.bounds
        self.contentView.addSubview(self.contentImgView)
    }

    
    override func apply(_ layoutAttributes: UICollectionViewLayoutAttributes) {
        let spinningAttributes : SpinningCollectionLayoutAttributes = layoutAttributes as! SpinningCollectionLayoutAttributes
        self.layer.anchorPoint = spinningAttributes.anchorPoint
        self.center = CGPoint(x: self.center.x, y: self.center.y + (spinningAttributes.anchorPoint.y - 0.5) * self.bounds.size.height)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    
}
