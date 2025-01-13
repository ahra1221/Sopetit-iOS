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
    private var dailyRoutines: [ThemeChallenge] = []
    private var challengeRoutines: [ThemeChallenge] = []
    
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
        
        getAchievementThemesAPI()
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
        achieveDetailView.navigationBar.delegate = self
        detailChallengeCV.delegate = self
        detailChallengeCV.dataSource = self
        detailDailyCV.delegate = self
        detailDailyCV.dataSource = self
    }
}

extension AchieveDetailViewController: BackButtonProtocol {
    
    func tapBackButton() {
        self.navigationController?.popViewController(animated: true)
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
            return challengeRoutines.count
        case detailDailyCV:
            return dailyRoutines.count
        default:
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch collectionView {
        case detailChallengeCV:
            let cell = StatsDetailCell.dequeueReusableCell(collectionView: detailChallengeCV, indexPath: indexPath)
            cell.bindStatsDetail(entity: self.challengeRoutines[indexPath.item],
                                 themeId: cellInfo.themeId,
                                 isChallenge: true)
            return cell
        case detailDailyCV:
            let cell = StatsDetailCell.dequeueReusableCell(collectionView: detailDailyCV, indexPath: indexPath)
            cell.bindStatsDetail(entity: self.dailyRoutines[indexPath.item],
                                 themeId: cellInfo.themeId,
                                 isChallenge: false)
            return cell
        default:
            return UICollectionViewCell()
        }
    }
}

extension AchieveDetailViewController {
    
    func getAchievementThemesAPI() {
        AchieveService.shared.getAchievementThemesRoutineAPI(themeId: cellInfo.themeId) { networkResult in
            switch networkResult {
            case .success(let data):
                if let data = data as? GenericResponse<AchieveThemeRoutineEntity> {
                    if let achieveThemeRoutineData = data.data {
                        self.dailyRoutines = achieveThemeRoutineData.routines
                        self.challengeRoutines = achieveThemeRoutineData.challenges
                        self.achieveDetailView.bindTotalDetail(total: self.dailyRoutines.count, isChallenge: false)
                        self.achieveDetailView.bindTotalDetail(total: self.challengeRoutines.count, isChallenge: true)
                        self.detailDailyCV.reloadData()
                        self.detailChallengeCV.reloadData()
                    }
                }
            case .reissue:
                ReissueService.shared.postReissueAPI(refreshToken: UserManager.shared.getRefreshToken) { success in
                    if success {
                        self.getAchievementThemesAPI()
                    } else {
                        self.makeSessionExpiredAlert()
                    }
                }
            case .requestErr, .serverErr:
                self.makeServerErrorAlert()
            default:
                break
            }
        }
    }
}
