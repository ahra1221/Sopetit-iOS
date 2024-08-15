//
//
//  Created by Woo Jye Lee on 1/2/24.
//

import Foundation

struct NewDailyRoutineEntity: Codable {
    var routines: [DailyRoutines]
}

struct DailyRoutines: Codable {
    let themeId: Int
    let themeName: String
    let routines: [DailyRoutinev2]

    enum CodingKeys: String, CodingKey {
        case themeId = "themeId"
        case themeName
        case routines
    }
}

struct DailyRoutinev2: Codable {
    let routineId: Int
    let content: String
    let achieveCount: Int
    let isAchieve: Bool
}
