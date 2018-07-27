//
//  ProfileViewController.swift
//  NearBoddy
//
//  Created by 岡本　優河 on 2018/07/15.
//  Copyright © 2018年 岡本　優河. All rights reserved.
//

import UIKit
import Firebase

class ProfileViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var ProfileReuseableView: ProfileReuseableView!
    
    var user:UserModel!
    var rooms = [RoomModel]()
    var users = [UserModel]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.dataSource = self
        tableView.delegate = self
        fetchUser()
        fetchMyRooms()
    }
    
    func fetchUser(){
        Api.User.observeCurrentUser { (user) in
            self.user = user
            self.ProfileReuseableView.user = user
            self.navigationItem.title = user.username
            self.tableView.reloadData()
        }
    }
    
    func fetchMyRooms(){
        guard let currentUser = Auth.auth().currentUser else {
            return
        }
        Api.MyRooms.REF_MYROOMS.child(currentUser.uid).observe(.childAdded, with: {
            snapshot in
            Api.Room.observeRoom(withId: snapshot.key, completion: { (room) in
                print(room.id!)
                self.rooms.append(room)
                self.tableView.reloadData()
            })
        })
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "MessageSegue"{
            let chatVC = segue.destination as! ChatViewController
            let roomId = sender as! String
            chatVC.roomId = roomId
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
        let user = self.user
        
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
