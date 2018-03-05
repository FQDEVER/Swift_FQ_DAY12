//
//  ViewController.swift
//  FQ_TrasitionVc
//
//  Created by mac on 2018/1/23.
//  Copyright © 2018年 mac. All rights reserved.
//

//说明:该demo借鉴OC版CWLateralSlide-master思路.链接:https://www.jianshu.com/p/6b83846d461c.写出该Swift版本
//对OC版本中出现缩放滑动效果时的顶部navigaitonBar异常简单处理
//对OC版本中缩放滑动效果present跳转再回来时点击以及滑动手势无效进行简单处理

//巨坑:如果有一个控制器的View.使用scale形变以后.其navigationBar的_UIBarBackground对象的fram值由64变为44—>没有找到合适的解决方案
//心得:设计非常巧妙.高度集成代码的妙处

import UIKit

class ViewController: UIViewController,UICollectionViewDataSource,UICollectionViewDelegate{
    
    var collectionView : FQ_CollectionView?  = nil
    let dataArr : [String] = [
                "fromVc与toVc均正常左滑动",
                "fromVc与toVc均正常右滑动",
                "fromVc缩放左滑动,toVc正常左滑动",
                "fromVc缩放右滑动,toVc正常右滑动",
                "fromVc不滑动,toVc正常左滑动",
                "fromVc不滑动,toVc正常右滑动"
    ]
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //===================> 1.注册侧滑手势
        self.addGestureRecognizer { transitionDirection in
            if(transitionDirection == .Left){
                self.clickLeft()
            }else{
                self.clickRight()
            }
        }
        
        let flowLayout = UICollectionViewFlowLayout()
        //调试左右滑动
        flowLayout.itemSize = CGSize(width: ScreenW * 0.5, height: ScreenH)
        flowLayout.minimumLineSpacing = 0
        flowLayout.minimumInteritemSpacing = 0
        flowLayout.scrollDirection = .horizontal

        self.collectionView = FQ_CollectionView(frame:CGRect.zero, collectionViewLayout: flowLayout)
        self.collectionView?.backgroundColor = UIColor.white
        //这个位置需要好好研究一下
//        if UIDevice.current.isIPhoneX() {
//            self.collectionView?.frame = CGRect(x: 0, y: 88, width: ScreenW, height: ScreenH - 88 - 34)
//        }else{
//            self.collectionView?.frame = CGRect(x: 0, y: 64, width: ScreenW, height: ScreenH - 64)
//        }
        self.collectionView?.frame = self.view.bounds
        
        //使用时需要说明一个问题:如果设置为false.self.view的布局默认是y=64开始布局.设置true.self.view的布局默认为y=0布局.不过collection始终保证在navigationBar下面.但是有一个问题.使用侧滑缩放的动画时.会导致navigationBar的UIbarbackground的frame变化为44.所以中间会有出现self.view的背景色情况.这个改变在viewdiddisapp之后.所以没有特别好的方法.只有设置为false.保证navigationBar的背景为白色.这样我就可以添加一个view.并且将该view添加到navigationBar中去.
        self.navigationController?.navigationBar.isTranslucent = false
        

        self.collectionView?.delegate = self
        self.collectionView?.dataSource = self
        self.collectionView?.bounces = false
        self.collectionView?.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "UICollectionViewCellID")
        self.view.addSubview(self.collectionView!)
    
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.dataArr.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "UICollectionViewCellID", for: indexPath)
        let tagView = cell.viewWithTag(100)
        if tagView == nil {
            let label = UILabel(frame: cell.contentView.bounds)
            label.textAlignment = .center
            label.numberOfLines = 0
            label.text = self.dataArr[indexPath.row]
            label.tag = 100
            cell.contentView.addSubview(label)
        }else{
            let label = tagView as! UILabel
            label.text = self.dataArr[indexPath.row]
        }
        cell.backgroundColor = UIColor(red: CGFloat(arc4random_uniform(255))/255.0, green: CGFloat(arc4random_uniform(255))/255.0, blue: CGFloat(arc4random_uniform(255))/255.0, alpha: 1.0)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        switch (indexPath.row) {
        case 0:
            self.handleDoubleSlidingToLeft()
            break;
        case 1:
            self.handleDoubleSlidingToRight()
            break;
        case 2:
            self.handleScaleSlidingToLeft()
            break;
        case 3:
            self.handleScaleSlidingToRight()
            break;
        case 4:
            self.handleSingleSlidingToLeft()
            break;
        case 5:
            self.handleSingleSlidingToRight()
        default:
            break;
        }
        
    }
    
