//
//  FQ_AnimationCell.swift
//  YX_Animation
//
//  Created by mac on 2018/2/26.
//  Copyright © 2018年 mac. All rights reserved.
//

import UIKit

class FQ_AnimationCell: UICollectionViewCell {
    
    //印象笔记图片
    @IBOutlet weak var noteBookImg: UIImageView!
    
    var tempBackImg : UIImageView!
    //印象笔记title
    var noteBookTitle: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        noteBookTitle = UILabel()
        noteBookTitle.textColor = UIColor.black
        noteBookTitle.textAlignment = .center
        self.addSubview(noteBookTitle)
        
        self.tempBackImg = UIImageView.init(image: UIImage(named: "back"))
        self.tempBackImg.frame = CGRect(x: 20, y: 0, width: 20, height: 44)
        self.tempBackImg.contentMode = .center
        self.addSubview(tempBackImg)
        tempBackImg.alpha = 0.0
        
    }
    
 

}
