//
//  RoutineChoiceViewController.swift
//  Sopetit-iOS
//
//  Created by 고아라 on 2024/01/10.
//

import UIKit

final class RoutineChoiceViewController: UIViewController {
    
    // MARK: - Properties
    
    var selectedTheme: [Int] = []
    var userDollName: String = ""
    private var selectedCount: Int = 0
    private var selectedFirstCount: Int = 0
    private var selectedSecondCount: Int = 0
    private var selectedThirdCount: Int = 0
    private var selectedRoutine: [Int] = []
    private var selectedThemeIndexPath: IndexPath? = [0, 0]
    private var routineEntity: [[Routine]] = Array(repeating: [], count: 3)
    private var dollEntity = DollImageEntity(faceImageURL: "")
    
    // MARK: - UI Components
    
    private let routineChoiceView = RoutineChoiceView()
    private lazy var themeCollectionView = routineChoiceView.themeCollectionView
    private lazy var routineFirstCollectionView = routineChoiceView.routineFirstCollectionView
    private lazy var routineSecondCollectionView = routineChoiceView.routineSecondCollectionView
    private lazy var routineThirdCollectionView = routineChoiceView.routineThirdCollectionView
    
    // MARK: - Life Cycles
    
    override func loadView() {
        super.loadView()
        
        view = routineChoiceView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUI()
        setDelegate()
        setAddTarget()
        getRoutineAPI()
    }
}

// MARK: - Extensions

extension RoutineChoiceViewController {
    
    func setUI() {
        self.navigationController?.navigationBar.isHidden = true
    }
    
    func setDelegate() {
        routineChoiceView.navigationView.delegate = self
        
        let collectionViews: [UICollectionView] = [themeCollectionView, routineFirstCollectionView, routineSecondCollectionView, routineThirdCollectionView]
        collectionViews.forEach {
            $0.delegate = self
            $0.dataSource = self
        }
    }
    
    func setAddTarget() {
        routineChoiceView.nextButton.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
    }
    
    @objc
    func buttonTapped(_ sender: UIButton) {
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let keyWindow = windowScene.windows.first else {
            return
        }
        let nav = TabBarController()
        postMemberAPI()
        UserManager.shared.hasPostMember()
        keyWindow.rootViewController = UINavigationController(rootViewController: nav)
    }
    
    func setCollectionView(idx: Int) {
        switch idx {
        case 0:
            routineFirstCollectionView.isHidden = false
            routineSecondCollectionView.isHidden = true
            routineThirdCollectionView.isHidden = true
        case 1:
            routineFirstCollectionView.isHidden = true
            routineSecondCollectionView.isHidden = false
            routineThirdCollectionView.isHidden = true
        case 2:
            routineFirstCollectionView.isHidden = true
            routineSecondCollectionView.isHidden = true
            routineThirdCollectionView.isHidden = false
        default:
            break
        }
    }
    
    func setSelectedCount(routineIndex: Int) {
        let bindCnt =
        switch routineIndex {
        case 0:
            selectedFirstCount
        case 1:
            selectedSecondCount
        case 2:
            selectedThirdCount
        default:
            0
        }
        if let selectedTheme = themeCollectionView.cellForItem(at: [0, routineIndex]) as? RoutineThemeCollectionViewCell {
            selectedTheme.setCountDataBind(cnt: bindCnt)
        }
    }
    
    func setSelectedCell(in collectionView: UICollectionView, 
                         at indexPath: IndexPath,
                         routineIndex: Int) -> Bool {
        if let selectedCell = collectionView.cellForItem(at: indexPath) as? RoutineChoiceCollectionViewCell {
            if !selectedCell.isSelected {
                if selectedCount < 3 {
                    switch routineIndex {
                    case 0:
                        selectedFirstCount += 1
                    case 1:
                        selectedSecondCount += 1
                    case 2:
                        selectedThirdCount += 1
                    default:
                        break
                    }
                    setSelectedCount(routineIndex: routineIndex)
                    makeVibrate()
                    selectedCount += 1
                    selectedRoutine.append(routineEntity[routineIndex][indexPath.item].routineID)
                    selectedCell.isSelected = true
                    routineChoiceView.bubbleLabel.text = "아래에서 루틴을 골라봐\n지금까지 \(selectedCount)/3개를 추가했어!"
                    routineChoiceView.bubbleLabel.partColorChange(targetString: "\(selectedCount)/3", textColor: .Red200)
                    routineChoiceView.bubbleLabel.textAlignment = .center
                    if selectedCount == 3 {
                        routineChoiceView.nextButton.isEnabled = true
                    }
                } else {
                    return false
                }
            }
        }
        return true
    }
    
    func setDeselectedCell(in collectionView: UICollectionView, 
                           at indexPath: IndexPath,
                           routineIndex: Int) -> Bool {
        if let deselectedCell = collectionView.cellForItem(at: indexPath) as? RoutineChoiceCollectionViewCell {
            if deselectedCell.isSelected {
                if let index = selectedRoutine.firstIndex(where: { num in num == routineEntity[routineIndex][indexPath.item].routineID }) {
                    selectedRoutine.remove(at: index)
                }
                switch routineIndex {
                case 0:
                    selectedFirstCount -= 1
                case 1:
                    selectedSecondCount -= 1
                case 2:
                    selectedThirdCount -= 1
                default:
                    break
                }
                setSelectedCount(routineIndex: routineIndex)
                selectedCount -= 1
                deselectedCell.isSelected = false
                routineChoiceView.bubbleLabel.text = "아래에서 루틴을 골라봐\n지금까지 \(selectedCount)/3개를 추가했어!"
                routineChoiceView.bubbleLabel.partColorChange(targetString: "\(selectedCount)/3", textColor: .Red200)
                routineChoiceView.bubbleLabel.textAlignment = .center
                routineChoiceView.nextButton.isEnabled = false
            }
        }
        return true
    }
}

