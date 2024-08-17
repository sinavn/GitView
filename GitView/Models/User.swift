//
//  User.swift
//  GitView
//
//  Created by Sina Vosough Nia on 5/26/1403 AP.
//

import Foundation

struct User:Codable {
    let login : String
    let avatarUrl : String
    let name : String?
    let location : String?
    let bio : String?
    let publicRepos : Int
    let publicGists : Int
    let htmlUrl : String
    let following : Int
    let followers : Int
    let createdAt : String
}
