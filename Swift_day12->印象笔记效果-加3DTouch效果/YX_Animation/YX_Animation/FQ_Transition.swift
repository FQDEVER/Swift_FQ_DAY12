//
//  FQ_Transition.swift
//  YX_Animation
//
//  Created by mac on 2018/2/6.
//  Copyright © 2018年 mac. All rights reserved.
//

import UIKit

class FQ_Transition: NSObject,UIViewControllerAnimatedTransitioning {

    var isPresent : Bool = true

    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.45
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        
        if isPresent {
            self.presentTransition(transitionContext: transitionContext)
        }else{
            self.dissmissTransition(transitionContext: transitionContext)
        }
    }
    
    func presentTransition(transitionContext: UIViewControllerContextTransitioning){
        
        let fromVc = transitionContext.viewController(forKey: .from) as! ViewController
        let toVc = transitionContext.viewController(forKey: .to)  as! FQ_ToViewController
        let containerView = transitionContext.containerView
        let toView = toVc.view
        
        containerView.addSubview(toView!)
        toView?.frame = containerView.bounds
        toView?.isHidden = true
        let selectIndex = fromVc.selectIndex!
        let selectCell = fromVc.collectionView?.cellForItem(at:selectIndex) as! FQ_AnimationCell
        toVc.backCoverView.backgroundColor = selectCell.backgroundColor
        let selectCellToFrame = containerView.bounds
        selectCell.alpha = 1.0
        UIView.animate(withDuration: self.transitionDuration(using: transitionContext), animations: {
            for item in (fromVc.collectionView?.visibleCells)! {

                let index = fromVc.collectionView?.indexPath(for: item)
                
                if (index?.row)! < selectIndex.row{//这个在上面
//                    item.frame.origin.y -= selectCell.frame.origin.y - item.frame.origin.y + 30 //这种思路错误.不应该和每个cell的y做比较.应该和偏移值作比较
                    item.frame.origin.y -= (selectCell.frame.origin.y - ((fromVc.collectionView?.contentOffset.y)! + 10) + 30)
                    
                    item.transform = CGAffineTransform.init(scaleX: 0.8, y: 1.0)
                }else if((index?.row)! > selectIndex.row){//在下面

                    item.frame.origin.y += ((fromVc.collectionView?.contentOffset.y)! + selectCellToFrame.size.height) - fromVc.orginRect.maxY + 30
                    item.transform = CGAffineTransform.init(scaleX: 0.8, y: 1.0)
  
                }
            }

            selectCell.frame = containerView.convert(CGRect(x: 20, y: 20, width:ScreenW - 40, height: ScreenH - 40), to: fromVc.collectionView)
            selectCell.noteBookImg.alpha = 0.0
            selectCell.noteBookTitle.center = CGPoint(x:(ScreenW - 40) * 0.5, y: selectCell.noteBookTitle.center.y)
            selectCell.tempBackImg.alpha = 1.0
            
        }) { (bool) in
            //并且更新当前title的值
            toView?.isHidden = false
            toVc.titleLabel.text = selectCell.noteBookTitle.text
            //动画结束.判断是否完成动画
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        }
       
    }
    
    func dissmissTransition(transitionContext: UIViewControllerContextTransitioning){
        let fromVc = transitionContext.viewController(forKey: .from) as! FQ_ToViewController
        let toVc = transitionContext.viewController(forKey: .to)  as! ViewController
        let containerView = transitionContext.containerView
        let toView = toVc.view
        let fromView = fromVc.view
        
        containerView.addSubview(toView!)
        toView?.frame = containerView.bounds
        fromView?.isHidden = true
        toView?.isHidden = false
        let selectIndex = toVc.selectIndex!
        let selectCell = toVc.collectionView?.cellForItem(at:selectIndex) as! FQ_AnimationCell
        
        if toVc.is3Dtouch == true {//如果是3Dtouch过来.那么就需要实现present的操作.然后再执行dismiss操作
            
            for item in (toVc.collectionView?.visibleCells)! {
                
                let index = toVc.collectionView?.indexPath(for: item)
                
                if (index?.row)! < selectIndex.row{//这个在上面
                    //                    item.frame.origin.y -= selectCell.frame.origin.y - item.frame.origin.y + 30 //这种思路错误.不应该和每个cell的y做比较.应该和偏移值作比较
                    item.frame.origin.y -= (selectCell.frame.origin.y - ((toVc.collectionView?.contentOffset.y)! + 10) + 30)
                    
                    item.transform = CGAffineTransform.init(scaleX: 0.8, y: 1.0)
                }else if((index?.row)! > selectIndex.row){//在下面
                    
                    item.frame.origin.y += ((toVc.collectionView?.contentOffset.y)! + containerView.bounds.size.height) - toVc.orginRect.maxY + 30
                    item.transform = CGAffineTransform.init(scaleX: 0.8, y: 1.0)
            
                }
            }
            selectCell.frame = containerView.convert(CGRect(x: 20, y: 20, width:ScreenW - 40, height: ScreenH - 40), to: toVc.collectionView)
            selectCell.noteBookImg.alpha = 0.0
            selectCell.noteBookTitle.center = CGPoint(x:(ScreenW - 40) * 0.5, y: selectCell.noteBookTitle.center.y)
            selectCell.tempBackImg.alpha = 1.0
        }
        
        
        selectCell.alpha = 1.0
        UIView.animate(withDuration: self.transitionDuration(using: transitionContext), animations: {
            
            self.dismissedReduction3DTouchPresent(toVc: toVc, selectCell: selectCell,selectIndex: selectIndex)
            
        }) { (bool) in
            //动画结束.判断是否完成动画
            if transitionContext.transitionWasCancelled
            {
                transitionContext.completeTransition(false)
                fromView?.isHidden = false
                toView?.isHidden = true
                if toVc.is3Dtouch == true {//如果是3Dtouch过来.那么就需要实现present的操作.然后再执行dismiss操作
                    self.dismissedReduction3DTouchPresent(toVc: toVc, selectCell: selectCell,selectIndex: selectIndex)
                }
                
            }else{
                
                transitionContext.completeTransition(true)
                toVc.is3Dtouch = false
            }
        }
        
        
    }
    
    
    func dismissedReduction3DTouchPresent(toVc : ViewController , selectCell : FQ_AnimationCell ,selectIndex : IndexPath) {
        //保证还原
       
            
            for item in toVc.visibleCells {
                
                let index = toVc.collectionView?.indexPath(for: item)
                
                if (index?.row)! < selectIndex.row{//这个在上面
                    
                    item.frame.origin.y += (toVc.orginRect.origin.y - (selectCell.frame.origin.y) + 30 + 10)
                    
                    item.transform = CGAffineTransform.identity
                    
                }else if((index?.row)! > selectIndex.row){//在下面
                    
                    //这个计算不准确
                    item.frame.origin.y -= selectCell.frame.maxY - toVc.orginRect.maxY + 30 + 20  //这个20是间隔
                    item.transform = CGAffineTransform.identity
                    
                }
            }
            
            selectCell.frame = toVc.orginRect
            selectCell.noteBookImg.alpha = 1.0
            selectCell.noteBookTitle.frame = CGRect(x: 50, y: 0, width: selectCell.noteBookTitle.frame.size.width, height: 44)
            selectCell.tempBackImg.alpha = 0.0
        
    }
    
}
