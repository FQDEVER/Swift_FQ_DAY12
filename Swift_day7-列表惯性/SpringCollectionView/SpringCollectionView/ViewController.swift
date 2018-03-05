//
//  ViewController.swift
//  SpringCollectionView
//
//  Created by mac on 2018/1/19.
//  Copyright © 2018年 mac. All rights reserved.
//

import UIKit


let ScreenW = UIScreen.main.bounds.size.width
let ScreenH = UIScreen.main.bounds.size.height

class FQ_SpringCollectionLayout: UICollectionViewFlowLayout {
    
    var animator : UIDynamicAnimator? = nil
    
    override func prepare() {
        super.prepare()
        
        if animator == nil {
            animator  = UIDynamicAnimator.init(collectionViewLayout: self)
            //给每一个cell.添加AttachmentBehavior
            
            let items : [UICollectionViewLayoutAttributes] = super.layoutAttributesForElements(in: CGRect(origin: CGPoint.zero, size: self.collectionViewContentSize))!
            
            for item in items{
                let spring = UIAttachmentBehavior(item: item, attachedToAnchor: item.center)
                spring.length = 0
                spring.damping = 0.5 //阻尼
                spring.frequency = 0.8 //频率
                animator?.addBehavior(spring)
            }
        }
    }
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        return  animator?.items(in: rect) as? [UICollectionViewLayoutAttributes]
    }
    
    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        return animator?.layoutAttributesForCell(at:indexPath)
    }
    
    override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        
        let scrollDelta =  newBounds.origin.y - (self.collectionView?.bounds.origin.y)!
        let touchLocation = self.collectionView?.panGestureRecognizer .location(in: self.collectionView)
        for item in (animator?.behaviors)! {
            
            let spring = item as! UIAttachmentBehavior
            let anchorPoint = spring.anchorPoint
            let distanceFormTouch = CGFloat(fabsf(Float(touchLocation!.y - anchorPoint.y)))
            let scrollResistance = distanceFormTouch / 500.0
            let springItem = spring.items.first
            var center = (springItem?.center)
            center?.y += (scrollDelta > 0) ? min(scrollDelta, scrollDelta * scrollResistance) : max(scrollDelta, scrollDelta * scrollResistance)
            springItem?.center = center!
            animator?.updateItem(usingCurrentState: springItem!)
        }
        return false
    }
    
}



class ViewController: UIViewController,UICollectionViewDataSource,UICollectionViewDelegate {

    
    var collectionView : UICollectionView? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.white
        let springCollectionLayout = FQ_SpringCollectionLayout()
        springCollectionLayout.itemSize = CGSize(width: self.view.frame.width, height: 44)

        collectionView = UICollectionView.init(frame: self.view.frame, collectionViewLayout: springCollectionLayout)
        collectionView?.backgroundColor = UIColor.clear
        collectionView?.dataSource = self
        collectionView?.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "CollectionViewID")
        self.view.insertSubview(collectionView!, at: 0)
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
       return 50
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CollectionViewID", for: indexPath)
        cell.backgroundColor = UIColor.orange
        return cell;
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

