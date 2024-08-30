//
//  ActiveRoutineViewController.swift
//  Sopetit-iOS
//
//  Created by Minjoo Kim on 6/13/24.
//

import UIKit

class OngoingViewController: UIViewController {
    
    private var challengeRoutine = ChallengeRoutine(routineId: 0, themeId: 0, themeName: "", title: "", content: "", detailContent: "", place: "", timeTaken: "")
    private var dailyRoutineEntity = NewDailyRoutineEntity(routines: [])
    private var patchRoutineEntity = PatchRoutineEntity(routineId: 0, isAchieve: false, achieveCount: 0, hasCotton: false)
    let ongoingView = OngoingView()
    
    override func loadView() {
        self.view = ongoingView
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getDailyRoutine(status: false)
        getChallengeRoutine()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUI()
        setDelegate()
        setRegister()
        setAddTarget()
    }
}

private extension OngoingViewController {
    
    func setUI() {
        self.navigationController?.navigationBar.isHidden = true
    }
    
    @objc
    func buttonTapped() {
        let nav = AddRoutineViewController()
        nav.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(nav, animated: true)
    }
    
    func setDelegate() {
        ongoingView.dailyCollectionView.delegate = self
        ongoingView.dailyCollectionView.dataSource = self
    }
    
    func setRegister() {
        NewDailyRoutineCollectionViewCell.register(target: ongoingView.dailyCollectionView)
        NewDailyRoutineHeaderView.register(target: ongoingView.dailyCollectionView)
    }
    
    func setData() {
        if challengeRoutine.themeId == 0 {
            ongoingView.setChallengeRoutineEmpty()
        } else {
            ongoingView.setChallengeRoutine(routine: challengeRoutine)
        }
    }
    
    func setAddTarget() {
        ongoingView.routineEmptyView.addRoutineButton.addTarget(self, action: #selector(tapButton), for: .touchUpInside)
        ongoingView.challengeInfoButton.addTarget(self, action: #selector(tapButton), for: .touchUpInside)
        ongoingView.dailyInfoButton.addTarget(self, action: #selector(tapButton), for: .touchUpInside)
        ongoingView.floatingButton.addTarget(self, action: #selector(tapButton), for: .touchUpInside)
    }
    
    @objc func tapButton(_ sender: UIButton) {
        switch sender {
        case ongoingView.routineEmptyView.addRoutineButton:
            // TODO :-
            print("TODO :- addRoutineButton tapped")
            let vc = AddRoutineViewController()
            vc.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(vc, animated: true)
        case ongoingView.challengeInfoButton:
            print("challengeInfoButton tapped")
            challengeInfo()
        case ongoingView.dailyInfoButton:
            popDailyInfo()
        case ongoingView.floatingButton:
            let vc = AddRoutineViewController()
            vc.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(vc, animated: true)
        default:
            break
        }
    }
    
    func popDailyInfo() {
        self.ongoingView.addSubviews(self.ongoingView.dailyInfoView, self.ongoingView.dailyInfoImageView)
        self.ongoingView.dailyInfoView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        self.ongoingView.dailyInfoImageView.snp.makeConstraints {
            $0.top.equalTo(self.ongoingView.dailyInfoButton.snp.top)
            $0.trailing.equalTo(self.ongoingView.dailyInfoButton.snp.trailing)
        }
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(didTapView(_:)))
        
        self.ongoingView.dailyInfoView.addGestureRecognizer(tapGestureRecognizer)
    }
    
    func challengeInfo() {
        let nav = ChallengeBSViewController()
        nav.entity = challengeRoutine
        nav.modalPresentationStyle = .overFullScreen
        self.present(nav, animated: false)
    }
    
    @objc func didTapView(_ sender: UITapGestureRecognizer) {
        closeDailyInfo()
    }

    func closeDailyInfo() {
        self.ongoingView.dailyInfoImageView.removeFromSuperview()
        self.ongoingView.dailyInfoView.removeFromSuperview()
    }
}

extension OngoingViewController: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        if dailyRoutineEntity.routines.isEmpty {
            ongoingView.setEmptyView()
        }
        return dailyRoutineEntity.routines.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dailyRoutineEntity.routines[section].routines.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = NewDailyRoutineCollectionViewCell.dequeueReusableCell(collectionView: collectionView, indexPath: indexPath)
        cell.setDataBind(routine: dailyRoutineEntity.routines[indexPath.section].routines[indexPath.item])
        cell.delegate = self
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: SizeLiterals.Screen.screenWidth - 40, height: 22)
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if kind == UICollectionView.elementKindSectionHeader {
            let headerView = NewDailyRoutineHeaderView.dequeueReusableHeaderView(collectionView: ongoingView.dailyCollectionView, indexPath: indexPath)
            headerView.setDataBind(text: dailyRoutineEntity.routines[indexPath.section].themeName, image: dailyRoutineEntity.routines[indexPath.section].themeId)
            return headerView
        }
        return UICollectionReusableView()
    }
}

