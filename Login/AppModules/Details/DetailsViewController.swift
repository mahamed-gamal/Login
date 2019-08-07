//
//  DetailsViewController.swift
//  Login
//
//  Created by Mohamed Gamal on 8/7/19.
//  Copyright © 2019 ME. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase

class DetailsViewController: UIViewController {
    
    var data: Details?

    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView()
        loadDetailsUser()

    }
    
    func loadDetailsUser(){
        guard let id = Auth.auth().currentUser?.uid else {
            return
        }
        let database = Database.database().reference()
        database.child("users").child(id).observe(.value) { (response) in
            if let responsedata = response.value as? [String: String]{
                guard let userName = responsedata["username"] , let password = responsedata["password"] , let email = responsedata["email"] else {
                    return
                }
                
                let userData = Details.init(username: userName, email: email, password: password)
                self.data = userData
                self.tableView.reloadData()
            }
        }
    }
    


}



extension DetailsViewController : UITableViewDelegate , UITableViewDataSource {
    
    
    // Methods table view data source
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DetailsCell") as! DetailsCell
        if(indexPath.row == 0){
            cell.lbl.text = "user name : \(String(describing: data?.username ?? ""))"
        } else if (indexPath.row == 1){
            cell.lbl.text = "email : \(String(describing: data?.email ?? ""))"
        } else {
            cell.lbl.text = "password : \(String(describing: data?.password ?? ""))"
        }
        return cell
    }
}
