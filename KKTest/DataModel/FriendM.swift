//
//  FriendM.swift
//  KKTest
//
//  Created by 劉宥銘 on 2024/6/8.
//

import Foundation

class FriendM : Codable
{
    var response : [FriendInfoM]?
}

class FriendInfoM : Codable
{
    var name : String
    var status : Int
    var isTop : String
    var fid : String
    var updateDate : String
}
