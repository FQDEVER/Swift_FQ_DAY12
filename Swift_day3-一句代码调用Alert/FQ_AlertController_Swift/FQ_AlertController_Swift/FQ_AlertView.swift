//
//  FQ_AlertView.swift
//  FQ_AlertController_Swift
//
//  Created by mac on 2018/1/3.
//  Copyright © 2018年 mac. All rights reserved.
//

import UIKit
import SnapKit
/**********===================配置项=====================**************/

public enum FQ_AlertViewType : Int {
    case Top  //顶部样式
    case Mid  //居中样式
    case Sheet //底部样式
}

public enum FQ_AlertActionType:NSInteger {
    case Default
    case Confirm
    case Destructive
    case Cancel
}

func RGBA(_ r:CGFloat,_ g:CGFloat,_ b:CGFloat,_ a:CGFloat) -> UIColor {
    return UIColor(red: r / 255.0, green: g/255.0, blue: b/255.0, alpha: a)
}

func RGBCOLOR(_ color : CGFloat)-> UIColor{
    return RGBA(color, color, color, 1)
}

//获取最大Y值
func GETViewMAX_Y(view:UIView) -> CGFloat {
    return view.frame.origin.y + view.frame.size.height
}

func GETViewMAX_X(view:UIView) -> CGFloat {
    return view.frame.origin.x + view.frame.size.width
}

let GetSystemVersion  =  Double(UIDevice.current.systemVersion as String)!
func RegularFont(size:CGFloat)->UIFont{
    if (GetSystemVersion >= 8.0 && GetSystemVersion < 9.0) {
        return  UIFont.systemFont(ofSize: size)
    }else{
        return  UIFont(name:"PingFangSC-Regular", size: size)!
    }
}
func SemiboldFont(size:CGFloat)->UIFont{
    if (GetSystemVersion >= 8.0 && GetSystemVersion < 9.0) {
        return  UIFont.systemFont(ofSize: size)
    }else{
        return  UIFont(name:"PingFangSC-Regular", size: size)!
    }
}


let TopAlertActionH  = CGFloat(26.0) //顶部action高度
let OtherAlertActionH = CGFloat(44.0)//其他action的高度
let ActionItemBtnTag  = 888 //action-Tag增加值
let TitleFontSize = CGFloat(17.0)    //标题字体大小
let ContentFontSize = CGFloat(14.0)  //字体大小
let CornerRadius = OtherAlertActionH * 0.5 //圆角
let ActionMarginWH = CGFloat(17.0) //action之间的间隙

var SJScreenH = UIScreen.main.bounds.size.height
var SJScreenW = UIScreen.main.bounds.size.width
let KEY_WINDOW = UIApplication.shared.keyWindow!
let FQKeyWindowRootView = KEY_WINDOW.rootViewController?.view
let GlobalBlueColor  = RGBA(9.0,99.0,204.0,1.0)
let ConfirmTextColor = RGBCOLOR(255)
let DefaultTextColor = RGBCOLOR(255)
let CancelTextColor  = RGBA(69.0, 168.0, 243.0, 1.0)
let TitleTextColor   = RGBCOLOR(60)
let DestructiveTextColor = RGBA(254,56,36,1.0)
let ContentTextColor = RGBCOLOR(102)
let CancelBackgroundColor = RGBA(244.0,244.0,244.0, 1.0)
let OtherActionBackColor  = RGBA(69.0, 168.0, 243.0, 1.0)


/**********===================AlertView类=================**************/
/// 对外使用
class FQ_AlertView: UIView {

   lazy var alertTopView : UIView? = nil
   lazy var alertMidView : UIView? = nil
   lazy var alertSheetView : UIView? = nil
   lazy var coverBtn : UIButton? = nil
   lazy var actionArr = NSMutableArray()
   lazy var titleStr : String? = nil
   lazy var messageStr : String? = nil
   var alertType :FQ_AlertViewType?
   lazy var configuration : FQ_AlertConfiguration? = nil
    