extension RoutineChoiceViewController: BackButtonProtocol {
    
    func tapBackButton() {
        self.navigationController?.popViewController(animated: true)
    }
}

// MARK: - Network

extension RoutineChoiceViewController {
    func getRoutineAPI() {
        selectedTheme.sort()
        let routineID = selectedTheme.map { String($0) }.joined(separator: ",")
        
        OnBoardingService.shared.getOnboardingRoutineAPI(routineID: routineID) { networkResult in
            switch networkResult {
            case .success(let data):
                if let data = data as? GenericResponse<RoutineChoiceEntity> {
                    if let listData = data.data {
                        DispatchQueue.main.async {
                            for i in 0...2 {
                                self.routineEntity[i] = listData.themes[i].routines
                            }
                            self.routineFirstCollectionView.reloadData()
                            self.routineSecondCollectionView.reloadData()
                            self.routineThirdCollectionView.reloadData()
                        }
                    }
                }
            case .requestErr, .serverErr:
                break
            default:
                break
            }
        }
    }
    
    func postMemberAPI() {
        OnBoardingService.shared.postOnboardingMemeberAPI(dollType: UserManager.shared.getDollType, dollName: self.userDollName, routineArray: selectedRoutine) { networkResult in
            switch networkResult {
            case .success:
                print("success")
            case .reissue:
                ReissueService.shared.postReissueAPI(refreshToken: UserManager.shared.getRefreshToken) { success in
                    if success {
                        self.postMemberAPI()
                    } else {
                        self.makeSessionExpiredAlert()
                    }
                }
            case .requestErr, .serverErr:
                break
            default:
                break
            }
        }
    }
}

extension RoutineChoiceViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        switch collectionView {
        case themeCollectionView:
            if let previousIndexPath = selectedThemeIndexPath {
                if let previousCell = collectionView.cellForItem(at: previousIndexPath) as? RoutineThemeCollectionViewCell {
                    previousCell.isSelected = false
                    previousCell.backgroundColor = .clear
                    previousCell.routineThemeLabel.textColor = .Gray500
                    previousCell.routineThemeCount.textColor = .Gray500
                }
            }
            
            if let cell = collectionView.cellForItem(at: indexPath) as? RoutineThemeCollectionViewCell {
                cell.isSelected = true
                cell.backgroundColor = .SoftieWhite
                cell.routineThemeLabel.textColor = .Gray700
                cell.routineThemeCount.textColor = .Gray700
            }
            selectedThemeIndexPath = indexPath
            self.setCollectionView(idx: indexPath.item)
            return true
        case routineFirstCollectionView:
            return setSelectedCell(in: collectionView, at: indexPath, routineIndex: 0)
        case routineSecondCollectionView:
            return setSelectedCell(in: collectionView, at: indexPath, routineIndex: 1)
        case routineThirdCollectionView:
            return setSelectedCell(in: collectionView, at: indexPath, routineIndex: 2)
        default:
            return false
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, shouldDeselectItemAt indexPath: IndexPath) -> Bool {
        switch collectionView {
        case themeCollectionView:
            return false
        case routineFirstCollectionView:
            return setDeselectedCell(in: collectionView, at: indexPath, routineIndex: 0)
        case routineSecondCollectionView:
            return setDeselectedCell(in: collectionView, at: indexPath, routineIndex: 1)
        case routineThirdCollectionView:
            return setDeselectedCell(in: collectionView, at: indexPath, routineIndex: 2)
        default:
            return false
        }
    }
}

extension RoutineChoiceViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch collectionView {
        case themeCollectionView:
            let cell = RoutineThemeCollectionViewCell.dequeueReusableCell(collectionView: collectionView, indexPath: indexPath)
            cell.setDataBind(themeID: selectedTheme[indexPath.item])
            if indexPath.item == 0 {
                collectionView.selectItem(at: indexPath, animated: false, scrollPosition: .init())
                cell.backgroundColor = .SoftieWhite
                cell.routineThemeLabel.textColor = .Gray700
            } else {
                cell.backgroundColor = .clear
                cell.routineThemeLabel.textColor = .Gray500
            }
            return cell
        case routineFirstCollectionView:
            let cell = RoutineChoiceCollectionViewCell.dequeueReusableCell(collectionView: collectionView, indexPath: indexPath)
            cell.setDataBind(model: routineEntity[0][indexPath.item])
            return cell
        case routineSecondCollectionView:
            let cell = RoutineChoiceCollectionViewCell.dequeueReusableCell(collectionView: collectionView, indexPath: indexPath)
            cell.setDataBind(model: routineEntity[1][indexPath.item])
            return cell
        case routineThirdCollectionView:
            let cell = RoutineChoiceCollectionViewCell.dequeueReusableCell(collectionView: collectionView, indexPath: indexPath)
            cell.setDataBind(model: routineEntity[2][indexPath.item])
            return cell
        default:
            return UICollectionViewCell()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch collectionView {
        case themeCollectionView:
            return 3
        case routineFirstCollectionView:
            return routineEntity[0].count
        case routineSecondCollectionView:
            return routineEntity[1].count
        case routineThirdCollectionView:
            return routineEntity[2].count
        default:
            return 0
        }
    }
}
