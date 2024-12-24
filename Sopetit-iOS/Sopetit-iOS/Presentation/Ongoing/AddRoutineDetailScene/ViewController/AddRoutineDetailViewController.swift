//
//  AddRoutineDetailViewController.swift
//  Sopetit-iOS
//
//  Created by 고아라 on 8/12/24.
//

import UIKit

import SnapKit
import FirebaseAnalytics

final class AddRoutineDetailViewController: UIViewController {
    
    private var dailyThemeEntity = DailyThemeEntity(routines: [])
    private var challengeThemeEntity = RoutineChallengeEntity(challenges: [])
    var addRoutineInfoEntity = AddRoutineInfoEntity.addRoutineInfoInitial()
    private var hasChallengeRoutine: Bool = false
    private var challengeMemberEntity = ChallengeMemberEntity.challengeMemberInitial()
    private let changeBSVC = ChangeChallengeBSViewController()
    
    private var selectedChallengeId: Int = -1
    private var selectedChallengeContent: String = ""
    private var selectedDailyId: [Int] = []
    
    // MARK: - UI Components
    
    private lazy var addRoutineDetailView = AddRoutineDetailView(info: addRoutineInfoEntity)
    private lazy var routineDailyCV = addRoutineDetailView.routineDailyCollectionView
    private lazy var challengeCV = addRoutineDetailView.challengeCollectionView
    
    // MARK: - Life Cycles
    
    override func loadView() {
        self.view = addRoutineDetailView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUI()
        setDelegate()
        setAddGesture()
        getChallengeMember()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        let safeAreaInsets = view.safeAreaInsets.top
        addRoutineDetailView.stickyBackView.snp.updateConstraints {
            $0.height.equalTo(safeAreaInsets + 82)
        }
    }
}

// MARK: - Extensions

extension AddRoutineDetailViewController {
    
    func setUI() {
        self.navigationController?.navigationBar.isHidden = true
        
        getDailyThemeAPI(id: addRoutineInfoEntity.id)
    }
    
    func setDelegate() {
        addRoutineDetailView.navigationView.delegate = self
        routineDailyCV.delegate = self
        routineDailyCV.dataSource = self
        challengeCV.delegate = self
        challengeCV.dataSource = self
        changeBSVC.buttonDelegate = self
        addRoutineDetailView.scrollView.delegate = self
    }
    
