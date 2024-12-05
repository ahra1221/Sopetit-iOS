//
//  MemosResponseEntity.swift
//  Sopetit-iOS
//
//  Created by 고아라 on 12/3/24.
//

import Foundation

struct MemosResponseEntity: Codable {
    let memoID: Int
    
    enum CodingKeys: String, CodingKey {
        case memoID = "memoId"
    }
}
