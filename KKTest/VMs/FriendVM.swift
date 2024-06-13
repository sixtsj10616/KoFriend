//
//  FriendVM.swift
//  KKTest
//
//  Created by 劉宥銘 on 2024/6/8.
//

import Foundation

protocol FriendVMDelegate {
    func onGetUserInfo()
    func onGetFriendList()
}

class FriendVM {
    var viewStatus: ViewStatus = .noData
    var friendList = [FriendInfoM]()
    var inviteList = [FriendInfoM]()
    var friendSearchList = [FriendInfoM]()
    var userInfo: ManInfoM?
    var delegate: FriendVMDelegate?
    
    init(status: ViewStatus = .noData){
        self.viewStatus = status
    }
    
    func fetchData (){
        getUserInfoApi()
        
        switch(viewStatus){
        case .noData:
            getNoDataFriendListApi()
            break
        case .frindOnly:
            getFriendListApi()
            getFriendList2Api()
            break
        case .frindAndInvite:
            getFriendAndInviteListApi()
            break
        }
    }
    
    func searchFriendList(keyword: String?){
        guard let keyword = keyword else {
            friendSearchList.removeAll()
            return
        }
                 
        friendSearchList = friendList.filter({ model in
            return model.name.contains(keyword)
        })
    }
    
    //MARK: - APIs
    private func getUserInfoApi(){
        WSCenter.Shared.getUserInfo { responseData, statusCode in
            self.userInfo = responseData?.response?.first
            self.delegate?.onGetUserInfo()
        } Fail: { err, statusCode in
            print("[Test] getUserInfoApi Err: \(err ?? "unknow")")
        }
    }
    
    private func getNoDataFriendListApi(){
        WSCenter.Shared.getNoDataFriendList { responseData, statusCode in
            self.delegate?.onGetFriendList()
        } Fail: { err, statusCode in
            print("[Test] getNoDataFriendList Err: \(err ?? "unknow")")
        }
    }
    
    private func getFriendListApi(){
        WSCenter.Shared.getFriendList(Success: { responseData, statusCode in
            if let tmpFriends = responseData?.response, tmpFriends.count > 0 {
                let tmpList = tmpFriends.filter({ model in
                    return model.status < FrindStatus.beInvite.rawValue
                })
                self.mergeFriendList(list: tmpList)
            }
            self.delegate?.onGetFriendList()
            
        }, Fail: { err, statusCode in
            print("[Test] getFriendList Err: \(err ?? "unknow")")
        })
    }
    
    private func getFriendList2Api(){
        WSCenter.Shared.getFriendList2(Success: { responseData, statusCode in
            if let tmpFriends = responseData?.response, tmpFriends.count > 0 {
                let tmpList = tmpFriends.filter({ model in
                    return model.status < FrindStatus.beInvite.rawValue
                })
                tmpList.forEach { model in
                    model.updateDate = Utility.convertStringDateFormate(forStringDate: model.updateDate, currentFormate: Date_Normail, newFormate: Date_Combine)
                }
                self.mergeFriendList(list: tmpList)
            }
            self.delegate?.onGetFriendList()
            
        }, Fail: { err, statusCode in
            print("[Test] getFriendList2 Err: \(err ?? "unknow")")
        })
    }
    
    private func getFriendAndInviteListApi(){
        WSCenter.Shared.getFriendAndInviteList(Success: { responseData, statusCode in
            if let tmpFriends = responseData?.response, tmpFriends.count > 0 {
                tmpFriends.forEach { model in
                    if model.status == FrindStatus.beInvite.rawValue {
                        self.inviteList.append(model)
                    }
                    else{
                        self.friendList.append(model)
                    }
                }
            }
            self.delegate?.onGetFriendList()
        }, Fail: { err, statusCode in
            print("[Test] getFriendAndInviteListApi Err: \(err ?? "unknow")")
        })
    }
    
    //MARK: - other
    private func mergeFriendList(list:  [FriendInfoM]){
        if friendList.isEmpty {
            friendList = list
            return
        }
        list.forEach { model in
            let repeatIndex = friendList.firstIndex { frListModel in
                return frListModel.fid == model.fid
            }
            if let repeatIndex = repeatIndex  {
                let frListMDate = Utility.getDateFromString(strDate: friendList[repeatIndex].updateDate, currentFormate: Date_Combine)
                let modelDate = Utility.getDateFromString(strDate: model.updateDate, currentFormate: Date_Combine)
                
                if let modelDate = modelDate, let frListMDate = frListMDate, modelDate > frListMDate{
                    friendList[repeatIndex] = model
                }
            }
            else{
                friendList.append(model)
            }
        }
    }
}
