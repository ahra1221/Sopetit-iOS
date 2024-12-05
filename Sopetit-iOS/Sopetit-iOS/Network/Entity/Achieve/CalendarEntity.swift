//
//  CalendarEntity.swift
//  Sopetit-iOS
//
//  Created by 고아라 on 12/5/24.
//

import Foundation

struct CalendarEntity: Codable {
    let success: Bool
    let message: String
    let data: [String: CalendarDate]
}

// MARK: - CalendarDate
struct CalendarDate: Codable {
    let memoID: Int
    let memoContent: String
    let histories: [CalendarHistory]

    enum CodingKeys: String, CodingKey {
        case memoID = "memoId"
        case memoContent, histories
    }
}

// MARK: - CalendarHistory
struct CalendarHistory: Codable {
    let themeID: Int
    let themeName: String
    let histories: [HistoryHistory]

    enum CodingKeys: String, CodingKey {
        case themeID = "themeId"
        case themeName, histories
    }
}

// MARK: - HistoryHistory
struct HistoryHistory: Codable {
    let historyID: Int
    let content: String
    let isMission: Bool

    enum CodingKeys: String, CodingKey {
        case historyID = "historyId"
        case content, isMission
    }
}