    func setAddGesture() {
        let tapDailyMenuForSticky = UITapGestureRecognizer(target: self,
                                                           action: #selector(dailyMenuTapped))
        let tapDailyMenuForScroll = UITapGestureRecognizer(target: self,
                                                           action: #selector(dailyMenuTapped))
        let tapChallengeMenuForSticky = UITapGestureRecognizer(target: self,
                                                               action: #selector(challengeMenuTapped))
        let tapChallengeMenuForScroll = UITapGestureRecognizer(target: self,
                                                               action: #selector(challengeMenuTapped))
        addRoutineDetailView.menuStickyView.dailyMenuView.addGestureRecognizer(tapDailyMenuForSticky)
        addRoutineDetailView.menuStickyView.challengeMenuView.addGestureRecognizer(tapChallengeMenuForSticky)
        addRoutineDetailView.menuInScroll.dailyMenuView.addGestureRecognizer(tapDailyMenuForScroll)
        addRoutineDetailView.menuInScroll.challengeMenuView.addGestureRecognizer(tapChallengeMenuForScroll)
        
        addRoutineDetailView.routineAddButton.addTarget(self,
                                                        action: #selector(addButtonTapped),
                                                        for: .touchUpInside)
    }
    
    @objc
    func dailyMenuTapped() {
        addRoutineDetailView.setMenuSelected(dailyTapped: true)
        addRoutineDetailView.menuStickyView.setStickyMenuTapped(dailyTapped: true)
        addRoutineDetailView.menuInScroll.setStickyMenuTapped(dailyTapped: true)
    }
    
    @objc
    func challengeMenuTapped() {
        addRoutineDetailView.setMenuSelected(dailyTapped: false)
        addRoutineDetailView.menuStickyView.setStickyMenuTapped(dailyTapped: false)
        addRoutineDetailView.menuInScroll.setStickyMenuTapped(dailyTapped: false)
        if challengeThemeEntity.challenges.isEmpty {
            getChallengeRoutineAPI(id: addRoutineInfoEntity.id)
        }
    }
    
    @objc
    func addButtonTapped() {
        changeBSVC.entity = ChangeRoutineBottomSheetEntity(existThemeID: challengeMemberEntity.theme.themeID,
                                                           existContent: challengeMemberEntity.content,
                                                           choiceThemeID: addRoutineInfoEntity.id,
                                                           choiceContent: selectedChallengeContent)
        changeBSVC.modalPresentationStyle = .overFullScreen
        
        if selectedChallengeId > -1 { // 도전 루틴 선택
            if hasChallengeRoutine {
                self.present(changeBSVC, animated: false)
            } else {
                self.postAddChallengeAPI(id: self.selectedChallengeId)
                if selectedDailyId.count > 0 { // 데일리루틴 + 도전루틴(새로운)
                    postAddDailyRoutinAPI(ids: selectedDailyId)
                }
            }
        } else { // 데일리루틴만 선택
            postAddDailyRoutinAPI(ids: selectedDailyId)
        }
    }
    
    func setToastMessage(type: ToastType) {
        switch type {
        case .ChallengeCountAlert:
            addRoutineDetailView.challengeCountToast.isHidden = false
            UIView.animate(withDuration: 0.5, delay: 0.7, options: .curveEaseOut, animations: {
                self.addRoutineDetailView.challengeCountToast.alpha = 0.0
            }, completion: {_ in
                self.addRoutineDetailView.challengeCountToast.isHidden = true
                self.addRoutineDetailView.challengeCountToast.alpha = 1.0
            })
        case .ExistRoutineAlert:
            addRoutineDetailView.existRoutineToast.isHidden = false
            UIView.animate(withDuration: 0.5, delay: 0.7, options: .curveEaseOut, animations: {
                self.addRoutineDetailView.existRoutineToast.alpha = 0.0
            }, completion: {_ in
                self.addRoutineDetailView.existRoutineToast.isHidden = true
                self.addRoutineDetailView.existRoutineToast.alpha = 1.0
            })
        }
    }
    
    func updateRoutineAddButton() {
        let totalCount: Int = selectedDailyId.count + (selectedChallengeId > -1 ? 1 : 0)
        addRoutineDetailView.routineAddButton.setTitle("루틴 \(totalCount)개 추가하기",
                                                       for: .normal)
        addRoutineDetailView.routineAddButton.isEnabled = totalCount > 0
    }
}

extension AddRoutineDetailViewController: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        let menuInScrollPosition = addRoutineDetailView.menuInScroll.frame.origin.y
        let navigationHeight = addRoutineDetailView.navigationView.frame.height
        
        let threshold = menuInScrollPosition - navigationHeight - view.safeAreaInsets.top
        let alpha: CGFloat
        if offsetY >= threshold {
            alpha = 1
            addRoutineDetailView.menuStickyView.isHidden = false
            addRoutineDetailView.stickyBackView.isHidden = false
        } else {
            alpha = 0
            addRoutineDetailView.menuStickyView.isHidden = true
            addRoutineDetailView.stickyBackView.isHidden = true
        }
        
        addRoutineDetailView.menuStickyView.alpha = alpha
        addRoutineDetailView.stickyBackView.alpha = alpha
    }
}

extension AddRoutineDetailViewController: BackButtonProtocol {
    
    func tapBackButton() {
        self.navigationController?.popViewController(animated: true)
    }
}

extension AddRoutineDetailViewController: BottomSheetButtonDelegate {
    
    func changeButtonTapped() {
        if selectedDailyId.count > 0 {
            postAddDailyRoutinAPI(ids: selectedDailyId)
        }
        delChallengeAPI(id: challengeMemberEntity.memberChallengeID)
    }
}

// MARK: - Network

extension AddRoutineDetailViewController {
    
    func getDailyThemeAPI(id: Int) {
        AddDailyRoutineService.shared.getDailyRoutine(id: id) { networkResult in
            switch networkResult {
            case .success(let data):
                if let data = data as? GenericResponse<DailyThemeEntity> {
                    if let listData = data.data {
                        self.dailyThemeEntity = listData
                    }
                }
                self.heightForRoutineContentView(texts: self.dailyThemeEntity.routines)
                self.routineDailyCV.reloadData()
            case .reissue:
                ReissueService.shared.postReissueAPI(refreshToken: UserManager.shared.getRefreshToken) { success in
                    if success {
                        self.getDailyThemeAPI(id: self.addRoutineInfoEntity.id)
                    } else {
                        self.makeSessionExpiredAlert()
                    }
                }
            default:
                break
            }
        }
    }
    
    func getChallengeRoutineAPI(id: Int) {
        AddDailyRoutineService.shared.getChallengeRoutine(id: id) { networkResult in
            switch networkResult {
            case .success(let data):
                if let data = data as? GenericResponse<RoutineChallengeEntity> {
                    if let listData = data.data {
                        self.challengeThemeEntity = listData
                    }
                }
                self.heightForChallengeContentView(numberOfSection: self.challengeThemeEntity.challenges.count,
                                                   texts: self.challengeThemeEntity.challenges
                )
                self.challengeCV.reloadData()
            case .reissue:
                ReissueService.shared.postReissueAPI(refreshToken: UserManager.shared.getRefreshToken) { success in
                    if success {
                        self.getChallengeRoutineAPI(id: self.addRoutineInfoEntity.id)
                    } else {
                        self.makeSessionExpiredAlert()
                    }
                }
            default:
                break
            }
        }
    }
    
    func getChallengeMember() {
        AddDailyRoutineService.shared.getChallengeMember { networkResult in
            switch networkResult {
            case .noEntity:
                self.hasChallengeRoutine = false
            case .success(let data):
                self.hasChallengeRoutine = true
                if let data = data as? GenericResponse<ChallengeMemberEntity> {
                    if let listData = data.data {
                        self.challengeMemberEntity = listData
                    }
                }
            case .reissue:
                ReissueService.shared.postReissueAPI(refreshToken: UserManager.shared.getRefreshToken) { success in
                    if success {
                        self.getChallengeMember()
                    } else {
                        self.makeSessionExpiredAlert()
                    }
                }
            default:
                break
            }
        }
    }
    
    func postAddDailyRoutinAPI(ids: [Int]) {
        AddDailyRoutineService.shared.postAddDailyMember(routineId: selectedDailyId) { networkResult in
            switch networkResult {
            case .success:
                self.dismiss(animated: false)
                self.navigationController?.popToRootViewController(animated: true)
            case .reissue:
                ReissueService.shared.postReissueAPI(refreshToken: UserManager.shared.getRefreshToken) { success in
                    if success {
                        self.postAddDailyRoutinAPI(ids: self.selectedDailyId)
                    } else {
                        self.makeSessionExpiredAlert()
                    }
                }
            default:
                break
            }
        }
    }
    
    func postAddChallengeAPI(id: Int) {
        AddDailyRoutineService.shared.postAddChallenge(subRoutineId: id) { networkResult in
            switch networkResult {
            case .success:
                Analytics.logEvent("add_challenge", parameters: nil)
                self.dismiss(animated: false)
                self.navigationController?.popToRootViewController(animated: true)
            case .reissue:
                ReissueService.shared.postReissueAPI(refreshToken: UserManager.shared.getRefreshToken) { success in
                    if success {
                        self.postAddChallengeAPI(id: id)
                    } else {
                        self.makeSessionExpiredAlert()
                    }
                }
            default:
                break
            }
        }
    }
    
    func delChallengeAPI(id: Int) {
        AddDailyRoutineService.shared.delChallenge(routineId: id) { networkResult in
            switch networkResult {
            case .success:
                self.postAddChallengeAPI(id: self.selectedChallengeId)
            case .reissue:
                ReissueService.shared.postReissueAPI(refreshToken: UserManager.shared.getRefreshToken) { success in
                    if success {
                        self.delChallengeAPI(id: id)
                    } else {
                        self.makeSessionExpiredAlert()
                    }
                }
            default:
                break
            }
        }
    }
}

// MARK: - CollectionView

extension AddRoutineDetailViewController: UICollectionViewDelegate {
    
    private func getIndexPathForChallenge(with challengeID: Int) -> IndexPath? {
        for (itemIndex, challenge) in challengeThemeEntity.challenges.enumerated() {
            if challenge.challengeID == challengeID {
                return IndexPath(item: itemIndex, section: 0)
            }
        }
        return nil
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        shouldSelectItemAt indexPath: IndexPath) -> Bool {
        switch collectionView {
        case routineDailyCV:
            let item = dailyThemeEntity.routines[indexPath.item]
            if item.existedInMember { // toastmessage 띄우기
                self.setToastMessage(type: .ExistRoutineAlert)
                return false
            } else {
                selectedDailyId.append(dailyThemeEntity.routines[indexPath.item].id)
                addRoutineDetailView.menuInScroll.setCountDataBind(cnt: selectedDailyId.count,
                                                                   theme: .daily)
                addRoutineDetailView.menuStickyView.setCountDataBind(cnt: selectedDailyId.count,
                                                                     theme: .daily)
                self.updateRoutineAddButton()
                return true
            }
        case challengeCV:
            let item = challengeThemeEntity.challenges[indexPath.item]
            if item.hasRoutine { // 추가한 루틴인 경우 toastmessage
                self.setToastMessage(type: .ExistRoutineAlert)
                return false
            } else {
                if selectedChallengeId > -1 {
                    if let previousIndexPath = getIndexPathForChallenge(with: selectedChallengeId) {
                        collectionView.deselectItem(at: previousIndexPath, animated: true)
                    }
                }
                selectedChallengeId = challengeThemeEntity.challenges[indexPath.item].challengeID
                selectedChallengeContent = challengeThemeEntity.challenges[indexPath.item].content.replacingOccurrences(of: "\n", with: " ")
                addRoutineDetailView.menuInScroll.setCountDataBind(cnt: 1,
                                                                   theme: .challenge)
                addRoutineDetailView.menuStickyView.setCountDataBind(cnt: 1,
                                                                     theme: .challenge)
                self.updateRoutineAddButton()
                return true
            }
        default:
            return false
        }
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        shouldDeselectItemAt indexPath: IndexPath) -> Bool {
        switch collectionView {
        case routineDailyCV:
            if let index = selectedDailyId.firstIndex(where: { num in num == dailyThemeEntity.routines[indexPath.item].id }) {
                selectedDailyId.remove(at: index)
            }
            addRoutineDetailView.menuInScroll.setCountDataBind(cnt: selectedDailyId.count,
                                                               theme: .daily)
            addRoutineDetailView.menuStickyView.setCountDataBind(cnt: selectedDailyId.count,
                                                                 theme: .daily)
            self.updateRoutineAddButton()
            return true
        case challengeCV:
            selectedChallengeId = -1
            selectedChallengeContent = ""
            addRoutineDetailView.menuInScroll.setCountDataBind(cnt: 0,
                                                               theme: .challenge)
            addRoutineDetailView.menuStickyView.setCountDataBind(cnt: 0,
                                                                 theme: .challenge)
            self.updateRoutineAddButton()
            return true
        default:
            return false
        }
    }
}

extension AddRoutineDetailViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch collectionView {
        case routineDailyCV:
            let cell = RoutineChoiceCollectionViewCell.dequeueReusableCell(collectionView: collectionView, indexPath: indexPath)
            let dailyRoutines = dailyThemeEntity.routines[indexPath.item]
            cell.setAddRoutineBind(model: dailyRoutines)
            cell.hasRoutine = dailyRoutines.existedInMember
            return cell
        case challengeCV:
            let routines: Challenge = challengeThemeEntity.challenges[indexPath.item]
            let cell = AddChallengeRoutineCollectionViewCell.dequeueReusableCell(collectionView: collectionView, indexPath: indexPath)
            cell.setRoutineChallengeBind(model: routines)
            cell.hasRoutine = routines.hasRoutine
            cell.buttonAction = { [weak self] in
                let bottomSheetEntity = AddRoutineBottomSheetEntity(content: routines.content,
                                                                    description: routines.description,
                                                                    time: routines.requiredTime,
                                                                    place: routines.place)
                let nav = AddRoutinDetailBSViewController()
                nav.entity = bottomSheetEntity
                nav.modalPresentationStyle = .overFullScreen
                self?.present(nav, animated: false)
            }
            return cell
        default:
            return UICollectionViewCell()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        switch collectionView {
        case routineDailyCV:
            return dailyThemeEntity.routines.count
        case challengeCV:
            return challengeThemeEntity.challenges.count
        default:
            return 0
        }
    }
}

extension AddRoutineDetailViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        switch collectionView {
        case routineDailyCV:
            return CGSize(width: SizeLiterals.Screen.screenWidth - 40,
                          height: 56)
        case challengeCV:
            let label: UILabel = {
                let label = UILabel()
                label.text = challengeThemeEntity.challenges[indexPath.item].content.replacingOccurrences(of: "\n", with: " ")
                label.font = .fontGuide(.body2)
                return label
            }()
            label.sizeThatFits(CGSize(width: SizeLiterals.Screen.screenWidth - 80, height: 20))
            let height = heightForView(text: label.text ?? "",
                                       font: label.font,
                                       width: SizeLiterals.Screen.screenWidth - 80) + 94
            return CGSize(width: SizeLiterals.Screen.screenWidth - 40, height: height)
        default:
            return CGSize()
        }
    }
    
    func heightForView(text: String, font: UIFont, width: CGFloat) -> CGFloat {
        let label: UILabel = UILabel(frame: CGRect(x: 0, y: 0,
                                                   width: width,
                                                   height: CGFloat.greatestFiniteMagnitude))
        label.numberOfLines = 0
        label.lineBreakMode = NSLineBreakMode.byWordWrapping
        label.font = font
        label.text = text
        label.setTextWithLineHeight(text: label.text, lineHeight: 20)
        label.sizeToFit()
        return label.frame.height
    }
    
    func heightForChallengeContentView(numberOfSection: Int,
                                       texts: [Challenge]) {
        var height = Double(numberOfSection) * 18.0
        
        for i in texts {
            let textHeight = heightForView(text: i.content,
                                           font: .fontGuide(.body2),
                                           width: SizeLiterals.Screen.screenWidth - 80) + 94
            height += textHeight
        }
        height += 98
        
        UIView.animate(withDuration: 0.3) {
            self.addRoutineDetailView.challengeCollectionView.snp.makeConstraints {
                $0.top.equalTo(self.addRoutineDetailView.menuInScroll.snp.bottom).offset(20)
                $0.centerX.equalToSuperview()
                $0.bottom.equalToSuperview()
                $0.width.equalTo(SizeLiterals.Screen.screenWidth - 40)
                $0.height.equalTo(height)
            }
            self.challengeCV.layoutIfNeeded()
        }
    }
    
    func heightForRoutineContentView(texts: [Routines]) {
        var height = Double(1) * 18.0
        
        for i in texts {
            let textHeight = heightForView(text: i.content,
                                           font: .fontGuide(.body2),
                                           width: SizeLiterals.Screen.screenWidth - 80) + 40
            height += textHeight
        }
        height += 98
        
        UIView.animate(withDuration: 0.3) {
            self.addRoutineDetailView.routineDailyCollectionView.snp.makeConstraints {
                $0.top.equalTo(self.addRoutineDetailView.menuInScroll.snp.bottom).offset(20)
                $0.centerX.equalToSuperview()
                $0.bottom.equalToSuperview()
                $0.width.equalTo(SizeLiterals.Screen.screenWidth - 40)
                $0.height.equalTo(height)
            }
            self.challengeCV.layoutIfNeeded()
        }
    }
}
