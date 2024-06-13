//
//  BaseVC.swift
//  KKTest
//
//  Created by 劉宥銘 on 2024/6/12.
//

import UIKit

class BaseVC: UIViewController{
    
    override func viewDidLoad() {
        setNavigationBar()
    }
    
    private func setNavigationBar() {
        let btnATM = createNaviBtn(imgName: "icNavPinkWithdraw")
        let btnTransfer = createNaviBtn(imgName: "icNavPinkTransfer")
        let btnScan = createNaviBtn(imgName: "icNavPinkScan")
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(onClickBack))
        btnATM.customView?.addGestureRecognizer(tap)
        
        self.navigationItem.leftBarButtonItems = [btnATM, btnTransfer]
        self.navigationItem.rightBarButtonItem = btnScan
    }
    
    private func createNaviBtn(imgName: String) -> UIBarButtonItem{
        let menubtn: UIButton = UIButton(type: UIButton.ButtonType.custom)
        let imageView = UIImageView(image: UIImage(named: imgName))
        imageView.frame = CGRect(x: 0, y: 0, width: 24, height: 24)
        imageView.tintColor = .gray
        menubtn.addSubview(imageView)
        menubtn.frame = CGRect(x: 0, y: 0, width: 24, height: 24)
        
        return UIBarButtonItem(customView: menubtn)
    }
    
    @objc private func onClickBack(){
        self.navigationController?.popViewController(animated: true)
    }
}
