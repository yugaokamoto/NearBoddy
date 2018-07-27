//
//  ProfileViewController.swift
//  NearBoddy
//
//  Created by 岡本　優河 on 2018/07/15.
//  Copyright © 2018年 岡本　優河. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var ProfileReuseableView: ProfileReuseableView!
    
    var user:UserModel!
    var rooms = [RoomModel]()
    var users = [UserModel]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        fetchUser()
    }
    
    func fetchUser(){
        Api.User.observeCurrentUser { (user) in
            self.user = user
            self.ProfileReuseableView.user = user
            self.navigationItem.title = user.username
            self.tableView.reloadData()
        }
    }
    
   
}


extension ProfileViewController: UITableViewDataSource,UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return rooms.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "RoomCell", for: indexPath) as! RoomsTableViewCell
        let room = rooms[indexPath.row]
        let user = users[indexPath.row]
        
        cell.room = room
        cell.user = user
        cell.delegate = self
        return cell
    }
    
}

extension ProfileViewController:RoomsTableViewCellDelegate{
    
    func goToChatVC(roomId: String) {
        performSegue(withIdentifier: "MessageSegue", sender: roomId)
    }
    
    
}
