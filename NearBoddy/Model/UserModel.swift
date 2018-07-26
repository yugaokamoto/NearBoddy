//
//  UserModel.swift
//  NearBoddy
//
//  Created by 岡本　優河 on 2018/07/25.
//  Copyright © 2018年 岡本　優河. All rights reserved.
//

import Foundation
class UserModel {
    var email: String?
    var profileImageUrl: String?
    var username: String?
}

extension UserModel {
    static func transformUser(dict: [String: Any]) -> UserModel {
        let user = UserModel()
        user.email = dict["email"] as? String
        user.profileImageUrl = dict["profileImageUrl"] as? String
        user.username = dict["username"] as? String
        
        return user
    }
}
