//
//  UserModel.swift
//  SearchApp
//
//  Created by Glenndon on 1/16/23.
//

import Foundation

@MainActor
class SearchListViewModel: ObservableObject {
    
    @Published var usersDataLists: [UserListViewModel] = []
    @Published var usersPrevDataLists: [UserListViewModel] = []
    @Published var pageTotalCurrent: Int = 0
    @Published var isNotFound: Bool = false
    
    func search(name: String, page: Int, loadMore: Bool) async {
        do {

            let usersLists = try await Services().getUserList(searchTerm: name, page: String(page))
            self.usersDataLists = usersLists.userItemsList.map(UserListViewModel.init)
            self.pageTotalCurrent = usersLists.pageCount
            self.isNotFound = false

            if(loadMore){
                self.usersPrevDataLists += self.usersDataLists
            }else{
                self.usersPrevDataLists = self.usersDataLists
            }

            if(self.usersDataLists.isEmpty){
                self.isNotFound = true
            }

        } catch {
            print(error)
        }
    }
    
}

@MainActor
class UserDetailViewModel: ObservableObject {
    @Published var usersDataDetails: UserDetailsViewModel?
    
    func search(name: String) async {
        do {
            let usersDataDetails = try await Services().getUserDetails(searchTerm: name)
            self.usersDataDetails = UserDetailsViewModel.init(userDesc: usersDataDetails)

        } catch {
            print(error)
        }
    }
}

@MainActor
class FollowListViewModel: ObservableObject {
    
    @Published var userFollowDataLists: [UsersFollowListsModel] = []
    @Published var userFollowPrevDataLists: [UsersFollowListsModel] = []
    
    func search(name: String, page: Int, loadMore: Bool, isFollowing: Bool) async {
        do {

            let usersFollowLists = try await Services().getUserFollowList(searchTerm: name,
                page: String(page), isFollowing: isFollowing)
            self.userFollowDataLists = usersFollowLists.map(UsersFollowListsModel.init)

            if(loadMore){
                self.userFollowPrevDataLists += self.userFollowDataLists
            }else{
                self.userFollowPrevDataLists = self.userFollowDataLists
            }

        } catch {
            print(error)
        }
    }
    
}

struct UsersFollowListsModel {
    
    let user: UserFollowList
    
    var id: Int {
        user.id
    }
    
    var userNames: String {
        user.userNames
    }
    
    var avatar: URL? {
        URL(string: user.avatar)
    }
    
}


struct UserListViewModel {
    
    let user: UserList
    
    var id: Int {
        user.id
    }
    
    var userNames: String {
        user.userNames
    }
    
    var avatar: URL? {
        URL(string: user.avatar)
    }
}

struct UserDetailsViewModel {
    
    let userDesc: UserDetails

    var id: Int {
        userDesc.id
    }
    
    var userNames: String {
        userDesc.userName
    }

    var name: String {
        userDesc.name
    }
    
    var avatar: URL? {
        URL(string: userDesc.avatar)
    }
    
    var description: String {
        userDesc.description
    }

    var followerCount: Int {
        userDesc.followerCount
    }

    var followingCount: Int {
        userDesc.followingCount
    }
}

struct SelectedUser{
    var name: String
}

struct ToFollow{
    var isItFollowing: Bool
    var selectedUser: String
    var followCount: Int
}
