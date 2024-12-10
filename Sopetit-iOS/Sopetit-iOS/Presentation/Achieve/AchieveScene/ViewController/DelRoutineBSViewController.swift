//
//  DelRoutineBSViewController.swift
//  Sopetit-iOS
//
//  Created by 고아라 on 12/6/24.
//

import UIKit

import SnapKit

final class DelRoutineBSViewController: UIViewController {
    
    // MARK: - Properties
    
    private var bottomHeight: CGFloat = SizeLiterals.Screen.screenHeight * 280 / 812
    private var routineContent: String?
    private var routineId: Int?
    private var isChallenge: Bool?
    
    // MARK: - UI Components
    
    private let backgroundView: UIView = {
        let view = UIView()
        view.backgroundColor = .Gray950
        view.isUserInteractionEnabled = true
        return view
    }()
    
    private let bottomSheet: UIView = {
        let view = UIView()
        view.backgroundColor = .SoftieWhite
        view.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        view.layer.cornerRadius = 20
        view.clipsToBounds = false
        return view
    }()
    
    private let routineContentLabel: UILabel = {
        let label = UILabel()
        label.font = .fontGuide(.body2)
        label.textColor = .Gray700
        label.numberOfLines = 0
        label.textAlignment = .center
        return label
    }()
    
    private let routineBackgroundView: UIView = {
        let view = UIView()
        view.backgroundColor = .Gray200
        view.clipsToBounds = true
        view.layer.cornerRadius = 10
        view.layer.borderColor = UIColor.Gray300.cgColor
        view.layer.borderWidth = 1
        return view
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = isChallenge ?? false ? "도전 루틴" : "데일리 루틴"
        label.font = .fontGuide(.head4)
        label.textColor = .Gray700
        return label
    }()
    
    private let delButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(resource: .btnRoutineDel), for: .normal)
        return button
    }()
    
    // MARK: - Life Cycles
    
    init(isChallenge: Bool, id: Int, content: String) {
        self.isChallenge = isChallenge
        self.routineId = id
        self.routineContent = content
        super.init(nibName: nil, bundle: nil)
        self.bindUI(content: content)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUI()
        setHierarchy()
        setLayout()
        setDismissAction()
        setAddTarget()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        showBottomSheet()
    }
}

extension DelRoutineBSViewController {
    
    func bindUI(content: String) {
        routineContentLabel.text = content.replacingOccurrences(of: "\n", with: " ")
        routineContentLabel.asLineHeight(.body2)
        routineContentLabel.textAlignment = .center
        let backViewHeight = heightForView(text: content, font: .fontGuide(.body2), width: SizeLiterals.Screen.screenWidth - 40) + 40.0
        bottomHeight = backViewHeight + 180
    }
    
    func setUI() {
        view.backgroundColor = .clear
    }
    
    func setHierarchy() {
        bottomSheet.addSubviews(titleLabel,
                                routineBackgroundView,
                                delButton)
        view.addSubviews(backgroundView,
                         bottomSheet)
        routineBackgroundView.addSubview(routineContentLabel)
    }
    
    func setLayout() {
        backgroundView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        bottomSheet.snp.makeConstraints {
            $0.leading.trailing.bottom.equalToSuperview()
        }
        
        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(24)
            $0.centerX.equalToSuperview()
        }
        
        routineBackgroundView.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(16)
            $0.leading.trailing.equalToSuperview().inset(20)
        }
        
        routineContentLabel.snp.makeConstraints {
            $0.top.bottom.equalToSuperview().inset(20)
            $0.leading.trailing.equalToSuperview().inset(27)
        }
        
        delButton.snp.makeConstraints {
            if SizeLiterals.Screen.deviceRatio > 0.5 {
                $0.top.equalTo(routineBackgroundView.snp.bottom).offset(16)
            } else {
                $0.top.equalTo(routineBackgroundView.snp.bottom).offset(SizeLiterals.Screen.screenHeight * 32 / 812)
            }
            $0.centerX.equalToSuperview()
            $0.width.equalTo(SizeLiterals.Screen.screenWidth - 40)
            $0.height.equalTo(SizeLiterals.Screen.screenHeight * 56 / 812)
        }
    }
    
    func showBottomSheet() {
        DispatchQueue.main.async {
            self.bottomSheet.snp.remakeConstraints {
                $0.leading.trailing.bottom.equalToSuperview()
                $0.top.equalToSuperview().inset(SizeLiterals.Screen.screenHeight - self.bottomHeight)
            }
            UIView.animate(withDuration: 0.25, delay: 0, options: .curveEaseInOut, animations: {
                self.backgroundView.backgroundColor = .Gray1000
                self.view.layoutIfNeeded()
            })
        }
    }
    
    func hideBottomSheet() {
        DispatchQueue.main.async {
            self.bottomSheet.snp.remakeConstraints {
                $0.leading.trailing.bottom.equalToSuperview()
            }
            UIView.animate(withDuration: 0.25, delay: 0, options: .curveEaseInOut, animations: {
                self.backgroundView.backgroundColor = .clear
                self.view.layoutIfNeeded()
            }, completion: { _ in
                if self.presentingViewController != nil {
                    self.dismiss(animated: true, completion: nil)
                }
            })
        }
    }
    
    func setDismissAction() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(hideBottomSheetAction))
        backgroundView.addGestureRecognizer(tapGesture)
        
        let swipeGesture = UISwipeGestureRecognizer(target: self, action: #selector(hideBottomSheetAction))
        swipeGesture.direction = .down
        view.addGestureRecognizer(swipeGesture)
    }
    
    @objc
    func hideBottomSheetAction() {
        hideBottomSheet()
    }
    
    func setAddTarget() {
        delButton.addTarget(self,
                            action: #selector(tapDelButton),
                            for: .touchUpInside)
    }
    
    @objc
    func tapDelButton() {
        guard let isChallenge = isChallenge else { return }
        if isChallenge {
            delChallengeHistoryAPI()
        } else {
            delDailyHistoryAPI()
        }
    }
}

// MARK: - Networks

extension DelRoutineBSViewController {
    
    func delDailyHistoryAPI() {
        AchieveService.shared.delDailyHistory(routineId: routineId ?? 0) { networkResult in
            switch networkResult {
            case .success(let data):
                dump(data)
                NotificationCenter.default.post(name: Notification.Name("delDailyHistory"), object: nil)
                self.hideBottomSheet()
            case .reissue:
                ReissueService.shared.postReissueAPI(refreshToken: UserManager.shared.getRefreshToken) { success in
                    if success {
                        self.delDailyHistoryAPI()
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
    
    func delChallengeHistoryAPI() {
        AchieveService.shared.delChallengeHistory(routineId: routineId ?? 0) { networkResult in
            switch networkResult {
            case .success(let data):
                dump(data)
                NotificationCenter.default.post(name: Notification.Name("delChallengeHistory"), object: nil)
                self.hideBottomSheet()
            case .reissue:
                ReissueService.shared.postReissueAPI(refreshToken: UserManager.shared.getRefreshToken) { success in
                    if success {
                        self.delChallengeHistoryAPI()
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


