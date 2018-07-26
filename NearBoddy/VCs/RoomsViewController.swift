//
//  RoomsViewController.swift
//  NearBoddy
//
//  Created by 岡本　優河 on 2018/07/15.
//  Copyright © 2018年 岡本　優河. All rights reserved.
//

import UIKit
import Firebase
import ProgressHUD

class RoomsViewController: UIViewController {

    @IBOutlet weak var tableView:UITableView!
    var adress:String!
    var rooms = [RoomModel]()
    var users = [UserModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("adress \(self.adress)")
        tableView.dataSource = self
         loadRoom()
    }

    func loadRoom(){
        ProgressHUD.show("読み込み中です", interaction: false)
        
        Api.Room.REF_ROOMS.observe(.childAdded) { snapshot in
            print(Thread.isMainThread)
            if let dict = snapshot.value as? [String: Any] {
//                print("plus \((dict["country"] as! String) + (dict["locality"] as! String))")
                guard (((dict["country"] as! String) + (dict["administrativeArea"] as! String) + (dict["subAdministrativeArea"] as! String) + (dict["locality"] as! String) + (dict["subLocality"] as! String) + (dict["thoroughfare"] as! String) ) == self.adress) else{
                    return
                }
                
                let newRoom = RoomModel.transformRoom(dict: dict)
                print("newRoom \(dict)")
                self.fetchUser(uid: newRoom.uid!, completion: {
                    self.rooms.append(newRoom)
                    self.tableView.reloadData()
                })
            }
            ProgressHUD.showSuccess("読み込みが完了しました！")
        }
    }
    
    func fetchUser(uid: String, completion:  @escaping () -> Void ){
        Api.User.REF_USER.child(uid).observeSingleEvent(of: .value, with: {
            snapshot in
            if let dict = snapshot.value as? [String: Any] {
                let user = UserModel.transformUser(dict: dict)
                self.users.append(user)
                completion()
            }
        })
        
    }
    
}

extension RoomsViewController: UITableViewDataSource,UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return rooms.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "RoomCell", for: indexPath) as! RoomsTableViewCell
        let room = rooms[indexPath.row]
        let user = users[indexPath.row]
        
        cell.room = room
        cell.user = user
        return cell
    }
}
