//
//  ViewController.swift
//  FQ_ClipImage
//
//  Created by mac on 2018/2/27.
//  Copyright © 2018年 mac. All rights reserved.
//

import UIKit

class ViewController: UIViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate {

    @IBOutlet weak var userIcon: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func clickUserIcon(_ sender: UIButton) {
        
//        跳转到相册.
        self.imageFormPhotosAlbum()
    }
    
    func imageFormPhotosAlbum() {
        
        let picker = UIImagePickerController()
        
        picker.delegate = self
        
        picker.sourceType = .photoLibrary
        
        self.present(picker, animated: true, completion: nil)
        
    }
    

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        //获取图片
    let image = info[UIImagePickerControllerOriginalImage] as! UIImage
     picker.dismiss(animated: true, completion: nil)
    let coverVc = FQ_LiveGetCoverVc()
    //再做present操作
    self.present(coverVc, animated: true, completion: nil)
    coverVc.orginIcon = image
    //完成后的图片
    coverVc.clickConfirmBlock = {(completeImage) -> () in
            print("--------------点击确认")
            //图片赋值给按
        self.userIcon.setBackgroundImage(completeImage, for: .normal)
        
        }
    
    }
    
        
    
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        print("取消操作")
    }
    
}

