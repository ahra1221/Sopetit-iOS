//
//  RoutineChallengeEntity.swift
//  Sopetit-iOS
//
//  Created by 고아라 on 8/13/24.
//

import Foundation

struct RoutineChallengeEntity: Codable {
    let challenges: [Challenge]
}

// MARK: - Challenge
struct Challenge: Codable {
    let challengeID: Int
    let content, description, requiredTime, place: String
    let hasRoutine: Bool

    enum CodingKeys: String, CodingKey {
        case challengeID = "challengeId"
        case content, description, requiredTime, place, hasRoutine
    }
}
