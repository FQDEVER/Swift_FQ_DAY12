//
//  MoreCollectCell.swift
//  MoreCollectionCell
//
//  Created by mac on 2018/1/2.
//  Copyright © 2018年 mac. All rights reserved.
//

import UIKit

typealias getCurrentBlock = (UIImage)->(Void);
class MoreCollectCell: UICollectionViewCell {

    @IBOutlet weak var contentImg: UIImageView!
    
    @IBOutlet weak var contentTitleImageView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        if self.contentTitleImageView.subviews.count < 6 {
            self.customRoundedCorners() //图片上下文的方式
        }
    }
    

    func customRoundedCorners() {
        
        //获取新图片
        self.roundCorner(image: self.contentImg.image!,imgBlock: {(currentImg)->(Void) in
            self.contentImg.image = currentImg
        })
        
        for index in 0...6 {
            //创建多个图片
            let imgView = UIImageView(image: UIImage(named: "照片"))
            let w = self.contentTitleImageView.frame.size.width * 0.333
            let h = self.contentTitleImageView.frame.size.height * 0.5
            let x = CGFloat(index % 3) * w
            let y = CGFloat(Int(index / 3)) * h
            imgView.frame = CGRect(x: x, y: y, width: w, height: h)
            self.contentTitleImageView.addSubview(imgView)
            self.roundCorner(image: imgView.image!, imgBlock: {
                (currentImg)->(Void) in
                imgView.image = currentImg
            })
        }
        
        //view裁剪为圆角
//        self.roundCornerView(cornerView: self.contentTitleImageView)
    }
    
    
    //给图片添加圆角.通过上下文裁剪获取
    func roundCorner(image: UIImage,imgBlock:@escaping getCurrentBlock) {
        

            //开启上下文
            var rect = CGRect(x: 0, y: 0, width: image.size.width, height: image.size.height)
            
            let imageView = UIImageView(image: image)
            imageView.frame = rect
            
            //居中裁剪
            let minFloat = min(image.size.width, image.size.height)
            
            if(minFloat == image.size.width){
                rect = CGRect(x: 0, y: (image.size.height - minFloat) * 0.5, width: minFloat, height: minFloat)
            }else{
                rect = CGRect(x: (image.size.width - minFloat) * 0.5, y: 0, width: minFloat, height: minFloat)
            }
        
            UIGraphicsBeginImageContext(image.size)
            
            let bezierPath = UIBezierPath.init(roundedRect: rect, cornerRadius: minFloat * 0.5).cgPath
            
            let currentContext = UIGraphicsGetCurrentContext()
            
            currentContext?.addPath(bezierPath)
            
            currentContext?.clip()
        
            imageView.layer.render(in: currentContext!)
        
            //获取当前的图片
            let currentImg = UIGraphicsGetImageFromCurrentImageContext()
            
            UIGraphicsEndImageContext()
            
            DispatchQueue.main.async {
                imgBlock(currentImg!)
                print("异步操作------->\(String(describing: currentImg))")
            }
    }
    
    //给View添加圆角.使用mask属性实现
    func roundCornerView(cornerView : UIView) {
        
        //开启上下文
        var rect = CGRect(x: 0, y: 0, width: cornerView.bounds.size.width, height: cornerView.bounds.size.height)
        
        let minFloat = min(cornerView.bounds.size.width, cornerView.bounds.size.height)
        
        if(minFloat == cornerView.bounds.size.width){
            rect = CGRect(x: 0, y: (cornerView.bounds.size.height - minFloat) * 0.5, width: minFloat, height: minFloat)
        }else{
            rect = CGRect(x: (cornerView.bounds.size.width - minFloat) * 0.5, y: 0, width: minFloat, height: minFloat)
        }
        
        let bezierPath = UIBezierPath.init(roundedRect: rect, cornerRadius: minFloat * 0.5).cgPath
        let calayer = CAShapeLayer()
        calayer.frame = cornerView.bounds
        calayer.path = bezierPath
        cornerView.layer.mask = calayer
    }
    
    
    func systemRoundedCorners() {
        self.contentImg.layer.masksToBounds = false
        let minFloat = min(self.contentImg.frame.size.width, self.contentImg.frame.size.height)
        self.contentImg.layer.cornerRadius = minFloat * 0.5
        for index in 0...6 {
            //创建多个图片
            let imgView = UIImageView(image: UIImage(named: "照片"))
            let w = self.contentTitleImageView.frame.size.width/3
            let h = self.contentTitleImageView.frame.size.height / 3
            let x = CGFloat(index % 3) * w
            let y = CGFloat(Int(index / 3)) * h
            imgView.frame = CGRect(x: x, y: y, width: w, height: h)
            self.contentTitleImageView.addSubview(imgView)
            imgView.layer.masksToBounds = false
            imgView.layer.cornerRadius = h * 0.5
        }
    }
}
