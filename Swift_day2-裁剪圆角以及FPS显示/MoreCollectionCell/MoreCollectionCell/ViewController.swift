//
//  ViewController.swift
//  MoreCollectionCell
//
//  Created by mac on 2018/1/2.
//  Copyright © 2018年 mac. All rights reserved.
//

import UIKit


let ScreenW = UIScreen.main.bounds.size.width
let ScreenH = UIScreen.main.bounds.size.height


class ViewController: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource {

    //collection
    var collection : UICollectionView? = nil
    //datasuosi
    var fpsLabel   : FPSLabel_swift? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.creatUIView()
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 100
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MoreCollectCellID", for: indexPath)
        return cell
    }
    
    
    
    func creatUIView() {
        
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.minimumLineSpacing = 5
        flowLayout.minimumInteritemSpacing = 5
        flowLayout.itemSize = CGSize(width: ScreenW, height: 100)
        
        self.collection = UICollectionView(frame: self.view.bounds, collectionViewLayout: flowLayout)
        self.collection?.delegate = self
        self.collection?.dataSource = self
        self.collection?.register(UINib.init(nibName: "MoreCollectCell", bundle: nil), forCellWithReuseIdentifier: "MoreCollectCellID")
        self.view.addSubview(self.collection!)
        
        self.fpsLabel = FPSLabel_swift(frame: CGRect(x: 100, y: 100, width: 100, height: 100))
        self.fpsLabel?.backgroundColor = UIColor.red
        self.view.addSubview(self.fpsLabel!)
    }
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

