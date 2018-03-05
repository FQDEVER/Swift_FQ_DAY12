//
//  FQ_DragCollectionView.swift
//  FQ_DragCollectionView-Swift
//
//  Created by mac on 2017/12/29.
//  Copyright © 2017年 mac. All rights reserved.
//

import UIKit


//获取当前的方向
var scrollDirection = UICollectionViewScrollDirection.horizontal


class FQ_DragCollectionView: UICollectionView {
    
    var tempCellView : UIView?
    var selectCell   : UICollectionViewCell?
    var attributedCellArr = NSMutableArray(array: [])
    var dataSourceArr : NSArray = []
    var edgeTime : CADisplayLink?
    typealias dataChangBlock = (NSArray) -> ()
    var dataArrChangBlock : dataChangBlock?
    
    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        let flowLayout = layout as! UICollectionViewFlowLayout
        scrollDirection = flowLayout.scrollDirection
        super.init(frame: frame, collectionViewLayout: layout)
        let gesture = UILongPressGestureRecognizer.init(target: self, action: #selector(longPressGestureMeth(longPress:)))
        gesture.minimumPressDuration = 1.0
        self.addGestureRecognizer(gesture)
    }
    required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    }

    @objc func longPressGestureMeth(longPress:UILongPressGestureRecognizer) {
        switch longPress.state {
        case .began:
            self.longPressBeganed(longPress: longPress)
            break
        case .changed:
            self.longPressChanged(longPress: longPress)
            break
        case .failed:
            self.longPressEnded(longPress: longPress)
            break
        case .ended:
            self.longPressEnded(longPress: longPress)
            break
        default:
            break
        }
    }
    
    //按压开始
    func longPressBeganed(longPress : UILongPressGestureRecognizer) {
        
        //获取所有cell数据
        for(index,_) in self.dataSourceArr.enumerated(){
            self.attributedCellArr.add([self.layoutAttributesForItem(at: NSIndexPath.init(item: index, section: 0) as IndexPath)])
        }
        self.startDisplayLink()
        let currentPoint = longPress.location(in: self)
        let currentIndex = self.indexPathForItem(at: currentPoint)
        let currentCell = self.cellForItem(at: currentIndex!)
        self.selectCell = currentCell
        //获取到cell以后.创建一个一样的View
        let tempCellView = UIView(frame: (currentCell?.frame)!)

        UIGraphicsBeginImageContext((currentCell?.frame.size)!)

        currentCell?.layer.render(in: UIGraphicsGetCurrentContext()!)
        
        let imgCurrent = UIGraphicsGetImageFromCurrentImageContext()
        
        UIGraphicsEndImageContext()
        
        tempCellView.layer.contents = imgCurrent?.cgImage
        
        self.addSubview(tempCellView)
        
        self.tempCellView = tempCellView
        //开启动画
        self.startAllCellAnimation()
        
        self.selectCell?.isHidden = true
    }
    
    //按压移动
    func longPressChanged(longPress : UILongPressGestureRecognizer) {
        
        let currentPoint = longPress.location(in: self)
        self.tempCellView?.center = currentPoint
        
        //获取当前的cell.并且替换
        let currentIndex = self.indexPathForItem(at: currentPoint)
        if currentIndex == nil {
            return
        }
        let selectIndex = self.indexPath(for: self.selectCell!)
        //更新数据
        let dataMuArr = NSMutableArray.init(array: self.dataSourceArr)
        let dataSelectItem = dataMuArr[(selectIndex?.row)!]
        dataMuArr .remove(dataSelectItem)
        dataMuArr .insert(dataSelectItem, at: (currentIndex?.row)!)
        self.dataSourceArr = dataMuArr.copy() as! NSArray
        self.moveItem(at:selectIndex! , to: currentIndex!)
        
        //回调更新数据
        if (dataArrChangBlock != nil) {
            dataArrChangBlock!(self.dataSourceArr)
        }
    }
    
    //按压结束
    func longPressEnded(longPress : UILongPressGestureRecognizer) {
        
        UIView.animate(withDuration: 0.2, animations: {
            self.tempCellView?.center = (self.selectCell?.center)!
        }) { (bool : Bool) in
            self.stopDisplayLink()
            self.stopAllCellAnimation()
            self.tempCellView?.isHidden = true
            self.selectCell?.isHidden = false
            self.tempCellView?.removeFromSuperview()
            self.tempCellView = nil
        }
    }
    
    func startAllCellAnimation() {
        //遍历当前所有元素
        for collecItemCell : UICollectionViewCell in self.visibleCells {

            let keyframeAnimation = CAKeyframeAnimation.init(keyPath: "transform.rotation")
            keyframeAnimation.values = [(-4)/180.0*Double.pi,(4)/180.0*Double.pi,(-4)/180.0*Double.pi]
            keyframeAnimation.repeatCount = MAXFLOAT
            keyframeAnimation.duration = 0.2
            if (collecItemCell.layer.animation(forKey: "shaking") == nil){
                collecItemCell.layer .add(keyframeAnimation, forKey: "shaking")
            }
        }
    }
    
    func stopAllCellAnimation() {
        //遍历当前所有元素
        for collecItemCell : UICollectionViewCell in self.visibleCells {
            if (collecItemCell.layer.animation(forKey: "shaking") != nil){
                collecItemCell.layer .removeAnimation(forKey: "shaking")
            }
        }
    }
    
    //开启定时器
    func startDisplayLink() {
        if edgeTime == nil{
            edgeTime = CADisplayLink(target: self, selector: #selector(startDisplayLinkMeth))
            edgeTime?.add(to: RunLoop.main, forMode: .commonModes)
        }
    }
    
    //结束定时器
    func stopDisplayLink() {
        if edgeTime != nil {
            edgeTime?.invalidate()
            edgeTime = nil
        }
    }
    
    //开启定时器,循环监听边缘事件
    @objc func startDisplayLinkMeth() {
        
        if scrollDirection == .horizontal { //水平
            
            if((self.tempCellView?.frame.origin.x)! < self.contentOffset.x && self.contentOffset.x >= 0){//左
                self.contentOffset = CGPoint(x: self.contentOffset.x - 4 >= 0 ? self.contentOffset.x - 4: 0 , y: 0)
                self.tempCellView?.center.x = (self.tempCellView?.center.x)! - 4
            }else if((self.tempCellView?.frame.origin.x)! > self.contentOffset.x + ScrrenW - (self.tempCellView?.frame.size.width)! && self.contentOffset.x + ScrrenW < self.contentSize.width){ //右
                self.contentOffset = CGPoint(x: self.contentOffset.x + 4 <= self.contentSize.width - ScrrenW ? self.contentOffset.x + 4: self.contentSize.width - ScrrenW , y: 0)
                self.tempCellView?.center.x = (self.tempCellView?.center.x)! + 4
            }
        }else{//竖直方向
            if((self.tempCellView?.frame.origin.y)! < self.contentOffset.y && self.contentOffset.y >= 0){//上
                self.contentOffset = CGPoint(x:0, y: self.contentOffset.y - 4 >= 0 ? self.contentOffset.y - 4: 0 )
                self.tempCellView?.center.y = (self.tempCellView?.center.y)! - 4
            }else if((self.tempCellView?.frame.origin.y)! > self.contentOffset.y + ScrrenH - (self.tempCellView?.frame.size.height)! && self.contentOffset.y + ScrrenH < self.contentSize.height){ //下
                self.contentOffset = CGPoint(x: 0 , y: self.contentOffset.y + 4 <= self.contentSize.height - ScrrenH ? self.contentOffset.y + 4: self.contentSize.height - ScrrenH)
                self.tempCellView?.center.y = (self.tempCellView?.center.y)! + 4
            }
        }
        //开启动画
        self.startAllCellAnimation()
    }
    
}
