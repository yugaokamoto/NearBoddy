//
//  ProfileReuseableView.swift
//  NearBoddy
//
//  Created by 岡本　優河 on 2018/07/27.
//  Copyright © 2018年 岡本　優河. All rights reserved.
//

import UIKit

class ProfileReuseableView: UIView {

    @IBOutlet weak var profileImage:UIImageView!
    @IBOutlet weak var nameLabel:UILabel!
    @IBOutlet weak var settingImage:UIImageView!
    @IBOutlet weak var postCounterLabel:UILabel!
    var user:UserModel?{
        didSet{
            updateView()
        }
    }
    
    func updateView(){
         self.nameLabel.text = user!.username
        print("user.username \(user?.username)")
        if let photoUrlString = user!.profileImageUrl{
            let photoUrl = URL(string: photoUrlString)
            self.profileImage.sd_setImage(with: photoUrl)
        }
       self.postCounterLabel.text = "346"
    }
}
