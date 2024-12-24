//
//  AddChallengeEntity.swift
//  Sopetit-iOS
//
//  Created by 고아라 on 12/24/24.
//

struct AddChallengeEntity: Codable {
    let memberChallengeID: Int
    
    enum CodingKeys: String, CodingKey {
        case memberChallengeID = "memberChallengeId"
    }
}