//    "fromVc与toVc均正常左滑动",
    func handleDoubleSlidingToLeft() {
        
        let configuration = FQ_SlideConfiguration.shared
        configuration.currentLateralSpreadsType = .Same
        configuration.currentPresetType = .DoubleSliding //转场动画的样式
        let nextVc = RightVc()
        self.clickLeftTransition(drawerVc: nextVc)
    }
//    "fromVc与toVc均正常右滑动",
    func handleDoubleSlidingToRight() {
        
        let configuration = FQ_SlideConfiguration.shared
        configuration.currentLateralSpreadsType = .Same
        configuration.currentPresetType = .DoubleSliding //转场动画的样式
        let nextVc = RightVc()
        self.clickRightTransition(drawerVc: nextVc)
    }
//    "fromVc缩放左滑动,toVc正常左滑动",
    func handleScaleSlidingToLeft() {
        
        let configuration = FQ_SlideConfiguration.shared
        configuration.currentLateralSpreadsType = .Same
        configuration.currentPresetType = .ScaleSliding //转场动画的样式
        let nextVc = LeftVc()
        self.clickLeftTransition(drawerVc: nextVc)
    }
//    "fromVc缩放右滑动,toVc正常右滑动",
    func handleScaleSlidingToRight() {
        
        let configuration = FQ_SlideConfiguration.shared
        configuration.currentLateralSpreadsType = .Same
        configuration.currentPresetType = .ScaleSliding //转场动画的样式
        let nextVc = LeftVc()
        self.clickRightTransition(drawerVc: nextVc)
    }
//    "fromVc不滑动,toVc正常左滑动",
    func handleSingleSlidingToLeft() {
        
        let configuration = FQ_SlideConfiguration.shared
        configuration.currentLateralSpreadsType = .Same
        configuration.currentPresetType = .SingleSliding //转场动画的样式
        let nextVc = RightVc()
        self.clickLeftTransition(drawerVc: nextVc)
    }
//    "fromVc不滑动,toVc正常右滑动"
    func handleSingleSlidingToRight() {
        
        let configuration = FQ_SlideConfiguration.shared
        configuration.currentLateralSpreadsType = .Same
        configuration.currentPresetType = .SingleSliding //转场动画的样式
        let nextVc = RightVc()
        self.clickRightTransition(drawerVc: nextVc)
    }
    
    //===================> 2.实现滑动方法
    
    //点击左侧滑动
    @IBAction func clickLeft() {
        //设置配置参数,均不设置就使用默认值
        let configuration = FQ_SlideConfiguration.shared
        configuration.currentLateralSpreadsType = .Same
        configuration.currentPresetType = .ScaleSliding //转场动画的样式
        
        //currentLateralSpreadsType 如果设置为不同就需要设置左右
        //        configuration.currentLateralSpreadsType = .Different
        //        configuration.leftPresetType = .SingleSliding
        //        configuration.rightPresetType = .ScaleSliding
        
        let nextVc = LeftVc()
        self.clickLeftTransition(drawerVc: nextVc)
    }
    //点击右侧滑动
    @IBAction func clickRight() {
        //设置配置参数,均不设置就使用默认值
        let configuration = FQ_SlideConfiguration.shared
        configuration.currentLateralSpreadsType = .Same
        configuration.currentPresetType = .SingleSliding //转场动画的样式
        
        //currentLateralSpreadsType 如果设置为不同就需要设置左右
        //        configuration.currentLateralSpreadsType = .Different
        //        configuration.leftPresetType = .SingleSliding
        //        configuration.rightPresetType = .ScaleSliding
        
        let nextVc = RightVc()
        self.clickRightTransition(drawerVc: nextVc)
    }
    
}




