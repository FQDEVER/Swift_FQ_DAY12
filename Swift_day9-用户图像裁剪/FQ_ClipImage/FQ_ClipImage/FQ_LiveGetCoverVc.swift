//
//  FQ_LiveGetCoverVc.swift
//  FQ_ClipImage
//
//  Created by mac on 2018/2/27.
//  Copyright © 2018年 mac. All rights reserved.
//

/*
 想要做出微信的效果还需完善
 */

import UIKit

let screenW = UIScreen.main.bounds.size.width
let screenH = UIScreen.main.bounds.size.height
let KEY_WINDOW = UIApplication.shared.keyWindow
//设置裁剪的宽高比
let AspectRatio = CGFloat(1.0)

class FQ_LiveGetCoverVc: UIViewController,UIScrollViewDelegate {
    
    //添加一个确定回调
    typealias confirmBlock = (_ image : UIImage) -> ()
    var clickConfirmBlock : confirmBlock?
    
    var orginIcon : UIImage!
    
    var completeIcon : UIImage!
    
    var contentImg : UIImageView!
    
    @IBOutlet weak var scroller: UIScrollView!
    
    @IBOutlet weak var topView: UIView!
    
    @IBOutlet weak var clearView: UIView!
    
    //中间裁剪部分的宽高比
    @IBOutlet weak var clearViewH: NSLayoutConstraint!
    
    //添加一个view.并且给view添加手势
    var scalingLineView : UIView!
    
