//
//  FriendVC.swift
//  KKTest
//
//  Created by 劉宥銘 on 2024/6/8.
//

import Foundation
import UIKit

class FriendVC: BaseVC, FriendVMDelegate, UITableViewDelegate, UITableViewDataSource{
   
    @IBOutlet weak var lblUserName: UILabel!
    @IBOutlet weak var vIDHint: UIView!
    @IBOutlet weak var vNoData: UIView!
    @IBOutlet weak var vTabDash: UIView!
    @IBOutlet weak var btnAddFriend : UIButton!
    @IBOutlet weak var btnFriendTab : UIButton!
    @IBOutlet weak var btnChatTab : UIButton!
    @IBOutlet weak var tabFriends: UITableView!
    @IBOutlet weak var tabInvites: UITableView!
    @IBOutlet weak var txfSearch: UITextField!
    @IBOutlet weak var alcInvitesHeight: NSLayoutConstraint!
    @IBOutlet weak var alcDashLeft: NSLayoutConstraint!
    @IBOutlet weak var lblInviteBadge: BadgeLabel!
    @IBOutlet weak var lblChatBadge: BadgeLabel!
    
    let cellId = "FriendCell"
    let cellInviteId = "InviteCell"
    let cellInviteHeight = 78.0
    let loadingView = UIActivityIndicatorView(style: .medium)
    var vm = FriendVM(status: .frindAndInvite)
    var isLoading = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setView()
        vm.delegate = self
        vm.fetchData()
    }
    
    private func setView() {
        setbtnAddFriend()
        setInviteList(isHidden: true)
        txfSearch.addTarget(self, action: #selector(textFieldOnChange(_:)), for: .editingChanged)
        tabFriends.delegate = self
        tabFriends.dataSource = self
        tabInvites.delegate = self
        tabInvites.dataSource = self
        tabFriends.tableFooterView = loadingView
        tabFriends.tableFooterView?.isHidden = true
        lblInviteBadge.setBadge(num: 0)
        lblChatBadge.setBadge(num: 100)
        btnFriendTab.addTarget(self, action: #selector(onClickFriendTab(_:)), for: .touchUpInside)
        btnChatTab.addTarget(self, action: #selector(onClickChatTab(_:)), for: .touchUpInside)
    }
    
    private func setbtnAddFriend() {
        let gradient = CAGradientLayer()
        gradient.frame = btnAddFriend.bounds
        gradient.colors = [Color_FrogGreen.cgColor, Color_Booger.cgColor]
        gradient.startPoint = CGPoint(x: 0.0,y: 0.0)
        gradient.endPoint = CGPoint(x: 1.0,y: 0.0)
        gradient.cornerRadius = 20
        btnAddFriend.layer.insertSublayer(gradient, at: 0)
    }
    
    private func setInviteList(isHidden: Bool){
        if isHidden {
            alcInvitesHeight.constant = 0
            tabInvites.isHidden = true
        }
        else{
            tabInvites.isHidden = false
            UIView.animate(withDuration: 0.3) {
                self.alcInvitesHeight.constant = min(self.cellInviteHeight * 4, self.cellInviteHeight * Double(self.vm.inviteList.count))
                self.view.layoutIfNeeded()
            }
        }
    }
    
    //MARK: - Event
    @objc func onClickFriendTab(_ button: UIButton) {
        setTab(button: button)
    }
    
    @objc func onClickChatTab(_ button: UIButton) {
        setTab(button: button)
    }
    
    @objc func textFieldOnChange(_ textField: UITextField) {
        vm.searchFriendList(keyword: textField.text)
        tabFriends.reloadData()
    }
    
    //MARK: - FriendVMDelegate
    func onGetUserInfo() {
        lblUserName.text = vm.userInfo?.name
        if(vm.userInfo?.kokoid != nil && vm.userInfo?.kokoid.trimmingCharacters(in: .whitespaces) != ""){
            vIDHint.isHidden = true
        }
    }
    
    func onGetFriendList() {
        
        if vm.friendList.count > 0 {
            tabFriends.isHidden = false
            tabFriends.reloadData()
        }
        else{
            tabFriends.isHidden = true
            vNoData.isHidden = false
            lblChatBadge.setBadge(num: 0)
        }
        if vm.inviteList.count > 0 {
            lblInviteBadge.setBadge(num: vm.inviteList.count)
            setInviteList(isHidden: false)
            tabInvites.reloadData()
        }
    }
   
   
    //MARK: - UITableView
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableView == tabFriends
                            ? (txfSearch.text?.count ?? 0 > 0 ? vm.friendSearchList.count : vm.friendList.count )
                            : vm.inviteList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let isFriendList = tableView == tabFriends ? true : false
        if isFriendList {
            let isSearching = txfSearch.text?.count ?? 0 > 0 ? true : false
            let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! FriendCell
            let obj = isSearching ? vm.friendSearchList[indexPath.row] : vm.friendList[indexPath.row]
            cell.lblName.text = obj.name
            cell.imgStar.isHidden = obj.isTop == "0" ? true : false
            cell.setCell(status: FrindStatus(rawValue: obj.status) ?? .already )
            return cell
        }
        else {
            let cell = tableView.dequeueReusableCell(withIdentifier: cellInviteId, for: indexPath) as! InviteCell
            let obj = vm.inviteList[indexPath.row]
            cell.lblName.text = obj.name
            return cell
        }
    }
    
    //MARK: - Loadmore
    func scrollViewWillBeginDecelerating(_ scrollView: UIScrollView) {
        let height = scrollView.frame.size.height
        let contentYoffset = scrollView.contentOffset.y
        let distanceFromBottom = scrollView.contentSize.height - contentYoffset
        
        if distanceFromBottom < height && !isLoading {
            isLoading = true
            tabFriends.tableFooterView?.isHidden = false
            loadingView.startAnimating()
            DispatchQueue.global(qos: .background).async {
                Timer.scheduledTimer(withTimeInterval: 2, repeats: false) { _ in
                    DispatchQueue.main.async {
                        self.isLoading = false
                        self.tabFriends.tableFooterView?.isHidden = true
                        self.loadingView.stopAnimating()
                    }
                }
                RunLoop.current.run()
            }
        }
    }
    
    //MARK: - FriendVMDelegate
    func setTab(button: UIButton) {
        let isChatTab = button == btnFriendTab
        btnFriendTab.titleLabel?.font = .systemFont(ofSize: 13.0, weight: isChatTab ? .medium : .regular)
        btnChatTab.titleLabel?.font = .systemFont(ofSize: 13.0, weight: isChatTab ? .regular : .medium)
        
        UIView.animate(withDuration: 0.3) {
            self.alcDashLeft.constant = button.center.x - 10.0
            self.view.layoutIfNeeded()
        }
    }
}
