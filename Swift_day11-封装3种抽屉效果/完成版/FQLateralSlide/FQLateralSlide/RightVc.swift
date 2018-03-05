//
//  RightVc.swift
//  FQLateralSlide
//
//  Created by mac on 2018/2/1.
//  Copyright © 2018年 mac. All rights reserved.
//

import UIKit

class RightVc:  UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    var tableView : UITableView? = nil
    var imgView : UIImageView = UIImageView(image: UIImage(named: "1111"))
    let dataArr : [String] = [
        "Push下一个控制器",
        "Present下一个控制器",
        "Push下一个控制器",
        "Present下一个控制器",
        "Push下一个控制器",
        "Present下一个控制器",
        ]
    
    override func viewDidLoad() {
        super .viewDidLoad()
        
        self.view.addSubview(self.imgView)
        self.tableView = UITableView(frame: CGRect.zero, style: .plain)
        self.tableView?.delegate = self
        self.tableView?.dataSource = self
        self.tableView?.register(UITableViewCell.self, forCellReuseIdentifier: "UITableViewCellID")
        self.view.addSubview(self.tableView!)
        self.tableView?.backgroundColor = UIColor.clear
        self.tableView?.separatorStyle = .none
        self.tableView?.separatorColor = UIColor.clear
        self.imgView.frame = self.view.bounds
        self.tableView?.frame = CGRect(x: 0, y: 0, width:self.view.frame.size.width, height: 300)
        self.tableView?.center = CGPoint(x: (self.tableView?.center.x)!, y: self.view.center.y)
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        var tableViewFrame = self.tableView?.frame
        tableViewFrame?.size.height = (self.tableView?.contentSize.height)!
        self.tableView?.frame = tableViewFrame!
        self.tableView?.center = self.imgView.center
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dataArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "UITableViewCellID", for: indexPath)
        cell.imageView?.image = UIImage(named: "0000")
        cell.textLabel?.text = self.dataArr[indexPath.row]
        cell.backgroundColor = UIColor.clear
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //push一个新的控制器
        let presentVc = PresentVc()
        presentVc.view.backgroundColor = UIColor.white
        
        if self.dataArr[indexPath.row] == "Push下一个控制器" {
            self.fq_PushOtherVc(pushVc: presentVc)
        }else{
            self.present(presentVc, animated: true, completion: nil)
        }
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 55.0
    }
    
    
    deinit {
        
        print("=====================>>>>>>>注册了几条通知 - tovc释放了")
    }
}

