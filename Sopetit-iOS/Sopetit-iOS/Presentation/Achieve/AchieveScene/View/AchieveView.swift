//
//  AchieveView.swift
//  Sopetit-iOS
//
//  Created by 고아라 on 5/27/24.
//

import UIKit

import SnapKit
import FSCalendar

final class AchieveView: UIView {
    
    // MARK: - UI Components
    
    let achieveMenuView = AchieveMenuView()
    
    let calendarHeaderView = CalendarHeaderView()
    
    let achieveCalendarView: FSCalendar = {
        let calendar = FSCalendar()
        calendar.placeholderType = .none
        calendar.appearance.selectionColor = .clear
        calendar.appearance.todayColor = .none
        calendar.appearance.titleTodayColor = .none
        calendar.appearance.titleSelectionColor = .none
        calendar.appearance.borderSelectionColor = .clear
        calendar.appearance.borderDefaultColor = .clear
        calendar.scope = .month
        calendar.translatesAutoresizingMaskIntoConstraints = false
        calendar.locale = Locale(identifier: "ko_KR")
        calendar.headerHeight = 0
        calendar.weekdayHeight = 32
        calendar.rowHeight = 70
        calendar.scrollEnabled = true
        calendar.appearance.weekdayFont = .fontGuide(.body2)
        calendar.appearance.weekdayTextColor = .Gray400
        return calendar
    }()
    
    // MARK: - Life Cycles
    
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

// MARK: - Extensions

private extension AchieveView {
    
    func setUI() {
        self.backgroundColor = .Gray50
    }
    
    func setHierarchy() {
        addSubviews(achieveMenuView,
                    calendarHeaderView,
                    achieveCalendarView)
    }
    
    func setLayout() {
        achieveMenuView.snp.makeConstraints {
            $0.top.equalTo(safeAreaLayoutGuide)
            $0.leading.trailing.equalToSuperview()
        }
        
        calendarHeaderView.snp.makeConstraints {
            $0.top.equalTo(achieveMenuView.snp.bottom).offset(28)
            $0.centerX.equalToSuperview()
            $0.width.equalTo(SizeLiterals.Screen.screenWidth - 222)
            $0.height.equalTo(24)
        }
        
        achieveCalendarView.snp.makeConstraints {
            $0.top.equalTo(calendarHeaderView.snp.bottom).offset(16)
            $0.centerX.equalToSuperview()
            $0.width.equalTo(SizeLiterals.Screen.screenWidth - 47)
            $0.height.equalTo(400)
        }
    }
}
