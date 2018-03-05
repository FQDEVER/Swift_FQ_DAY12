//
//  ViewController.swift
//  FQ_AlertController_Swift
//
//  Created by mac on 2018/1/3.
//  Copyright © 2018年 mac. All rights reserved.
//

import UIKit


class ViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {

    var tableView : UITableView? = nil
    let dataArr : NSArray = [
                                "顶部提示",
                                "中部提示",
                                "底部提示",
                                "快捷创建"
                            ]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.tableView = UITableView(frame: self.view.bounds, style: UITableViewStyle.grouped)
        self.tableView?.delegate = self
        self.tableView?.dataSource = self
        self.tableView?.register(UITableViewCell.self, forCellReuseIdentifier: "UITableViewID")
        self.view.addSubview(self.tableView!)
    }
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dataArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "UITableViewID", for: indexPath)
        cell.textLabel?.text = (self.dataArr[indexPath.row] as! String)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if indexPath.row < 3 {
            var alertView : FQ_AlertView? = nil
            if indexPath.row == 0 {
                alertView = FQ_AlertView.showAlertView(title: "可以的", message: "快乐的撒娇发了的数据奥拉夫", alertType: .Top, configuration: nil)
            }else if(indexPath.row == 1){
                alertView = FQ_AlertView.showAlertView(title: "可以的", message: "快乐的撒娇发了的数据奥拉夫", alertType: .Mid, configuration: nil)
            }else{
                alertView = FQ_AlertView.showAlertView(title: "可以的", message: "快乐的撒娇发了的数据奥拉夫", alertType: .Sheet, configuration: nil)
            }
            
            let confirmAction = FQ_AlertAction.creatAction(title: "确定", type: .Confirm) { (alertAction) in
                print("确定")
            }
            alertView?.addAction(confirmAction)
            
            let cancelAction = FQ_AlertAction.creatAction(title: "取消", type: .Cancel) { (alertAction) in
                print("取消")
            }
            alertView?.addAction(cancelAction)
            
            let deletAction = FQ_AlertAction.creatAction(title: "删除", type: .Destructive) { (alertAction) in
                print("删除")
            }
            alertView?.addAction(deletAction)
            
            alertView?.showAlertView()
        }else{
            
            let alertAlertConfiguration = FQ_AlertConfiguration.creatAlertConfiguration(defaultTextColor: nil, defaultBackgroundColor: nil, defaultTextFont: nil, confirmTextColor: nil, confirmBackgroundColor: nil, confirmTextFont: nil, destructiveTextColor: nil, destructiveBackgroundColor: nil, destructiveTextFont: nil, cancelTextColor: UIColor.blue, cancelBackgroundColor: nil, cancelTextFont: nil, cornerRadius: nil, isClickClear: true)

            FQ_AlertView.showAlertView(title: "可以的", message: "发来会计分录大家福利卡是积分来得及阿弗莱克", alertViewType: FQ_AlertViewType.Sheet, confirmActionStr: "确定", otherActionStrArr:["举报","开始"], destructiveActionStr: "删除", cancelActionStr: "取消", configuration: alertAlertConfiguration) { (alertAction) in
                if(alertAction.title == "确定"){
                    print("点击了确认")
                }
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

