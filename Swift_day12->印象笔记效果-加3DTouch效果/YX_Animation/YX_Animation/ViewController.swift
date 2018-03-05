//
//  ViewController.swift
//  FQ_TrasitionVc
//
//  Created by mac on 2018/1/23.
//  Copyright © 2018年 mac. All rights reserved.
//

import UIKit
let ScreenW = UIScreen.main.bounds.size.width
let ScreenH = UIScreen.main.bounds.size.height
let rowNumber = 20




class ViewController: UIViewController,UICollectionViewDataSource,UICollectionViewDelegate,UIViewControllerTransitioningDelegate,UIViewControllerPreviewingDelegate{
    
    var is3Dtouch : Bool = false
    
    var collectionView : UICollectionView?  = nil
    var selectIndex : IndexPath? = IndexPath.init(item: 0, section: 0) as IndexPath
    var orginRect : CGRect=CGRect.zero
    var visibleCells = [FQ_AnimationCell]()
    var colorArray  = NSMutableArray(array: [])
    
    override func viewDidLoad() {
        super.viewDidLoad()
      
        
        let random = arc4random() % 360 // 160 arc4random() % 360
        for index in 0 ..< rowNumber {
            let color = UIColor(hue: CGFloat((Int(random) + index * 6)).truncatingRemainder(dividingBy: 360.0) / 360.0, saturation: 0.8, brightness: 1.0, alpha: 1.0)
            colorArray.add(color)
        }
        
        UIApplication.shared.shortcutItems?.removeAll()
        
        let arrShortcutItem = NSMutableArray(array: UIApplication.shared.shortcutItems!)
        
        let shoreItem1 = UIApplicationShortcutItem(type: "OpenToViewController", localizedTitle: "ToViewC", localizedSubtitle: nil, icon: UIApplicationShortcutIcon.init(type: UIApplicationShortcutIconType.search), userInfo: nil)
        arrShortcutItem.add(shoreItem1)
        
        UIApplication.shared.shortcutItems = arrShortcutItem.copy() as? [UIApplicationShortcutItem]
    
        
        let flowLayout = FQ_AnimationFlowLayout()
        //调试左右滑动
        flowLayout.itemSize = CGSize(width: ScreenW, height: 50)
        flowLayout.minimumLineSpacing = 5
        flowLayout.minimumInteritemSpacing = 5
        flowLayout.scrollDirection = .vertical
        
        
        self.collectionView = UICollectionView(frame:CGRect(x: 10, y: 0, width: self.view.bounds.width - 20, height: self.view.bounds.height), collectionViewLayout: flowLayout)
        self.collectionView?.backgroundColor = UIColor.white
        self.collectionView?.delegate = self
        self.collectionView?.dataSource = self
        self.collectionView?.register(UINib.init(nibName: "FQ_AnimationCell", bundle: nil), forCellWithReuseIdentifier: "UICollectionViewCellID")
        self.view.addSubview(self.collectionView!)
        self.transitioningDelegate = self
    }
    

    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        
        if presented.isKind(of: FQ_ToViewController.self) {
            let transition = FQ_Transition()
            
            transition.isPresent = true
            
            return transition
        }else{
            return nil
        }
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return rowNumber
        
    }
    
    //给每个cell添加一个
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "UICollectionViewCellID", for: indexPath) as! FQ_AnimationCell
        cell.noteBookTitle.text = "笔记\(indexPath.row)"
        cell.noteBookTitle.sizeToFit()
        cell.noteBookTitle.frame = CGRect(x: 50, y: 0, width: cell.noteBookTitle.frame.size.width, height: 44)
        cell.backgroundColor = self.colorArray.object(at: indexPath.row) as? UIColor
        //给cell注册3D-Touch
        if self.responds(to: #selector(getter: traitCollection)) {
                if self.traitCollection.forceTouchCapability == .available{
                    self.registerForPreviewing(with: self as UIViewControllerPreviewingDelegate, sourceView: cell)
                }
        }
        
        return cell
    }
    
    func previewingContext(_ previewingContext: UIViewControllerPreviewing, viewControllerForLocation location: CGPoint) -> UIViewController? {
        let cell = previewingContext.sourceView
        let indexPath = (self.collectionView?.indexPath(for: previewingContext.sourceView as! UICollectionViewCell))!
        self.orginRect = cell.frame
        self.selectIndex = indexPath
        let presentationVc = FQ_ToViewController()
        presentationVc.backColor = cell.backgroundColor
        presentationVc.titleStr = "笔记\(indexPath.row)"
        self.is3Dtouch = true
        self.visibleCells = self.collectionView?.visibleCells as! [FQ_AnimationCell]
        return presentationVc
    }
    
    func previewingContext(_ previewingContext: UIViewControllerPreviewing, commit viewControllerToCommit: UIViewController) {
        self.showDetailViewController(viewControllerToCommit, sender: self)
    }
    

    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
       self.selectIndex = indexPath
        self.orginRect = (collectionView.cellForItem(at: indexPath)?.frame)!
        self.visibleCells = collectionView.visibleCells as! [FQ_AnimationCell]
        print("click-Index \(indexPath)")
        
        let toVc = FQ_ToViewController()
        toVc.transitioningDelegate = self
        self.present(toVc, animated: true, completion: nil)
        
    }
    
}






