//
//  RoomsViewController.swift
//  NearBoddy
//
//  Created by 岡本　優河 on 2018/07/15.
//  Copyright © 2018年 岡本　優河. All rights reserved.
//

import UIKit
import Firebase
class RoomsViewController: UIViewController {

    @IBOutlet weak var tableView:UITableView!
    var adress:String!
    var rooms = [RoomModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("adress \(self.adress)")
        tableView.dataSource = self
         loadRoom()
    }

    func loadRoom(){
        Api.Room.REF_ROOMS.observe(.childAdded) { snapshot in
            print(Thread.isMainThread)
            if let dict = snapshot.value as? [String: Any] {
//                print("plus \((dict["country"] as! String) + (dict["locality"] as! String))")
                guard (((dict["country"] as! String) + (dict["administrativeArea"] as! String) + (dict["subAdministrativeArea"] as! String) + (dict["locality"] as! String) + (dict["subLocality"] as! String) + (dict["thoroughfare"] as! String) ) == self.adress) else{
                    return
                }
                
                let newRoom = RoomModel.transformRoom(dict: dict)
                print("newRoom \(dict)")
                self.rooms.append(newRoom)
                self.tableView.reloadData()
            }
        }
    }
    
}

extension RoomsViewController: UITableViewDataSource,UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return rooms.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "RoomCell", for: indexPath) as! RoomsTableViewCell
        let room = rooms[indexPath.row]
        cell.room = room
        return cell
    }
}
