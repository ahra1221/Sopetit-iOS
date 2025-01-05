//
//  HomeTutorialEntity.swift
//  Sopetit-iOS
//
//  Created by 고아라 on 8/3/24.
//

import UIKit

struct HomeTutorialEntity {
    let tutorial: String
    let title: String
    let description: String
    let img: UIImage
    let keyword: [String]
}

extension HomeTutorialEntity {
    
    static func tutorialData() -> [HomeTutorialEntity] {
        return [
            HomeTutorialEntity(tutorial: "데일리 루틴",
                               title: "매일 작은 성취감을 만드는 루틴",
                               description: "매일 실천할 수 있는 쉬운 루틴을 제안해요.\n루틴을 완료하면 솜뭉치를 얻어요.",
                               img: UIImage(resource: .imgTutorial1),
                               keyword: ["매일 실천할 수 있는 쉬운 루틴", "솜뭉치"]),
            HomeTutorialEntity(tutorial: "챌린지",
                               title: "나를 찾아가는 특별한 루틴",
                               description: "특별한 일상을 위한 챌린지형 루틴이에요.\n루틴을 완료하면 무지개 솜뭉치를 얻어요.",
                               img: UIImage(resource: .imgTutorial2),
                               keyword: ["특별한 일상을 위한 챌린지형 루틴", "무지개 솜뭉치"]),
            HomeTutorialEntity(tutorial: "솜뭉치 주기",
                               title: "솜뭉치를 얻으면?",
                               description: "얻은 솜뭉치는 곰인형에게 줄 수 있어요!\n곰인형이 어떤 반응을 보일까요?",
                               img: UIImage(resource: .imgTutorial3),
                               keyword: ["얻은 솜뭉치는 곰인형에게 줄 수 있어요!\n곰인형이 어떤 반응을 보일까요?"])
        ]
    }
}
