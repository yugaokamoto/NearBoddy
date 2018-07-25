//
//  RoomsTableViewCell.swift
//  NearBoddy
//
//  Created by 岡本　優河 on 2018/07/25.
//  Copyright © 2018年 岡本　優河. All rights reserved.
//

import UIKit
import SDWebImage

class RoomsTableViewCell: UITableViewCell {
    
    @IBOutlet weak var profileImageView:UIImageView!
    @IBOutlet weak var usernameLabel:UILabel!
    @IBOutlet weak var roomNameLabel:UILabel!
    @IBOutlet weak var roomPhoto:UIImageView!
    @IBOutlet weak var timestampLabel:UILabel!
    @IBOutlet weak var locationLabel:UILabel!
    var room:RoomModel?{
        didSet{
            updateView()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
   func updateView(){
    roomNameLabel.text = room?.roomName
    
    locationLabel.text = ((room?.country)! + (room?.administrativeArea)! + (room?.subAdministrativeArea)! + (room?.locality)! + (room?.subLocality)! + (room?.thoroughfare)! + (room?.subThoroughfare)! )
    print("locationLabel \(locationLabel.text)")

    if let roomPhotoUrlString = room?.roomPhotoUrl{
        let roomPhotoUrl = URL(string: roomPhotoUrlString)
        roomPhoto.sd_setImage(with: roomPhotoUrl)
    }
    
    if let timestamp = room?.timestamp {
        let timestampDate = Date(timeIntervalSince1970: Double(timestamp))
        let now = Date()
        let components = Set<Calendar.Component>([.second, .minute, .hour, .day, .weekOfMonth])
        let diff = Calendar.current.dateComponents(components, from: timestampDate, to: now)
        
        var timeText = ""
        if diff.second! <= 0 {
            timeText = "Now"
        }
        if diff.second! > 0 && diff.minute! == 0 {
            timeText = (diff.second == 1) ? "\(diff.second!) second ago" : "\(diff.second!) seconds ago"
        }
        if diff.minute! > 0 && diff.hour! == 0 {
            timeText = (diff.minute == 1) ? "\(diff.minute!) minute ago" : "\(diff.minute!) minutes ago"
        }
        if diff.hour! > 0 && diff.day! == 0 {
            timeText = (diff.hour == 1) ? "\(diff.hour!) hour ago" : "\(diff.hour!) hours ago"
        }
        if diff.day! > 0 && diff.weekOfMonth! == 0 {
            timeText = (diff.day == 1) ? "\(diff.day!) day ago" : "\(diff.day!) days ago"
        }
        if diff.weekOfMonth! > 0 {
            timeText = (diff.weekOfMonth == 1) ? "\(diff.weekOfMonth!) week ago" : "\(diff.weekOfMonth!) weeks ago"
        }
        
        timestampLabel.text = timeText
    }
    
}

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
