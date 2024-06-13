//
//  WSCenter.swift
//  KKTest
//
//  Created by 劉宥銘 on 2024/6/8.
//

import Foundation
import Alamofire


class WSCenter {
    static let Shared = WSCenter()
    
    func getURL<M:Decodable, E:Decodable>(strUrl: String, obj: [String:Any]?, Success success: ((_ responseData : M?, _ statusCode : Int) -> ())?, Fail fail: ((_ err : E?, _ statusCode : Int? ) -> ())?){
        
        AF.sessionConfiguration.timeoutIntervalForRequest = 30
        AF.request(strUrl, method: .get, parameters: obj, encoding: URLEncoding.default).response{ response in
            switch response.result {
                case .success:
                    let httpStatusCode = response.response?.statusCode ?? -1
                    guard let result = response.data else {
                        print("[Test] AF No Data in \(httpStatusCode) ")
                        success?(nil, httpStatusCode)
                        return
                    }
                    do {
                        let model = try JSONDecoder().decode(M.self, from: result)
                        success?(model, httpStatusCode)
                    } catch {
                        print("[Test] AF JSONDecoder Error : \(error)")
                    }
                    break
                case .failure(let error):
                    print("[Test] AF Error : \(error)")
                    break
            }
        }
    }
    
    func getUserInfo(Success success : (( _ responseData : ManM?, _ statusCode: Int) -> ())?, Fail fail : ((_ err : String?, _ statusCode: Int? ) -> ())?)
    {
        let url = "https://dimanyen.github.io/man.json"
        getURL(strUrl: url, obj: nil, Success: success, Fail: fail)
    }
    
    func getNoDataFriendList(Success success : (( _ responseData : FriendM?, _ statusCode: Int) -> ())?, Fail fail : ((_ err : String?, _ statusCode: Int? ) -> ())?)
    {
        let url = "https://dimanyen.github.io/friend4.json"
        getURL(strUrl: url, obj: nil, Success: success, Fail: fail)
    }
    
    func getFriendList(Success success : (( _ responseData : FriendM?, _ statusCode: Int) -> ())?, Fail fail : ((_ err : String?, _ statusCode: Int? ) -> ())?)
    {
        let url = "https://dimanyen.github.io/friend1.json"
        getURL(strUrl: url, obj: nil, Success: success, Fail: fail)
    }
    
    func getFriendList2(Success success : (( _ responseData : FriendM?, _ statusCode: Int) -> ())?, Fail fail : ((_ err : String?, _ statusCode: Int? ) -> ())?)
    {
        let url = "https://dimanyen.github.io/friend2.json"
        getURL(strUrl: url, obj: nil, Success: success, Fail: fail)
    }
    
    func getFriendAndInviteList(Success success : (( _ responseData : FriendM?, _ statusCode: Int) -> ())?, Fail fail : ((_ err : String?, _ statusCode: Int? ) -> ())?)
    {
        let url = "https://dimanyen.github.io/friend3.json"
        getURL(strUrl: url, obj: nil, Success: success, Fail: fail)
    }
}

