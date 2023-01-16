//
//  UserObject.swift
//  SearchApp
//
//  Created by Glenndon on 1/16/23.
//

import Foundation

struct UsersListsItems: Decodable {
    let userItemsList: [UserList]
    let pageCount: Int
    
    private enum CodingKeys: String, CodingKey {
        case userItemsList = "items"
        case pageCount = "total_count"
    }
}

struct UserFollowList: Decodable {
    let id: Int
    let userNames: String
    let avatar: String
    
    private enum CodingKeys: String, CodingKey {
        case id = "id"
        case userNames = "login"
        case avatar = "avatar_url"
    }
    
}

struct UserList: Decodable {
    let id: Int
    let userNames: String
    let avatar: String
    
    private enum CodingKeys: String, CodingKey {
        case id = "id"
        case userNames = "login"
        case avatar = "avatar_url"
    }
    
}

struct UserDetails: Decodable {
    let id: Int
    let userName: String
    let name: String
    let avatar: String
    let description: String
    let followerCount: Int
    let followingCount: Int
    
    private enum CodingKeys: String, CodingKey {
        case id = "id"
        case userName = "login"
        case name = "name"
        case avatar = "avatar_url"
        case description = "bio"
        case followerCount = "followers"
        case followingCount = "following"
    }
}
