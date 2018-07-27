//
//  HomeViewController.swift
//  NearBoddy
//
//  Created by 岡本　優河 on 2018/07/15.
//  Copyright © 2018年 岡本　優河. All rights reserved.
//

import UIKit
import ProgressHUD
class HomeViewController: UIViewController {

    @IBOutlet weak var tableView:UITableView!
    var posts = [PostModel]()
    var users = [UserModel]()
    override func viewDidLoad() {
        super.viewDidLoad()
    tableView.dataSource = self
    loadPost()
    }
    
    func loadPost(){
        ProgressHUD.show("読み込み中です", interaction: false)
        
        Api.Post.REF_POSTS.observe(.childAdded) { snapshot in
            print(Thread.isMainThread)
            if let dict = snapshot.value as? [String: Any] {
                
                let newPost = PostModel.transformPost(dict: dict)
                print("newRoom \(dict)")
                self.fetchUser(uid: newPost.uid!, completion: {
                    self.posts.append(newPost)
                    self.tableView.reloadData()
                })
            }
            ProgressHUD.dismiss()
//            ProgressHUD.showSuccess("読み込みが完了しました！")
        }
        
    }
    
    func fetchUser(uid: String, completion:  @escaping () -> Void ){
        Api.User.REF_USERS.child(uid).observeSingleEvent(of: .value, with: {
            snapshot in
            if let dict = snapshot.value as? [String: Any] {
                let user = UserModel.transformUser(dict: dict, key: snapshot.key)
                self.users.append(user)
                completion()
            }
        })
        
    }

    @IBAction func logOut_touchUpInside(_ sender: Any) {
        AuthService.logOut(onSuccess: {
            let storyboard = UIStoryboard(name: "Start", bundle: nil)
            let signInVC = storyboard.instantiateViewController(withIdentifier: "SignInViewController")
            self.present(signInVC, animated: true, completion: nil)
        }) { (errorMessage) in
            ProgressHUD.showError(errorMessage)
        }
    }

}

extension HomeViewController: UITableViewDataSource,UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! HomeTableViewCell
        let post = posts[indexPath.row]
        let user = users[indexPath.row]
        
        cell.post = post
        cell.user = user
        return cell
    }
}
