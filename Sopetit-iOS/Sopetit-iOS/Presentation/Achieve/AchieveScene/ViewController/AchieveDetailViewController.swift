//
//  AchieveDetailViewController.swift
//  Sopetit-iOS
//
//  Created by ahra on 1/13/25.
//

import UIKit

import SnapKit

final class AchieveDetailViewController: UIViewController {
    
    // MARK: - Properties
    
    var cellInfo: StatsRoutineInfo = StatsRoutineInfo(themeId: 0, totalCount: 0)
    
    // MARK: - UI Components
    
    private let achieveDetailView = AchieveStatsDetailView()
    private lazy var detailChallengeCV = achieveDetailView.challengeCollectionView
    private lazy var detailDailyCV = achieveDetailView.dailyCollectionView
    
    // MARK: - Life Cycles
    
    override func loadView() {
        self.view = achieveDetailView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUI()
        setDelegate()
    }
}

// MARK: - Extensions

extension AchieveDetailViewController {
    
    func setUI() {
        self.navigationController?.navigationBar.isHidden = true
        achieveDetailView.bindAchieveDetail(model: self.cellInfo)
    }
    
    func setDelegate() {
        detailChallengeCV.delegate = self
        detailChallengeCV.dataSource = self
        detailDailyCV.delegate = self
        detailDailyCV.dataSource = self
    }
}

extension AchieveDetailViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        switch collectionView {
        case detailChallengeCV:
            //            let label: UILabel = {
            //                let label = UILabel()
            //                let value = findValue(for: formatDateToString(selectedDate ?? Date()))
            //                label.text = value.histories[indexPath.section].histories[indexPath.item].content.replacingOccurrences(of: "\n", with: " ")
            //                label.font = .fontGuide(.body2)
            //                return label
            //            }()
            //
            //            let height = max(heightForView(text: label.text ?? "", font: label.font, width: SizeLiterals.Screen.screenWidth - 119), 24) + 32
            //
            return CGSize(width: SizeLiterals.Screen.screenWidth - 40, height: 100)
        case detailDailyCV:
            return CGSize(width: SizeLiterals.Screen.screenWidth - 40, height: 79)
        default:
            return CGSize()
        }
    }
}

extension AchieveDetailViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch collectionView {
        case detailChallengeCV:
            return 1
        case detailDailyCV:
            return 1
        default:
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch collectionView {
        case detailChallengeCV:
            let cell = StatsDetailCell.dequeueReusableCell(collectionView: detailChallengeCV, indexPath: indexPath)
            return cell
        case detailDailyCV:
            let cell = StatsDetailCell.dequeueReusableCell(collectionView: detailDailyCV, indexPath: indexPath)
            return cell
        default:
            return UICollectionViewCell()
        }
    }
}
