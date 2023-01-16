//
//  services.swift
//  SearchApp
//
//  Created by Glenndon on 1/16/23.
//

import Foundation

enum NetworkError: Error {
    case badURL
    case badID
}

class Services {
    
    func getUserDetails(searchTerm: String) async throws -> UserDetails {
        var components = URLComponents()
        components.scheme = "https"
        components.host = "api.github.com"
        components.path = "/users/"+String(searchTerm)+""
        
        guard let url = components.url else {
            throw NetworkError.badURL
        }
        
        let (data, response) = try await URLSession.shared.data(from: url)
        
        guard (response as? HTTPURLResponse)?.statusCode == 200 else {
            throw NetworkError.badID
        }
        
        let userDetailsResponse = try? JSONDecoder().decode(UserDetails.self, from: data)
        
        let returnDetails = userDetailsResponse ?? UserDetails(id: 0, userName: "", name: "", avatar: "", description: "", followerCount: 0, followingCount: 0)

        return returnDetails
        
    }

    func getUserList(searchTerm: String, page: String) async throws -> (UsersListsItems) {

        var components = URLComponents()
        components.scheme = "https"
        components.host = "api.github.com"
        components.path = "/search/users"
        components.queryItems = [
            URLQueryItem(name: "page", value: page),
            URLQueryItem(name: "q", value: searchTerm.trimmingCharacters(in: .whitespacesAndNewlines)),
        ]
        
        guard let url = components.url else {
            throw NetworkError.badURL
        }
         
        let (data, response) = try await URLSession.shared.data(from: url)
        
        guard (response as? HTTPURLResponse)?.statusCode == 200 else {
            throw NetworkError.badID
        }
        
        let userListResponse = try? JSONDecoder().decode(UsersListsItems.self, from: data)

        return userListResponse ?? UsersListsItems(userItemsList: [], pageCount: 0)
        
    }

    func getUserFollowList(searchTerm: String, page: String, isFollowing: Bool) async throws -> ([UserFollowList]) {

        var toPath = isFollowing ? "following" : "followers"
        
        var components = URLComponents()
        components.scheme = "https"
        components.host = "api.github.com"
        components.path = "/users/"+String(searchTerm)+"/"+String(toPath)+""
        components.queryItems = [
            URLQueryItem(name: "page", value: page),
        ]
        
        guard let url = components.url else {
            throw NetworkError.badURL
        }
         
        let (data, response) = try await URLSession.shared.data(from: url)
        
        guard (response as? HTTPURLResponse)?.statusCode == 200 else {
            throw NetworkError.badID
        }
        
        let getUserFollowList = try? JSONDecoder().decode([UserFollowList].self, from: data)

        return getUserFollowList ?? []
        
    }
    
}