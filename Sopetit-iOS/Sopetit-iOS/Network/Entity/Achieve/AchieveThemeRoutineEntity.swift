//
//  AchieveThemeRoutineEntity.swift
//  Sopetit-iOS
//
//  Created by ahra on 1/13/25.
//

struct AchieveThemeRoutineEntity: Codable {
    let id: Int
    let name: String
    let routines, challenges: [ThemeChallenge]
}

// MARK: - ThemeChallenge
struct ThemeChallenge: Codable {
    let content: String
    let achievedCount: Int
    let startedAt: String
}