    /// 外界调用类方法.快速创建AlertView
    ///
    /// - Parameters:
    ///   - title: 提示标题
    ///   - message: 提示内容
    ///   - alertViewType: 提示类型
    ///   - confirmActionStr: 确定Action文本
    ///   - otherActionStrArr: 其他Action文本数组
    ///   - destructiveActionStr: 删除Action文本
    ///   - cancelActionStr:取消Action文本
    ///   - configuration: 提示框配置文件
    ///   - actionBlock: 点击Action回调block
    static func showAlertView(title:String?,message:String?,alertViewType:FQ_AlertViewType?,confirmActionStr:String?,otherActionStrArr : NSArray?,destructiveActionStr:String?,cancelActionStr:String?,configuration:FQ_AlertConfiguration?,actionBlock:@escaping (FQ_AlertAction)->()){
        
        let alertView = FQ_AlertView.showAlertView(title: title, message: message, alertType: alertViewType!, configuration: configuration)
        
        if(confirmActionStr != nil){
            let confirm = FQ_AlertAction.creatAction(title: confirmActionStr!, type: FQ_AlertActionType.Confirm, handler: actionBlock)
           alertView.addAction(confirm)
        }
        
        if(destructiveActionStr != nil){
            let destrucTiveAction = FQ_AlertAction.creatAction(title: destructiveActionStr!, type: FQ_AlertActionType.Destructive, handler: actionBlock)
            alertView.addAction(destrucTiveAction)
        }

        if(cancelActionStr != nil){
            let cancelAction = FQ_AlertAction.creatAction(title: cancelActionStr!, type: FQ_AlertActionType.Cancel, handler: actionBlock)
            alertView.addAction(cancelAction)
        }
        
        if(otherActionStrArr != nil){
            for otherStr in otherActionStrArr! {
                let otherAction = FQ_AlertAction.creatAction(title: otherStr as! String, type: FQ_AlertActionType.Default, handler: actionBlock)
                alertView.addAction(otherAction)
            }
        }
        
        alertView .showAlertView()
    }
    
    
    /// AlertView基础展示定义
    ///
    /// - Parameters:
    ///   - title: 提示标题
    ///   - message: 提示内容
    ///   - alertType: 提示类型
    ///   - configuration: 提示框配置文件
    static func showAlertView(title:String?,message:String?,alertType:FQ_AlertViewType,configuration:FQ_AlertConfiguration?)->(FQ_AlertView) {
        let alertView = FQ_AlertView(frame: CGRect(x: 0, y: 0, width: SJScreenW, height: SJScreenH))
        
        for alertItemView in FQ_AlertViewManager.shareManager.alertViewArr {
            
           let alert = alertItemView as! FQ_AlertView
           alert.clickClearCoverView()
            
        }
        FQ_AlertViewManager.shareManager.alertViewArr.add(alertView)
        alertView.titleStr = title != nil ? title : ""
        alertView.messageStr = message != nil ? message : ""
        alertView.alertType = alertType
        alertView.configuration = configuration != nil ? configuration : FQ_AlertConfiguration()
       
        return alertView
    }
    
    
    /// 添加响应Action
    ///
    /// - Parameter alertAction: Action
    func addAction(_ alertAction:FQ_AlertAction) {
        self.actionArr.add(alertAction)
    }
    
    
    /// 展示AlertView
    func showAlertView(){
       self.creatOrUploadAlertView()
    }
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        //注册通知
        self.addNotification()
        self.creatUIView()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        //注册通知
        self.addNotification()
        self.creatUIView()
    }
    
    
    func creatUIView() {
        
        FQKeyWindowRootView?.addSubview(self)
        self.snp.makeConstraints { (make) in
            make.edges.equalTo(FQKeyWindowRootView!).inset(UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0))
        }
        self.coverBtn = UIButton(frame: self.bounds)
        self.coverBtn?.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        self.coverBtn?.addTarget(self, action: #selector(clickClearCoverBtn), for: UIControlEvents.touchUpInside)
        self.addSubview(self.coverBtn!)
        self.coverBtn?.snp.makeConstraints({ (make) in
            make.edges.equalTo(self).inset(UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0))
        })
    }
    
    @objc func clickClearCoverBtn() {
        if (self.configuration?.isClickClear)! {
            self.clickClearCoverView()
        }
    }
    
    @objc func clickClearCoverView() {
        
        UIView.animate(withDuration: 0.3, animations: {
            if(self.alertType == FQ_AlertViewType.Top){
                self.alertTopView?.snp.updateConstraints({ (make) in
                    make.left.equalTo(20)   //间距为20
                    make.right.equalTo(-20) //间距为-20
                    make.top.equalTo(self.snp.topMargin).offset(-200)  //间距为-400
                })
                self.alertTopView?.alpha = 0.0
                self.coverBtn?.alpha = 0.0
                self.layoutIfNeeded()
            }else if(self.alertType == FQ_AlertViewType.Mid){
                self.alertMidView?.alpha = 0.0
                self.coverBtn?.alpha = 0.0
            }else{
                self.alertSheetView?.snp.updateConstraints({ (make) in
                    make.left.equalTo(20)   //间距为20
                    make.right.equalTo(-20) //间距为-20
                    make.bottom.equalTo(self.snp.bottomMargin).offset(400)  //间距为400
                })
                self.alertSheetView?.alpha = 0.0
                self.coverBtn?.alpha = 0.0
                self.layoutIfNeeded()
            }
        }) { (bool) in
            self.removeFromSuperview()
            FQ_AlertViewManager.shareManager.alertViewArr.removeAllObjects()
        }
    }
    
    func addNotification() {
        NotificationCenter.default.addObserver(self, selector: #selector(didChangeStatusNotification), name: NSNotification.Name.UIApplicationDidChangeStatusBarOrientation, object: nil)
    }
    
    @objc func didChangeStatusNotification(){
        SJScreenH = UIScreen.main.bounds.size.height
        SJScreenW = UIScreen.main.bounds.size.width
        
        //更新uploadAlertView
        self.creatOrUploadAlertView()
    }

    //创建或更新当前的视图
    func creatOrUploadAlertView() {
        
        //更新其部分约束即可.
        switch self.alertType {
        case .Top?:
            self.updateTopAlertView()
            break
        case .Mid?:
            self.updateMidAlertView()
            break
        case .Sheet?:
            self.updateSheetAlertView()
            break
        case .none:
            break
        }
        
    }
    
    func updateTopAlertView() {
        if(self.alertTopView == nil){
            self.creatTopAlertView()
        }
        UIView.animate(withDuration: 0.3, delay: 0, options: UIViewAnimationOptions.allowAnimatedContent, animations: {
            self.alertTopView?.alpha = 1.0
            self.coverBtn?.alpha = 1.0
            self.alertTopView?.snp.updateConstraints({ (make) in
                make.left.equalTo(20) //间距为20
                make.right.equalTo(-20) //间距为20
                make.top.equalTo(self.snp.topMargin).offset(0)  //间距为-400
            })
            self.layoutIfNeeded()
        }){ (bool) in
            
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 3, execute: {
                self.clickClearCoverView()
            })
        }
    }

    
    func updateMidAlertView() {
        if(self.alertMidView == nil){
            self.creatMidAlertView()
        }
        UIView.animate(withDuration: 0.3, delay: 0, options: UIViewAnimationOptions.allowAnimatedContent, animations: {
            self.alertMidView?.alpha = 1.0
            self.coverBtn?.alpha = 1.0
        }, completion: nil)
    }
    
    func updateSheetAlertView() {
        if(self.alertSheetView == nil){
            self.creatSheetAlertView()
        }
        UIView.animate(withDuration: 0.3, delay: 0, options: UIViewAnimationOptions.allowAnimatedContent, animations: {
            self.alertSheetView?.alpha = 1.0
            self.coverBtn?.alpha = 1.0
            self.alertSheetView?.snp.updateConstraints({ (make) in
                make.left.equalTo(20) //间距为20
                make.right.equalTo(-20) //间距为20
                make.bottom.equalTo(self.snp.bottomMargin).offset(20)  //间距为-400
            })
            self.layoutIfNeeded()
        }, completion: nil)
    }
    
    //创建creatMidAlertView
    func creatMidAlertView(){
        
        FQKeyWindowRootView?.endEditing(true)
        self.coverBtn?.alpha = 0.0
        //创建顶部alertView
        self.alertMidView = UIView()
        self.alertMidView?.layer.masksToBounds = true
        self.alertMidView?.layer.cornerRadius = (self.configuration?.cornerRadius)!
        self.alertMidView?.backgroundColor = UIColor.white
        self.coverBtn?.addSubview(self.alertMidView!)
        self.alertMidView?.snp.makeConstraints({ (make) in
            make.left.equalTo(20)
            make.right.equalTo(-20)
            make.centerY.equalTo(self.snp.centerY).offset(0)
        })
        
        //添加标题信息
        let alertTitle = UILabel()
        self.alertMidView?.addSubview(alertTitle)
        alertTitle.text = self.titleStr
        alertTitle.numberOfLines = 1
        alertTitle.textAlignment = .center
        alertTitle.textColor = TitleTextColor
        alertTitle.font = UIFont.systemFont(ofSize: CGFloat(TitleFontSize))
        alertTitle.snp.makeConstraints { (make) in
            make.top.equalTo(30)
            make.left.equalTo(20)
            make.right.equalTo(-20)
        }
        
        //添加内容信息
        let contentText = UILabel()
        self.alertMidView?.addSubview(contentText)
        contentText.text = self.messageStr
        contentText.numberOfLines = 0
        contentText.textAlignment = .left
        contentText.textColor = ContentTextColor
        contentText.font = UIFont.systemFont(ofSize: ContentFontSize)
        contentText.snp.makeConstraints { (make) in
            make.top.equalTo(alertTitle.snp.bottomMargin).offset(20)
            make.left.equalTo(20)
            make.right.equalTo(-20)
        }
        
        //添加Action
        for index in 0...self.actionArr.count-1 {
            let action = self.actionArr[index] as! FQ_AlertAction
            let actionItemBtn = UIButton()
            actionItemBtn.setTitle(action.title, for: .normal)
            self.settingActionBtn(sender: actionItemBtn, alertAction: action)
            self.alertMidView?.addSubview(actionItemBtn)
            actionItemBtn.tag = ActionItemBtnTag + index
            actionItemBtn .addTarget(self, action: #selector(clickActionBtn(sender:)), for: UIControlEvents.touchUpInside)
            actionItemBtn.layer.masksToBounds = true
            actionItemBtn.layer.cornerRadius = (self.configuration?.cornerRadius)!
            
            if(self.actionArr.count <= 2){
                if(index == 0){
                    actionItemBtn.snp.makeConstraints({ (make) in
                        make.top.equalTo(contentText.snp.bottomMargin).offset(20)
                        make.left.equalTo(20)
                        make.height.equalTo(OtherAlertActionH)
                        make.bottom.equalTo(-20)
                    })
                }else{
                    let beforeBtn = self.alertMidView?.viewWithTag(ActionItemBtnTag + index - 1)
                    actionItemBtn.snp.makeConstraints({ (make) in
                        make.top.width.height.equalTo(beforeBtn!)
                        make.left.equalTo(beforeBtn!.snp.rightMargin).offset(ActionMarginWH)
                        if(index == self.actionArr.count - 1){
                            make.right.equalTo(-20)
                        }
                    })
                }
            }else{
                if(index == 0){
                    actionItemBtn.snp.makeConstraints({ (make) in
                        make.top.equalTo(contentText.snp.bottomMargin).offset(20)
                        make.left.equalTo(20)
                        make.right.equalTo(-20)
                        make.height.equalTo(OtherAlertActionH)
                    })
                }else{
                    let beforeBtn = self.alertMidView?.viewWithTag(ActionItemBtnTag + index - 1)
                    actionItemBtn.snp.makeConstraints({ (make) in
                        make.width.height.left.equalTo(beforeBtn!)
                        make.top.equalTo((beforeBtn?.snp.bottomMargin)!).offset(ActionMarginWH)
                        if(index == self.actionArr.count - 1){
                            make.bottom.equalTo(-20)
                        }
                    })
                }
            }
        }
        self.alertMidView?.alpha = 0.0
        self.layoutIfNeeded()
    }
    
    //创建creatSheetAlertView
    func creatSheetAlertView(){
        FQKeyWindowRootView?.endEditing(true)
        self.coverBtn?.alpha = 0.0
        //创建顶部alertView
        self.alertSheetView = UIView()
        self.alertSheetView?.layer.masksToBounds = true
        self.alertSheetView?.layer.cornerRadius = (self.configuration?.cornerRadius)!
        self.alertSheetView?.backgroundColor = UIColor.white
        self.coverBtn?.addSubview(self.alertSheetView!)
        self.alertSheetView?.snp.makeConstraints({ (make) in
            make.left.equalTo(20)
            make.right.equalTo(-20)
            make.bottom.equalTo(self.snp.bottomMargin).offset(400)
        })
        
        //添加标题信息
        let alertTitle = UILabel()
        self.alertSheetView?.addSubview(alertTitle)
        alertTitle.text = self.titleStr
        alertTitle.numberOfLines = 1
        alertTitle.textAlignment = .center
        alertTitle.textColor = TitleTextColor
        alertTitle.font = UIFont.systemFont(ofSize: CGFloat(TitleFontSize))
        alertTitle.snp.makeConstraints { (make) in
            make.top.equalTo(30)
            make.left.equalTo(20)
            make.right.equalTo(-20)
        }
        
        //添加内容信息
        let contentText = UILabel()
        self.alertSheetView?.addSubview(contentText)
        contentText.text = self.messageStr
        contentText.numberOfLines = 0
        contentText.textAlignment = .left
        contentText.textColor = ContentTextColor
        contentText.font = UIFont.systemFont(ofSize: ContentFontSize)
        contentText.snp.makeConstraints { (make) in
            make.top.equalTo(alertTitle.snp.bottomMargin).offset(20)
            make.left.equalTo(20)
            make.right.equalTo(-20)
        }
        
        //添加Action
        for index in 0...self.actionArr.count-1 {
            let action = self.actionArr[index] as! FQ_AlertAction
            let actionItemBtn = UIButton()
            actionItemBtn.setTitle(action.title, for: .normal)
            self.settingActionBtn(sender: actionItemBtn, alertAction: action)
            self.alertSheetView?.addSubview(actionItemBtn)
            actionItemBtn.tag = ActionItemBtnTag + index
            actionItemBtn .addTarget(self, action: #selector(clickActionBtn(sender:)), for: UIControlEvents.touchUpInside)
            actionItemBtn.layer.masksToBounds = true
            actionItemBtn.layer.cornerRadius = (self.configuration?.cornerRadius)!
            
            if(index == 0){
                actionItemBtn.snp.makeConstraints({ (make) in
                    make.top.equalTo(contentText.snp.bottomMargin).offset(20)
                    make.left.equalTo(20)
                    make.right.equalTo(-20)
                    make.height.equalTo(OtherAlertActionH)
                })
            }else{
                let beforeBtn = self.alertSheetView?.viewWithTag(ActionItemBtnTag + index - 1)
                actionItemBtn.snp.makeConstraints({ (make) in
                    make.width.height.left.equalTo(beforeBtn!)
                    make.top.equalTo((beforeBtn?.snp.bottomMargin)!).offset(ActionMarginWH)
                    if(index == self.actionArr.count - 1){
                        make.bottom.equalTo(-20)
                    }
                })
            }
            
        }
        self.alertSheetView?.alpha = 0.0
        self.layoutIfNeeded()
    }
    
    //创建creatTopAlertView
    func creatTopAlertView(){
        
        FQKeyWindowRootView?.endEditing(true)
        self.coverBtn?.alpha = 0.0
        //创建顶部alertView
        self.alertTopView = UIView()
        self.alertTopView?.layer.masksToBounds = true
        self.alertTopView?.layer.cornerRadius = (self.configuration?.cornerRadius)!
        self.alertTopView?.backgroundColor = UIColor.white
        self.coverBtn?.addSubview(self.alertTopView!)
        self.alertTopView?.snp.makeConstraints({ (make) in
            make.left.equalTo(20)
            make.right.equalTo(-20)
            make.top.equalTo(self.snp.topMargin).offset(-200)  //间距为-400
        })
        
        //添加图标信息
        let pushIcon = UIImageView(image: UIImage(named: "推送提示"))
        self.alertTopView?.addSubview(pushIcon)
        pushIcon.snp.makeConstraints { (make) in
            make.top.left.equalTo(20)
            make.width.height.equalTo(31)
        }
        
        //添加标题信息
        let pushTitle = UILabel()
        self.alertTopView?.addSubview(pushTitle)
        pushTitle.text = self.titleStr
        pushTitle.numberOfLines = 1
        pushTitle.textAlignment = .left
        pushTitle.textColor = GlobalBlueColor
        pushTitle.font = UIFont.systemFont(ofSize: 16)
        pushTitle.snp.makeConstraints { (make) in
            make.left.equalTo(pushIcon.snp.rightMargin).offset(20)
            make.top.equalTo(pushIcon.snp.top)
            make.right.equalTo(-20)
        }
        
        //添加内容信息
        let contentText = UILabel()
        self.alertTopView?.addSubview(contentText)
        contentText.text = self.messageStr
        contentText.numberOfLines = 0
        contentText.textAlignment = .left
        contentText.textColor = GlobalBlueColor
        contentText.font = UIFont.systemFont(ofSize: 13)
        contentText.snp.makeConstraints { (make) in
            make.top.equalTo(pushTitle.snp.bottomMargin).offset(10)
            make.left.equalTo(pushIcon.snp.rightMargin).offset(20)
            make.right.equalTo(-20)
        }
        
        self.layoutIfNeeded()
        //添加Action
        for index in 0...self.actionArr.count-1 {
            let action = self.actionArr[index] as! FQ_AlertAction
            let actionItemBtn = UIButton()
            actionItemBtn.setTitle(action.title, for: .normal)
            self.settingActionBtn(sender: actionItemBtn, alertAction: action)
            self.alertTopView?.addSubview(actionItemBtn)
            actionItemBtn.tag = ActionItemBtnTag + index
            actionItemBtn .addTarget(self, action: #selector(clickActionBtn(sender:)), for: UIControlEvents.touchUpInside)
            actionItemBtn.layer.masksToBounds = true
            actionItemBtn.layer.cornerRadius = TopAlertActionH * 0.5
            let maxView = GETViewMAX_Y(view: pushIcon) > GETViewMAX_Y(view: contentText) ?  pushIcon : contentText
            if(index == 0){
                actionItemBtn.snp.makeConstraints({ (make) in
                    make.top.equalTo(maxView.snp.bottomMargin).offset(20)
                    make.left.equalTo(20)
                    make.height.equalTo(TopAlertActionH)
                    make.bottom.equalTo(-20)
                })
            }else{
                let beforeBtn = self.alertTopView?.viewWithTag(ActionItemBtnTag + index - 1)
                actionItemBtn.snp.makeConstraints({ (make) in
                    make.top.width.height.equalTo(beforeBtn!)
                    make.left.equalTo(beforeBtn!.snp.rightMargin).offset(ActionMarginWH)
                    if(index == self.actionArr.count - 1){
                        make.right.equalTo(-20)
                    }
                })
            }
        }
        self.alertTopView?.alpha = 0.0
        self.layoutIfNeeded()
    }
    //传入一个按钮
    func settingActionBtn(sender:UIButton,alertAction:FQ_AlertAction){
        switch alertAction.actionType {
        case .Default:
            sender.setTitleColor(self.configuration?.defaultTextColor, for: .normal)
            sender.backgroundColor = self.configuration?.defaultBackgroundColor
            sender.titleLabel?.font = self.configuration?.defaultTextFont
            break
        case .Confirm:
            sender.setTitleColor(self.configuration?.confirmTextColor, for: .normal)
            sender.backgroundColor = self.configuration?.confirmBackgroundColor
            sender.titleLabel?.font = self.configuration?.confirmTextFont
            break
        case .Destructive:
            sender.setTitleColor(self.configuration?.destructiveTextColor, for: .normal)
            sender.backgroundColor = self.configuration?.destructiveBackgroundColor
            sender.titleLabel?.font = self.configuration?.destructiveTextFont
            break
        case .Cancel:
            sender.setTitleColor(self.configuration?.cancelTextColor, for: .normal)
            sender.backgroundColor = self.configuration?.cancelBackgroundColor
            sender.titleLabel?.font = self.configuration?.cancelTextFont
            break
        }
        
    }
    
    //Action的响应事件
    @objc func clickActionBtn(sender:UIButton) {
        self.clickClearCoverView()
        let index = sender.tag - ActionItemBtnTag
        let action = self.actionArr[index] as! FQ_AlertAction
        if (action.actionBlock != nil) {
            action.actionBlock!(action)
        }
    }
    
    //清空通知
    override func delete(_ sender: Any?) {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIApplicationDidChangeStatusBarOrientation, object: nil)
    }
    
}





/**********===================AlertAction=================**************/

class FQ_AlertAction: NSObject {
    
    var actionType:FQ_AlertActionType = .Default
    var title : String?
    typealias ActionBlock = (FQ_AlertAction)->()
    var actionBlock : ActionBlock? = nil
    
    static func creatAction(title:String,type:FQ_AlertActionType,handler:@escaping ActionBlock)->(FQ_AlertAction) {
        let alertAction = FQ_AlertAction()
        alertAction.title = title
        alertAction.actionType = type
        alertAction.actionBlock = handler
        return alertAction
    }
}


/**********===================AlertViewManager=================**************/

private class FQ_AlertViewManager: NSObject {
    let alertViewArr = NSMutableArray()
    
    static let shareManager = FQ_AlertViewManager()
    private override init() {}
}


/**********===================AlertConfiguration=================**************/

class FQ_AlertConfiguration: NSObject {
    
    var defaultTextColor = DefaultTextColor
    var defaultBackgroundColor = OtherActionBackColor
    var defaultTextFont = UIFont.systemFont(ofSize: CGFloat(TitleFontSize))
    
    var confirmTextColor = ConfirmTextColor
    var confirmBackgroundColor = OtherActionBackColor
    var confirmTextFont = UIFont.systemFont(ofSize: CGFloat(TitleFontSize))
    
    var destructiveTextColor = DestructiveTextColor
    var destructiveBackgroundColor = CancelBackgroundColor
    var destructiveTextFont = UIFont.systemFont(ofSize: CGFloat(TitleFontSize))
    
    var cancelTextColor = CancelTextColor
    var cancelBackgroundColor = CancelBackgroundColor
    var cancelTextFont = UIFont.systemFont(ofSize: CGFloat(TitleFontSize))
    
    var cornerRadius = CornerRadius
    var isClickClear = false
    
    static func creatAlertConfiguration(defaultTextColor:UIColor?,defaultBackgroundColor:UIColor?,defaultTextFont:UIFont?,confirmTextColor:UIColor?,confirmBackgroundColor:UIColor?,confirmTextFont:UIFont?,destructiveTextColor:UIColor?,destructiveBackgroundColor:UIColor?,destructiveTextFont:UIFont?,cancelTextColor:UIColor?,cancelBackgroundColor:UIColor?,cancelTextFont:UIFont?,cornerRadius:CFloat?,isClickClear:Bool?)->(FQ_AlertConfiguration){
        let alertConfiguration = FQ_AlertConfiguration()
        if defaultTextColor != nil {alertConfiguration.defaultTextColor = defaultTextColor!}
        if defaultBackgroundColor != nil {alertConfiguration.defaultBackgroundColor = defaultBackgroundColor!}
        if defaultTextFont != nil {alertConfiguration.defaultTextFont = defaultTextFont!}
        
        if confirmTextColor != nil {alertConfiguration.confirmTextColor = confirmTextColor!}
        if confirmBackgroundColor != nil {alertConfiguration.confirmBackgroundColor = confirmBackgroundColor!}
        if confirmTextFont != nil {alertConfiguration.confirmTextFont = confirmTextFont!}
        if destructiveTextColor != nil {alertConfiguration.destructiveTextColor = destructiveTextColor!}
        if destructiveBackgroundColor != nil {alertConfiguration.destructiveBackgroundColor = destructiveBackgroundColor!}
        if destructiveTextFont != nil {alertConfiguration.destructiveTextFont = destructiveTextFont!}
        if cancelTextColor != nil {alertConfiguration.cancelTextColor = cancelTextColor!}
        if cancelBackgroundColor != nil {alertConfiguration.cancelBackgroundColor = cancelBackgroundColor!}
        if cancelTextFont != nil {alertConfiguration.cancelTextFont = cancelTextFont!}
        if cornerRadius != nil {alertConfiguration.cornerRadius = CGFloat(cornerRadius!)}
        if isClickClear != nil {alertConfiguration.isClickClear = isClickClear!}
        return alertConfiguration
    }
}

