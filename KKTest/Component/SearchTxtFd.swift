//
//  SearchTxtFd.swift
//  KKTest
//
//  Created by 劉宥銘 on 2024/6/12.
//

import UIKit

class SearchTextField: UITextField {
    let padding = 10.0
    let height = 34.0
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
       
        let img = UIImage(systemName: "magnifyingglass")
        let imgWidth = img?.size.width ?? 0
        let imgv = UIImageView(image: img)
        let holder = UIView(frame: CGRect(x: padding, y: 0, width: imgWidth + padding , height: height))
        imgv.frame = CGRect(x: 0, y: 2, width: imgWidth , height: height)
        
        leftViewMode = .always
        
        imgv.contentMode = .scaleAspectFit
        imgv.tintColor = .gray
        holder.addSubview(imgv)
        leftView = holder
    }
    
    override func leftViewRect(forBounds bounds: CGRect) -> CGRect {
        let width = UIImage(systemName: "magnifyingglass")?.size.width ?? 0
        return CGRect(x: padding, y: 0, width: width + padding, height: height)
    }
}
