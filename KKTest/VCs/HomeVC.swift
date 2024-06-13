//
//  ViewController.swift
//  KKTest
//
//  Created by 劉宥銘 on 2024/6/8.
//

import UIKit

class HomeVC: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var tabV: UITableView!
    
    let cellId = "MenuCell"
    let aryMenu = [(title: "無好友", status: 0),(title: "好友列表", status: 1),(title: "好友與邀請列表", status: 2)]

    override func viewDidLoad() {
        super.viewDidLoad()
        tabV.dataSource = self
        tabV.delegate = self
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return aryMenu.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! MenuCell
        cell.lblTitle.text = aryMenu[indexPath.row].title
        
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = Utility.loadViewController(sbName: "Main", vcName: "FriendVC") as! FriendVC
        vc.vm = FriendVM(status: ViewStatus(rawValue: aryMenu[indexPath.row].status) ?? .noData)
        self.navigationController?.pushViewController(vc, animated: true)
    }
    

}

