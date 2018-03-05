//
//  ViewController.swift
//  FQ_DragCollectionView-Swift
//
//  Created by mac on 2017/12/29.
//  Copyright © 2017年 mac. All rights reserved.
//

import UIKit

let ScrrenW = UIScreen.main.bounds.size.width
let ScrrenH = UIScreen.main.bounds.size.height

class ViewController: UIViewController,UICollectionViewDataSource,UICollectionViewDelegate {

    
    var dataArr :NSArray = []
    var dragCollection : FQ_DragCollectionView? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.creatDataArr()
        self.creatCollectionView()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.dataArr.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FQ_DragCollectionViewId", for: indexPath)
        
        let label = UILabel.init(frame: cell.contentView.bounds)
        label.textAlignment = NSTextAlignment.center
        label.font = UIFont.systemFont(ofSize: 13)
        label.textColor = UIColor.white
        label.tag = 100
        if (cell.viewWithTag(100) == nil) {
            cell.contentView.addSubview(label)
            label.text = (self.dataArr[indexPath.row] as! String)
        }else{
            let oldLabel : UILabel = cell.viewWithTag(100) as! UILabel
            oldLabel.text = (self.dataArr[indexPath.row] as! String)
        }
        cell.backgroundColor = UIColor(displayP3Red: CGFloat(arc4random_uniform(255))/255.0, green:  CGFloat(arc4random_uniform(255))/255.0, blue:  CGFloat(arc4random_uniform(255))/255.0,alpha: 1.0)
        
        return cell
    }
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func creatDataArr() {
        //swift遍历某个数
        let muDataArr = NSMutableArray.init()
        for index in 0...100 {
            print("\(index)")
            let indexStr = String.init(format: "%zd", index)
            muDataArr.add(indexStr)
        }
        self.dataArr = muDataArr.copy() as! NSArray
    }
    
    func creatCollectionView() {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.minimumLineSpacing = 5
        flowLayout.minimumInteritemSpacing = 5
        flowLayout.itemSize = CGSize(width: ScrrenW * 0.3, height: 30)
        flowLayout.scrollDirection = .vertical
        dragCollection = FQ_DragCollectionView(frame: self.view.bounds, collectionViewLayout: flowLayout)
        dragCollection?.backgroundColor = UIColor.white
        dragCollection?.delegate = self
        dragCollection?.dataSource = self
        dragCollection?.dataSourceArr = self.dataArr
        dragCollection?.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "FQ_DragCollectionViewId")
        
        weak var weakSelf = self
        //更新数据
        dragCollection?.dataArrChangBlock = {(dataArr)->() in
            weakSelf?.dataArr = dataArr
            print(dataArr)
        }
        self.view.addSubview(dragCollection!)
    }
}