    var subLayer : CAShapeLayer!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.creatUI()
    }
    
    func creatUI() {
        
        //获取内容Img
        self.contentImg = UIImageView()
        //添加到scrollerView上.根据宽高做比较
        self.contentImg.contentMode = .scaleAspectFit
        self.scroller.addSubview(self.contentImg)
        self.scroller.delegate = self
        self.scroller.clipsToBounds = false
        self.scroller.maximumZoomScale = 3.0
        self.scroller.minimumZoomScale = 1.0
        
        self.scalingLineView = UIView()
        self.view.addSubview(scalingLineView)
        self.scalingLineView.backgroundColor = UIColor.clear
        self.scalingLineView.isUserInteractionEnabled = false
        //给scalingLineView固定的几个位置添加手势
        
    }

    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return self.contentImg
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.view.layoutSubviews()
        //计算图片的高度
        self.clearViewH.constant = screenW / AspectRatio
        self.scalingLineView.frame = CGRect(x: 0, y: 0, width: screenW, height: screenW / AspectRatio)
        self.scalingLineView.center = CGPoint(x: screenW * 0.5, y: screenH * 0.5)
        
        //给clearView添加base曲线
        self.addBezierLinePath()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.contentImg.image = orginIcon
        
        UIView.animate(withDuration: 0.3) {
            self.scalingLineView.frame = self.clearView.frame
        }
        
        //计算图片的高度
        let imgH = screenW / (orginIcon.size.width / orginIcon.size.height)
        let boxH = screenW / AspectRatio
        if imgH >= boxH { //大于.就以宽度为screenW为准
            var rect = self.scroller.frame
            rect.origin.x = 0
            rect.origin.y = 0
            rect.size.width = self.scroller.frame.size.width
            rect.size.height = imgH
            self.contentImg.frame = rect
            self.scroller.contentSize = CGSize(width: 0, height: imgH)
            
        }else{ //小于就以高度为screenW
            let imgSizeW = boxH * (orginIcon.size.width / orginIcon.size.height)
            var rect = self.scroller.frame
            rect.origin.x = 0
            rect.origin.y = 0
            rect.size.width = imgSizeW
            rect.size.height = boxH
            self.contentImg.frame = rect
            self.scroller.contentSize = CGSize(width: imgSizeW, height: 0)
        }
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func clickConfirmBtn(_ sender: UIButton) {
        let completeImg = self.fullScreenshots()
        if clickConfirmBlock != nil {
            self.clickConfirmBlock!(completeImg)
            self.contentImg.isHidden = true
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    @IBAction func clickCancelBtn(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    //裁剪操作
    func fullScreenshots() -> UIImage {
        let img = self.orginIcon!
        let contentImgRect = self.view.convert(self.clearView.frame, to: self.contentImg)
        
        /*
         注: 因为self.contentImg在scrollView上.而scrollView的尺寸和clearView的尺寸一致.所以通过坐标转换完成以后,整个宽度就是scrollView宽度.计算实际的缩放比例scale即可
         */
        let scale = img.size.width / self.contentImg.bounds.size.width
//            (contentImgRect.size.width + contentImgRect.origin.x)
        let contentImgW = scale * contentImgRect.size.width
        let contentImgH = scale * contentImgRect.size.height
        let contentImgY = contentImgRect.origin.y * scale
        let contentImgX = contentImgRect.origin.x * scale
        let shotContentImgRect = CGRect(x: contentImgX, y: contentImgY, width: contentImgW, height: contentImgH)
        
        //做一个桥梁
        let  imgView = UIImageView(image: img)
        imgView.frame = CGRect(x: 0, y: 0, width: img.size.width, height: img.size.height)
        
        UIGraphicsBeginImageContext(img.size);//全屏截图，包括window
        imgView.layer.render(in: UIGraphicsGetCurrentContext()!)
        
        let viewImage = UIGraphicsGetImageFromCurrentImageContext();
        
        UIGraphicsEndImageContext();
        
        let imgeee = UIImage.init(cgImage: (viewImage?.cgImage?.cropping(to: shotContentImgRect))!)
    
        UIImageWriteToSavedPhotosAlbum(imgeee, nil, nil, nil);
        
        return imgeee;
    }
    
    func addBezierLinePath() {
        
        let scalingViewW = self.scalingLineView.bounds.size.width
        let scalingViewH = self.scalingLineView.bounds.size.height
        let coverW = self.scalingLineView.bounds.size.width - 4
        let coverH = self.scalingLineView.bounds.size.height - 4
        //        起点坐标是
        let startX = CGFloat(2)
        let startY = CGFloat(2)
        
        let startBezierPath = UIBezierPath(rect: CGRect(x: startX, y: startY, width: coverW, height: coverH))
        
        let bezierPath = UIBezierPath()
        bezierPath.move(to: CGPoint(x: (coverW / 3.0) + startX, y: startY))
        bezierPath.addLine(to: CGPoint(x: (coverW / 3.0) + startX, y: coverH + startY))
        
        bezierPath.move(to: CGPoint(x: coverW * 2.0 / 3.0 + startX, y: startY))
        bezierPath.addLine(to: CGPoint(x: coverW * 2.0 / 3.0, y: coverH + startY))
        
        bezierPath.move(to: CGPoint(x: startX, y: coverH / 3.0 + startY))
        bezierPath.addLine(to: CGPoint(x: coverW + startX, y: coverH / 3.0 + startY))
        
        bezierPath.move(to: CGPoint(x: startX, y: coverH * 2.0 / 3.0 + startY))
        bezierPath.addLine(to: CGPoint(x: coverW + startX, y: coverH * 2.0 / 3.0 + startY))
        
        let coarseBezierPath = UIBezierPath()
        coarseBezierPath.move(to: CGPoint(x: 0, y: 20))
        coarseBezierPath.addLine(to: CGPoint(x: 2, y: 20))
        coarseBezierPath.addLine(to: CGPoint(x: 2, y: 2))
        coarseBezierPath.addLine(to: CGPoint(x: 20, y: 2))
        coarseBezierPath.addLine(to: CGPoint(x: 20, y: 0))
        coarseBezierPath.addLine(to: CGPoint(x: 0, y: 0))
        coarseBezierPath.addLine(to: CGPoint(x: 0, y: 20))
        
        let coarseBezierPath1 = UIBezierPath()
        coarseBezierPath1.move(to: CGPoint(x: scalingViewW - 20, y: 0))
        coarseBezierPath1.addLine(to: CGPoint(x: scalingViewW, y: 0))
        coarseBezierPath1.addLine(to: CGPoint(x: scalingViewW, y: 20))
        coarseBezierPath1.addLine(to: CGPoint(x: scalingViewW - 2, y: 20))
        coarseBezierPath1.addLine(to: CGPoint(x: scalingViewW - 2, y: 2))
        coarseBezierPath1.addLine(to: CGPoint(x: scalingViewW - 20, y: 2))
        coarseBezierPath1.addLine(to: CGPoint(x: scalingViewW - 20, y: 0))
        
        let coarseBezierPath2 = UIBezierPath()
        coarseBezierPath2.move(to: CGPoint(x: scalingViewW, y: scalingViewH - 20))
        coarseBezierPath2.addLine(to: CGPoint(x: scalingViewW, y: scalingViewH))
        coarseBezierPath2.addLine(to: CGPoint(x: scalingViewW - 20, y: scalingViewH))
        coarseBezierPath2.addLine(to: CGPoint(x: scalingViewW - 20, y: scalingViewH - 2))
        coarseBezierPath2.addLine(to: CGPoint(x: scalingViewW - 2, y: scalingViewH - 2))
        coarseBezierPath2.addLine(to: CGPoint(x: scalingViewW - 2, y: scalingViewH - 20))
        coarseBezierPath2.addLine(to: CGPoint(x: scalingViewW, y: scalingViewH - 20))
        
        let coarseBezierPath3 = UIBezierPath()
        coarseBezierPath3.move(to: CGPoint(x: 20, y: scalingViewH))
        coarseBezierPath3.addLine(to: CGPoint(x: 0, y: scalingViewH))
        coarseBezierPath3.addLine(to: CGPoint(x: 0, y: scalingViewH - 20))
        coarseBezierPath3.addLine(to: CGPoint(x: 2, y: scalingViewH - 20))
        coarseBezierPath3.addLine(to: CGPoint(x: 2, y: scalingViewH - 2))
        coarseBezierPath3.addLine(to: CGPoint(x: 20, y: scalingViewH - 2))
        coarseBezierPath3.addLine(to: CGPoint(x: 20, y: scalingViewH))
        
        coarseBezierPath.append(coarseBezierPath1)
        coarseBezierPath.append(coarseBezierPath2)
        coarseBezierPath.append(coarseBezierPath3)
        
        let coarseLayer = CAShapeLayer()
        coarseLayer.lineWidth = 2.0
        coarseLayer.borderColor = UIColor.clear.cgColor
        coarseLayer.fillColor = UIColor.white.cgColor
        coarseLayer.strokeColor = UIColor.clear.cgColor
        coarseLayer.lineJoin = kCALineJoinRound
        coarseLayer.path = coarseBezierPath.cgPath
        coarseLayer.frame = self.scalingLineView.bounds
        
        let startLayer = CAShapeLayer()
        startLayer.lineWidth = 1.0
        startLayer.fillColor = UIColor.clear.cgColor
        startLayer.strokeColor = UIColor.white.cgColor
        startLayer.lineJoin = kCALineJoinRound
        startLayer.path = startBezierPath.cgPath
        startLayer.frame = self.scalingLineView.bounds
        
        let layer = CAShapeLayer()
        layer.lineWidth = 0.2
        layer.fillColor = UIColor.clear.cgColor
        layer.strokeColor = UIColor.white.cgColor
        layer.lineJoin = kCALineJoinRound
        layer.path = bezierPath.cgPath
        layer.frame = self.scalingLineView.bounds
        
        self.subLayer = CAShapeLayer()
        self.subLayer.frame = self.scalingLineView.bounds
        self.subLayer.addSublayer(layer)
        self.subLayer.addSublayer(startLayer)
        self.subLayer.addSublayer(coarseLayer)
        
        self.scalingLineView.layer.addSublayer(self.subLayer)
    }
    
//    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
//        let allTouches = event?.allTouches
//        let touch = allTouches?.first
//        let point = touch?.location(in: clearView)
//
//        //判断
//        if self.clearView.bounds.contains(point!) {
//            //那么那个边框就随着我的手势放大或者缩小
//            var frame = self.scalingLineView.frame
//            frame.size = CGSize(width: (point?.x)!, height: (point?.y)!)
//            self.scalingLineView.frame = frame
//            //更新路径
//            self.subLayer.removeFromSuperlayer()
//            self.subLayer = nil
//            self.addBezierLinePath()
//        }
//    }
    
}