extension OngoingViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let label: UILabel = {
            let label = UILabel()
            label.text = dailyRoutineEntity.routines[indexPath.section].routines[indexPath.item].content
            label.font = .fontGuide(.body2)
            return label
        }()
        let height = max(heightForView(text: label.text ?? "", font: label.font, width: SizeLiterals.Screen.screenWidth - 151), 24) + 32
        
        
        return CGSize(width: SizeLiterals.Screen.screenWidth - 40, height: height)
    }
    
    func heightForView(text: String, font: UIFont, width: CGFloat) -> CGFloat {
        let label: UILabel = UILabel(frame: CGRect(x: 0, y: 0, width: width, height: CGFloat.greatestFiniteMagnitude))
        label.numberOfLines = 0
        label.lineBreakMode = NSLineBreakMode.byWordWrapping
        label.font = font
        label.text = text
        label.setTextWithLineHeight(text: label.text, lineHeight: 20)
        label.sizeToFit()
        return label.frame.height
    }
    
    func heightForContentView(numberOfSection: Int, texts: NewDailyRoutineEntity) {
        var height = Double(numberOfSection) * 18.0
        
        for i in texts.routines {
            for j in i.routines {
                let textHeight = heightForView(text: j.content, font: .fontGuide(.body2), width: SizeLiterals.Screen.screenWidth - 151) + 36
                height += textHeight
            }
            height += 18
        }
        height += Double(16 * (texts.routines.count - 1) + 54)
        ongoingView.dailyCollectionView.snp.remakeConstraints {
            $0.height.equalTo(height)
            $0.top.equalTo(ongoingView.dailyTitleLabel.snp.bottom).offset(12)
            $0.horizontalEdges.equalToSuperview()
            $0.bottom.equalToSuperview()
        }
    }
}

extension OngoingViewController {
    func getDailyRoutine(status: Bool) {
        DailyRoutineService.shared.getDailyRoutine { networkResult in
            switch networkResult {
            case .success(let data):
                if let data = data as? GenericResponse<NewDailyRoutineEntity> {
                    if let listData = data.data {
                        self.dailyRoutineEntity = listData
                        self.dailyRoutineEntity.routines.sort(by: {$0.themeId < $1.themeId})
                        if self.dailyRoutineEntity.routines.isEmpty {
                            self.ongoingView.setEmptyView()
                        } else {
                            self.ongoingView.setDailyRoutine()
                            self.heightForContentView(numberOfSection: self.dailyRoutineEntity.routines.count, texts: self.dailyRoutineEntity)
                            self.ongoingView.dailyCollectionView.reloadData()
                        }
                    }
                    if status == true {
                        self.setDeleteToastView()
                    }
                }
            case .requestErr, .serverErr:
                break
            default:
                break
            }
        }
    }
    
