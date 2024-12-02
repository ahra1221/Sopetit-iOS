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
    
    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.showsVerticalScrollIndicator = false
        return scrollView
    }()
    
    private let contentView = UIView()
    
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
    
    private let divideView: UIView = {
        let view = UIView()
        view.backgroundColor = .Gray200
        return view
    }()
    
    private let selectDateLabel: UILabel = {
        let label = UILabel()
        label.textColor = .Gray700
        label.font = .fontGuide(.head3)
        return label
    }()
    
    private let selectDateCountLabel: UILabel = {
        let label = UILabel()
        label.textColor = .Gray500
        label.font = .fontGuide(.body2)
        return label
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
                    scrollView)
        scrollView.addSubview(contentView)
        contentView.addSubviews(calendarHeaderView,
                                achieveCalendarView,
                                divideView,
                                selectDateLabel,
                                selectDateCountLabel)
    }
    
    func setLayout() {
        achieveMenuView.snp.makeConstraints {
            $0.top.equalTo(safeAreaLayoutGuide)
            $0.leading.trailing.equalToSuperview()
        }
        
        scrollView.snp.makeConstraints {
            $0.top.equalTo(achieveMenuView.snp.bottom)
            $0.horizontalEdges.equalToSuperview()
            $0.bottom.equalTo(self.safeAreaLayoutGuide)
        }
        
        contentView.snp.makeConstraints {
            $0.top.equalTo(scrollView)
            $0.horizontalEdges.bottom.equalToSuperview()
            $0.width.equalTo(scrollView.snp.width)
            $0.height.equalTo(scrollView.snp.height).priority(.low)
        }
        
        calendarHeaderView.snp.makeConstraints {
            $0.top.equalToSuperview().inset(28)
            $0.centerX.equalToSuperview()
            $0.width.equalTo(SizeLiterals.Screen.screenWidth - 40)
            $0.height.equalTo(26)
        }
        
        achieveCalendarView.snp.makeConstraints {
            $0.top.equalTo(calendarHeaderView.snp.bottom).offset(16)
            $0.centerX.equalToSuperview()
            $0.width.equalTo(SizeLiterals.Screen.screenWidth - 47)
            $0.height.equalTo(400)
        }
        
        divideView.snp.makeConstraints {
            $0.top.equalTo(achieveCalendarView.snp.bottom).offset(20)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(2)
        }
        
        selectDateLabel.snp.makeConstraints {
            $0.top.equalTo(divideView.snp.bottom).offset(20)
            $0.leading.equalToSuperview().inset(20)
        }
        
        selectDateCountLabel.snp.makeConstraints {
            $0.centerY.equalTo(selectDateLabel)
            $0.leading.equalTo(selectDateLabel.snp.trailing).offset(4)
        }
    }
}

extension AchieveView {
    
    func bindSelectDate(date: String, week: String) {
        selectDateLabel.text = "\(date)일 (\(week))"
        selectDateLabel.asLineHeight(.head3)
    }
    
    func bindSelectDateCount(cnt: Int) {
        selectDateCountLabel.text = "\(cnt)개"
        selectDateCountLabel.partColorChange(targetString: String(cnt), textColor: .Red200)
        selectDateCountLabel.asLineHeight(.body2)
    }
}
