//
//  ViewController.swift
//  FQ_TrasitionVc
//
//  Created by mac on 2018/1/23.
//  Copyright © 2018年 mac. All rights reserved.
//


import UIKit

class ViewController: UIViewController,UICollectionViewDataSource,UICollectionViewDelegate{
    

    var collectionView : FQ_CollectionView?  = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //设置配置参数
        let configuration = FQ_SlideConfiguration.shared
        configuration.currentLateralSpreadsType = .Same
        configuration.currentPresetType = .ScaleSliding //转场动画的样式
//        configuration.leftPresetType = .SingleSliding
//        configuration.rightPresetType = .SingleSliding
        //注册侧滑手势
        self.addGestureRecognizer { transitionDirection in
            if(transitionDirection == .Left){
                self.clickLeft()
            }else{
                self.clickRight()
            }
        }
        
        let flowLayout = UICollectionViewFlowLayout()
        //调试左右滑动
//        flowLayout.itemSize = CGSize(width: ScreenW, height: ScreenH)
//        flowLayout.minimumLineSpacing = 0
//        flowLayout.minimumInteritemSpacing = 0
//        flowLayout.scrollDirection = .horizontal
        flowLayout.itemSize = CGSize(width: ScreenW, height: 50)
        flowLayout.minimumLineSpacing = 5
        flowLayout.minimumInteritemSpacing = 5
        flowLayout.scrollDirection = .vertical
        
        self.collectionView = FQ_CollectionView(frame:CGRect.zero, collectionViewLayout: flowLayout)

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
        return 40
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "UICollectionViewCellID", for: indexPath)
        let tagView = cell.viewWithTag(100)
        if tagView == nil {
            let label = UILabel(frame: cell.contentView.bounds)
            label.text = String(describing: indexPath)
            label.tag = 100
            cell.contentView.addSubview(label)
        }else{
            let label = tagView as! UILabel
            label.text = String(describing: indexPath)
        }
        cell.backgroundColor = UIColor(red: CGFloat(arc4random_uniform(255))/255.0, green: CGFloat(arc4random_uniform(255))/255.0, blue: CGFloat(arc4random_uniform(255))/255.0, alpha: 1.0)
        return cell
    }

    //点击左侧滑动
    @IBAction func clickLeft() {
        let nextVc = LeftVc()
        self.clickLeftTransition(drawerVc: nextVc)
    }
    //点击右侧滑动
    @IBAction func clickRight() {
        let nextVc = LeftVc()
        self.clickRightTransition(drawerVc: nextVc)
    }
    
}




