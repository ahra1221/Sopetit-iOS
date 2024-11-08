//
//  AddRoutineMenuStickyView.swift
//  Sopetit-iOS
//
//  Created by 고아라 on 8/30/24.
//

import UIKit

import SnapKit
import FirebaseAnalytics

final class AddRoutineMenuStickyView: UIView {
    
    private var info: AddRoutineTheme = .routine
    
    // MARK: - UI Components
    
    let dailyMenuView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        view.isUserInteractionEnabled = true
        return view
    }()
    
    private let dailyStackView: UIStackView = {
        let stackview = UIStackView()
        stackview.axis = .horizontal
        stackview.spacing = 4
        return stackview
    }()
    
    private let dailyRoutineTitle: UILabel = {
        let label = UILabel()
        label.text = "데일리 루틴"
        label.textColor = .Gray700
        label.font = .fontGuide(.body2)
        label.asLineHeight(.body2)
        return label
    }()
    
    private let dailyRoutineCount: UILabel = {
        let label = UILabel()
        label.text = ""
        label.textColor = .Gray700
        label.font = .fontGuide(.body2)
        label.asLineHeight(.body2)
        return label
    }()
    
    private let dailyUnderLine: UIView = {
        let view = UIView()
        view.backgroundColor = .Gray650
        view.clipsToBounds = true
        view.layer.cornerRadius = 2
        return view
    }()
    
    let challengeMenuView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        view.isUserInteractionEnabled = true
        return view
    }()
    
    private let challengeStackView: UIStackView = {
        let stackview = UIStackView()
        stackview.axis = .horizontal
        stackview.spacing = 4
        return stackview
    }()
    
    private let challengeRoutineTitle: UILabel = {
        let label = UILabel()
        label.text = "도전 루틴"
        label.textColor = .Gray400
        label.font = .fontGuide(.body2)
        label.asLineHeight(.body2)
        return label
    }()
    
    private let challengeRoutineCount: UILabel = {
        let label = UILabel()
        label.text = ""
        label.textColor = .Gray700
        label.font = .fontGuide(.body2)
        label.asLineHeight(.body2)
        return label
    }()
    
    private let challengeUnderLine: UIView = {
        let view = UIView()
        view.backgroundColor = .Gray650
        view.isHidden = true
        view.clipsToBounds = true
        view.layer.cornerRadius = 2
        return view
    }()
    
    let menuUnderlineView: UIView = {
        let view = UIView()
        view.backgroundColor = .Gray200
        return view
    }()
    
    init(info: AddRoutineTheme) {
        self.info = info
        super.init(frame: .zero)
        
        bindUI(info: info)
        setUI()
        setHierarchy()
        setLayout()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension AddRoutineMenuStickyView {
    
    func bindUI(info: AddRoutineTheme) {
        dailyMenuView.isHidden = (info == .maker)
    }
    
    func setUI() {
        backgroundColor = .Gray50
        self.isUserInteractionEnabled = true
    }
    
    func setHierarchy() {
        addSubviews(menuUnderlineView,
                    dailyMenuView,
                    challengeMenuView)
        dailyMenuView.addSubviews(dailyStackView,
                                  dailyUnderLine)
        dailyStackView.addArrangedSubviews(dailyRoutineTitle,
                                           dailyRoutineCount)
        challengeMenuView.addSubviews(challengeStackView,
                                      challengeUnderLine)
        challengeStackView.addArrangedSubviews(challengeRoutineTitle,
                                               challengeRoutineCount)
    }
    
    func setLayout() {
        self.snp.makeConstraints {
            $0.height.equalTo(38)
        }
        
        menuUnderlineView.snp.makeConstraints {
            $0.leading.trailing.bottom.equalToSuperview()
            $0.height.equalTo(2)
        }
        
        dailyMenuView.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(20)
            $0.bottom.equalTo(menuUnderlineView.snp.bottom)
            $0.width.equalTo((SizeLiterals.Screen.screenWidth - 40) / 2)
            $0.height.equalTo(39)
        }
        
        dailyStackView.snp.makeConstraints {
            $0.top.equalToSuperview().inset(6)
            $0.centerX.equalToSuperview()
        }
        
        dailyUnderLine.snp.makeConstraints {
            $0.bottom.equalToSuperview()
            $0.centerX.equalToSuperview()
            $0.width.equalToSuperview()
            $0.height.equalTo(3)
        }
        
        challengeMenuView.snp.makeConstraints {
            switch info {
            case .maker:
                $0.leading.equalToSuperview().inset(27)
            case .routine:
                $0.leading.equalTo(dailyMenuView.snp.trailing)
            }
            $0.bottom.equalTo(menuUnderlineView.snp.bottom)
            $0.width.equalTo((SizeLiterals.Screen.screenWidth - 40) / 2)
            $0.height.equalTo(39)
        }
        
        challengeStackView.snp.makeConstraints {
            $0.top.equalToSuperview().inset(6)
            $0.centerX.equalToSuperview()
        }
        
        challengeUnderLine.snp.makeConstraints {
            $0.bottom.equalToSuperview()
            $0.centerX.equalToSuperview()
            $0.width.equalToSuperview()
            $0.height.equalTo(3)
        }
    }
}

extension AddRoutineMenuStickyView {
    
    func setStickyMenuTapped(dailyTapped: Bool) {
        [dailyRoutineTitle,
         dailyRoutineCount].forEach {
            $0.textColor = dailyTapped ? .Gray700 : .Gray400
        }
        [challengeRoutineTitle,
         challengeRoutineCount].forEach {
            $0.textColor = dailyTapped ? .Gray400 : .Gray700
        }
        dailyUnderLine.isHidden = dailyTapped ? false : true
        challengeUnderLine.isHidden = dailyTapped ? true : false
        if !dailyTapped {
            Analytics.logEvent("click_challenge", parameters: nil)
        }
    }
    
    func setCountDataBind(cnt: Int,
                          theme: RoutineTheme) {
        switch theme {
        case .daily:
            dailyRoutineCount.text = cnt < 1 ? "" : String(cnt)
        case .challenge:
            challengeRoutineCount.text = cnt < 1 ? "" : String(cnt)
        }
    }
}
