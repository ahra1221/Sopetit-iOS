//
//  ChallengeMemberEntity.swift.swift
//  Sopetit-iOS
//
//  Created by 고아라 on 8/15/24.
//

import Foundation

struct ChallengeMemberEntity: Codable {
    let memberChallengeID: Int
    let theme: ChallengeMemberTheme
    let content, description, place, timeTaken: String
    
    enum CodingKeys: String, CodingKey {
        case memberChallengeID = "memberChallengeId"
        case theme, content, description, place, timeTaken
    }
}

// MARK: - ChallengeMemberTheme
struct ChallengeMemberTheme: Codable {
    let themeID: Int
    let themeName: String
    
    enum CodingKeys: String, CodingKey {
        case themeID = "themeId"
        case themeName
    }
}

extension ChallengeMemberEntity {
    
    static func challengeMemberInitial() -> ChallengeMemberEntity {
        return ChallengeMemberEntity(memberChallengeID: 0, theme: ChallengeMemberTheme(themeID: 0, themeName: ""), content: "", description: "", place: "", timeTaken: "")
    }
}