    func getChallengeRoutine() {
        DailyRoutineService.shared.getChallengeRoutine { networkResult in
            switch networkResult {
            case .success(let data):
                if let data = data as? GenericResponse<ChallengeRoutine> {
                    if let listData = data.data {
                        self.challengeRoutine = listData
                        self.setData()
                    }
                }
            case .requestErr, .serverErr:
                break
            default:
                break
            }
        }
    }
    
    func patchRoutineAPI(routineId: Int) {
        DailyRoutineService.shared.patchRoutineAPI(routineId: routineId) { networkResult in
            switch networkResult {
            case .success(let data):
                if let data = data as? GenericResponse<PatchRoutineEntity> {
                    if let listData = data.data {
                        self.patchRoutineEntity = listData
                    }
                    if self.patchRoutineEntity.hasCotton == true {
                        self.getCottonView()
                    } else {
                        if self.patchRoutineEntity.isAchieve == false {
                            self.setCancelToastView()
                        } else {
                            self.setNotCottonToastView()
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
}

extension OngoingViewController {
    
    func getCottonView() {
        let vc = GetCottonViewController()
        vc.modalPresentationStyle = UIModalPresentationStyle.overFullScreen
        self.present(vc, animated: false)
    }
    
    func setCancelToastView() {
        self.ongoingView.addSubviews(ongoingView.cancelToastImageView)
        self.ongoingView.bringSubviewToFront(self.ongoingView.cancelToastImageView)
        self.ongoingView.cancelToastImageView.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.bottom.equalTo(self.ongoingView.safeAreaLayoutGuide).inset(24)
        }
        
        UIView.animate(withDuration: 0.5, delay: 1, animations: {self.ongoingView.cancelToastImageView.alpha = 0}, completion: {_ in self.ongoingView.cancelToastImageView.removeFromSuperview()
            self.ongoingView.cancelToastImageView.alpha = 1})
    }
    
    func setNotCottonToastView() {
        self.ongoingView.addSubviews(ongoingView.notCottonToastImageView)
        self.ongoingView.bringSubviewToFront(self.ongoingView.notCottonToastImageView)
        self.ongoingView.notCottonToastImageView.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.bottom.equalTo(self.ongoingView.safeAreaLayoutGuide).inset(24)
        }
        
        UIView.animate(withDuration: 0.5, delay: 1, animations: {self.ongoingView.notCottonToastImageView.alpha = 0}, completion: {_ in self.ongoingView.notCottonToastImageView.removeFromSuperview()
            self.ongoingView.notCottonToastImageView.alpha = 1})
    }
    
    func setDeleteToastView() {
        self.ongoingView.addSubviews(ongoingView.deleteToastImageView)
        self.ongoingView.bringSubviewToFront(self.ongoingView.deleteToastImageView)
        self.ongoingView.deleteToastImageView.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.bottom.equalTo(self.ongoingView.safeAreaLayoutGuide).inset(24)
        }
        
        UIView.animate(withDuration: 0.5, delay: 1, animations: {self.ongoingView.deleteToastImageView.alpha = 0}, completion: {_ in self.ongoingView.deleteToastImageView.removeFromSuperview()
            self.ongoingView.deleteToastImageView.alpha = 1})
    }
    
}

extension OngoingViewController: CVCellDelegate {
    func selectedRadioButton(_ index: Int) {
        patchRoutineAPI(routineId: index)
    }
    
    func tapEllipsisButton(model: DailyRoutinev2) {
        let contentHeight = heightForView(text: model.content, font: .fontGuide(.body1), width: SizeLiterals.Screen.screenWidth - 80)
        let nav = DailyBSViewController()
        nav.delegate = self
        nav.bottomHeight = contentHeight + 220
        nav.height = contentHeight
        nav.entity = model
        nav.modalPresentationStyle = .overFullScreen
        self.present(nav, animated: false)
    }
}

extension OngoingViewController: DeleteDailyProtocol {
    func deleteDailyRoutine() {
        getDailyRoutine(status: true)
    }
}
