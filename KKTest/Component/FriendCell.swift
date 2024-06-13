//
//  FriendCell.swift
//  KKTest
//
//  Created by 劉宥銘 on 2024/6/11.
//

import UIKit

class FriendCell : UITableViewCell {
    @IBOutlet weak var imgHeadshot: UIImageView!
    @IBOutlet weak var imgStar: UIImageView!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblInviting: UILabel!
    @IBOutlet weak var btnTransfer: UIButton!
    @IBOutlet weak var btnMore: UIButton!
    @IBOutlet weak var alcTransfer: NSLayoutConstraint!
    
    func setCell(status: FrindStatus = .already){
        switch(status){
        case .inviting:
            lblInviting.isHidden = false
            alcTransfer.constant = 90
            btnMore.isHidden = true
            break
        case.already:
            lblInviting.isHidden = true
            alcTransfer.constant = 73
            btnMore.isHidden = false
            break
        case.beInvite:
            lblInviting.isHidden = true
            alcTransfer.constant = 73
            btnMore.isHidden = false
            break
        }
        
    }
}
