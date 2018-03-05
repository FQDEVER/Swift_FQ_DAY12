//
//  ViewController.swift
//  CustomLayout-Swift
//
//  Created by mac on 2018/1/6.
//  Copyright © 2018年 mac. All rights reserved.
//

import UIKit
import SnapKit

let ScrrenW = UIScreen.main.bounds.size.width
let ScrrenH = UIScreen.main.bounds.size.height

class ViewController: UIViewController,UICollectionViewDataSource,UICollectionViewDelegate{
    var dataArr :NSArray = []
    var dragCollection : UICollectionView? = nil
    override func viewDidLoad() {
        super.viewDidLoad()
        self.creatDataArr()
        self.creatCollectionView()
        if NSString.init(string: UIDevice.current.systemVersion).doubleValue >= 11.0 {
            self.dragCollection?.contentInsetAdjustmentBehavior = .never
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.dataArr.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell : FQ_CollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: "FQ_DragCollectionViewId", for: indexPath) as! FQ_CollectionViewCell
        
        cell.imgName = self.dataArr[indexPath.row] as? String

        return cell
    }
    
    func creatDataArr() {
        //swift遍历某个数
        let muDataArr = NSMutableArray.init()
        for index in 0...15 {
            print("\(index)")
            let indexStr = String.init(format: "Inspiration-%zd", index + 1)
            muDataArr.add(indexStr)
        }
        self.dataArr = muDataArr.copy() as! NSArray
    }
    
    func creatCollectionView() {

        let flowLayout = FQ_CollectionViewLayout()
        dragCollection = UICollectionView(frame: self.view.bounds, collectionViewLayout: flowLayout)
        dragCollection?.backgroundColor = UIColor.white
        dragCollection?.delegate = self
        dragCollection?.dataSource = self

        dragCollection?.register(FQ_CollectionViewCell.self, forCellWithReuseIdentifier: "FQ_DragCollectionViewId")
        self.view.addSubview(dragCollection!)
        dragCollection?.snp.makeConstraints({ (make) in
            make.edges.equalToSuperview()
        })
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

