//
//  ViewController.swift
//  SpinningCollection_Swift
//
//  Created by mac on 2018/1/8.
//  Copyright © 2018年 mac. All rights reserved.
//

import UIKit

class ViewController: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource {

    var collectionView : UICollectionView? = nil
    let dataArr : NSMutableArray = NSMutableArray()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        for index in 1...14 {
            dataArr.add(NSString(format: "%zd", index))
        }
        
        let layout = SpinningWheelCollectionLayout.init()
    
//        let layout = UICollectionViewFlowLayout.init()
//        layout.itemSize = CGSize(width: 0, height: 0)
//        layout.minimumLineSpacing = 5
//        layout.minimumInteritemSpacing = 5
        self.collectionView = UICollectionView(frame: self.view.bounds, collectionViewLayout: layout)
         self.collectionView?.register(SpinningCollectionViewCell.self, forCellWithReuseIdentifier: "SpinningCollectionViewCellID")
        self.collectionView?.delegate = self
        self.collectionView?.dataSource = self
    
        
        self.collectionView?.backgroundColor = UIColor.white
        self.view.addSubview(self.collectionView!)
        
    }

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.dataArr.count
    }
        
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        let cell : SpinningCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: "SpinningCollectionViewCellID", for: indexPath) as! SpinningCollectionViewCell
        cell.imgNameStr = self.dataArr[indexPath.row] as! String
        cell.backgroundColor = UIColor .red
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        //点击cell
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

