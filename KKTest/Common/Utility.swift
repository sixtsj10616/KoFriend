//
//  Utility.swift
//  KKTest
//
//  Created by 劉宥銘 on 2024/6/12.
//

import Foundation
import UIKit

class Utility {
    
    class func convertStringDateFormate(forStringDate strDate: String, currentFormate: String, newFormate: String) -> String {
        if strDate == ""{
            return "";
        }
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = currentFormate
        dateFormatter.amSymbol = "AM"
        dateFormatter.pmSymbol = "PM"
        dateFormatter.timeZone = TimeZone(identifier: "Asia/Taipei")
        let dateObj = dateFormatter.date(from: strDate)
        dateFormatter.dateFormat = newFormate
        return dateObj == nil ? strDate : dateFormatter.string(from: dateObj!)
    }
    
    class func getDateFromString(strDate: String, currentFormate: String) -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = currentFormate
        dateFormatter.locale = Locale(identifier: "zh_Hant_TW")
        dateFormatter.timeZone = TimeZone(identifier: "Asia/Taipei")
        let dateObj = dateFormatter.date(from: strDate)
        return dateObj
    }
    
    class func loadViewController(sbName : String, vcName : String) -> UIViewController
    {
        let storyboard = UIStoryboard(name: sbName, bundle: nil)
        let VC = storyboard.instantiateViewController(withIdentifier: vcName)
        return VC
    }
}
