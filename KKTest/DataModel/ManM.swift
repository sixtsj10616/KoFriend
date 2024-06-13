//
//  ManM.swift
//  KKTest
//
//  Created by 劉宥銘 on 2024/6/8.
//

import Foundation

class ManM : Codable
{
    var response : [ManInfoM]?
}

class ManInfoM : Codable
{
    var name : String
    var kokoid : String
}
