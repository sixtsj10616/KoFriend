//
//  BadgeLabel.swift
//  KKTest
//
//  Created by 劉宥銘 on 2024/6/12.
//

import UIKit

class BadgeLabel: UILabel{
    
    func setBadge(num: Int){
        if num == 0 {
            self.isHidden = true
            self.text = "0"
            return
        }
        self.isHidden = false
        if num > 99 {
            self.text = "99+"
        }
        else {
            self.text = "\(num)"
        }
        setWidth()
    }
    
    private func setWidth(){
        let minWidth = 18.0
        let widthStep = 6.0
        let step = (Double)(self.text?.count ?? 1) - 1
        self.widthAnchor.constraint(equalToConstant: minWidth + widthStep * step).isActive = true
    }
}
