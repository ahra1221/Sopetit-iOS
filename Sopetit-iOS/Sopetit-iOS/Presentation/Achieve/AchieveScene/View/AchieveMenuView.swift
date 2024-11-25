//
//  AchieveMenuView.swift
//  Sopetit-iOS
//
//  Created by 고아라 on 11/15/24.
//

import UIKit

import SnapKit

final class AchieveMenuView: UIView {
    
    // MARK: - UI Components
    
    private let achieveTitle: UILabel = {
        let label = UILabel()
        label.text = "달성도"
        label.textColor = .Gray700
        label.font = .fontGuide(.head3)
        label.asLineHeight(.head3)
        label.textAlignment = .left
        return label
    }()
    
    let statsMenuView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        view.isUserInteractionEnabled = true
        return view
    }()
    
    private let statsTitle: UILabel = {
        let label = UILabel()
        label.text = "통계"
        label.textColor = .Gray700
        label.font = .fontGuide(.body2)
        label.asLineHeight(.body2)
        return label
    }()
    
    private let statsUnderLine: UIView = {
        let view = UIView()
        view.backgroundColor = .Gray650
        view.clipsToBounds = true
        view.layer.cornerRadius = 2
        return view
    }()
    
    let calendarMenuView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        view.isUserInteractionEnabled = true
        return view
    }()
    
    private let calendarTitle: UILabel = {
        let label = UILabel()
        label.text = "캘린더"
        label.textColor = .Gray400
        label.font = .fontGuide(.body2)
        label.asLineHeight(.body2)
        return label
    }()
    
    private let calendarUnderLine: UIView = {
        let view = UIView()
        view.backgroundColor = .Gray650
        view.isHidden = true
        view.clipsToBounds = true
        view.layer.cornerRadius = 2
        return view
    }()
    
    private let menuUnderlineView: UIView = {
        let view = UIView()
        view.backgroundColor = .Gray200
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setUI()
        setHierarchy()
        setLayout()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension AchieveMenuView {
    
    func setUI() {
        backgroundColor = .Gray50
        self.isUserInteractionEnabled = true
    }
    
    func setHierarchy() {
        addSubviews(achieveTitle,
                    menuUnderlineView,
                    statsMenuView,
                    calendarMenuView)
        statsMenuView.addSubviews(statsTitle,
                                  statsUnderLine)
        calendarMenuView.addSubviews(calendarTitle,
                                     calendarUnderLine)
    }
    
    func setLayout() {
        self.snp.makeConstraints {
            $0.height.equalTo(95)
        }
        
        achieveTitle.snp.makeConstraints {
            $0.top.equalTo(safeAreaLayoutGuide).offset(16)
            $0.leading.equalToSuperview().inset(20)
        }
        
        menuUnderlineView.snp.makeConstraints {
            $0.leading.trailing.bottom.equalToSuperview()
            $0.height.equalTo(2)
        }
        
        statsMenuView.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(20)
            $0.bottom.equalTo(menuUnderlineView.snp.bottom)
            $0.width.equalTo((SizeLiterals.Screen.screenWidth - 40) / 2)
            $0.height.equalTo(39)
        }
        
        statsTitle.snp.makeConstraints {
            $0.top.equalToSuperview().inset(6)
            $0.centerX.equalToSuperview()
        }
        
        statsUnderLine.snp.makeConstraints {
            $0.bottom.equalToSuperview()
            $0.centerX.equalToSuperview()
            $0.width.equalToSuperview()
            $0.height.equalTo(3)
        }
        
        calendarMenuView.snp.makeConstraints {
            $0.leading.equalTo(statsMenuView.snp.trailing)
            $0.bottom.equalTo(menuUnderlineView.snp.bottom)
            $0.width.equalTo((SizeLiterals.Screen.screenWidth - 40) / 2)
            $0.height.equalTo(39)
        }
        
        calendarTitle.snp.makeConstraints {
            $0.top.equalToSuperview().inset(6)
            $0.centerX.equalToSuperview()
        }
        
        calendarUnderLine.snp.makeConstraints {
            $0.bottom.equalToSuperview()
            $0.centerX.equalToSuperview()
            $0.width.equalToSuperview()
            $0.height.equalTo(3)
        }
    }
}

extension AchieveMenuView {
    
    func setAchieveMenuTapped(statsTapped: Bool) {
        statsTitle.textColor = statsTapped ? .Gray700 : .Gray400
        calendarTitle.textColor = statsTapped ? .Gray400 : .Gray700
        statsUnderLine.isHidden = statsTapped ? false : true
        calendarUnderLine.isHidden = statsTapped ? true : false
    }
}
