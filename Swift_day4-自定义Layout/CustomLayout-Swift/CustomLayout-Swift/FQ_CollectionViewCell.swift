//
//  FQ_CollectionViewCell.swift
//  CustomLayout-Swift
//
//  Created by mac on 2018/1/6.
//  Copyright © 2018年 mac. All rights reserved.
//

import UIKit
import SnapKit



let minFont = CGFloat(18)
let maxFont = CGFloat(28)
let maxAlpha = CGFloat(0.75)

class FQ_CollectionViewCell: UICollectionViewCell {
    
    var imgView : UIImageView?
    var imgName : String?{
        didSet{
            self.imgView?.image = UIImage.init(named: imgName!);
            self.titleLabel.text = imgName
        }
    }
    //再创建文本和遮盖
    var coverView : UIView = UIView()
    var titleLabel: UILabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        imgView = UIImageView.init(frame: self.contentView.bounds)
        self.contentView.addSubview(imgView!)
        imgView?.contentMode = UIViewContentMode.scaleAspectFill
        imgView?.clipsToBounds = true
        imgView?.snp.makeConstraints({ (make) in
            make.edges.equalToSuperview()
        })
        
        self.contentView.addSubview(self.titleLabel)
        self.titleLabel.textColor = UIColor.white
        self.titleLabel.textAlignment = .center
        self.titleLabel.font = UIFont.systemFont(ofSize: minFont)
        self.titleLabel.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        
        self.contentView.addSubview(self.coverView)
        self.coverView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        self.coverView.alpha = maxAlpha
        self.coverView.backgroundColor = UIColor.black
        
    }
    
    override func preferredLayoutAttributesFitting(_ layoutAttributes: UICollectionViewLayoutAttributes) -> UICollectionViewLayoutAttributes {
        super .preferredLayoutAttributesFitting(layoutAttributes)
        
        if layoutAttributes.bounds.size.height > minContentH {
        
            //相差0.75 / 180 = x / max - h  色值区间 0- 0.75  字体区间 18 - 28
            
            let alphaProgress = CGFloat((layoutAttributes.bounds.size.height - minContentH) * maxAlpha / (maxContentH - minContentH))
            self.coverView.alpha = maxAlpha - alphaProgress;
            
            self.titleLabel.font = UIFont.systemFont(ofSize:  minFont + (maxFont - minFont) * alphaProgress/maxAlpha)
            
        }else{
            self.coverView.alpha = maxAlpha
            self.titleLabel.font = UIFont.systemFont(ofSize: minFont)
            
        }
        
        return layoutAttributes
    }
    
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    
    
    
}
