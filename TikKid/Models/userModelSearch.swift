//
//  userModelSearch.swift
//  TikKid
//
//  Created by Christina Santana on 20/2/23.
//

import Foundation
struct UserModelSearch: Codable{
    let profilePicUrl: String
    let nickname: String
    let userId: String
    let follower: Int
    let following: Int
    let likes: Int
    var commentCount: Int
}
