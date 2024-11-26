//
//  CalendarHeaderView.swift
//  Sopetit-iOS
//
//  Created by 고아라 on 11/26/24.
//

import UIKit

import SnapKit

final class CalendarHeaderView: UIView  {
    
    // MARK: - UI Components

    private let calendarHeaderStackView: UIStackView = {
        let stackview = UIStackView()
        stackview.spacing = 8
        stackview.axis = .horizontal
        return stackview
    }()
    
    let calendarHeaderLeftButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(resource: .btnCalendarLeft), for: .normal)
        button.setImage(UIImage(resource: .btnCalendarLeftDisabled), for: .disabled)
        return button
    }()
    
    let calendarHeaderRightButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(resource: .btnCalendarRight), for: .normal)
        button.setImage(UIImage(resource: .btnCalendarRightDisable), for: .disabled)
        return button
    }()
    
    private let calendarDayTitle: UILabel = {
        let label = UILabel()
        label.textColor = .Gray700
        label.font = .fontGuide(.head3)
        return label
    }()
    
    // MARK: - Life Cycles
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setHierarchy()
        setLayout()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

private extension CalendarHeaderView {
    
    func setHierarchy() {
        addSubview(calendarHeaderStackView)
        calendarHeaderStackView.addArrangedSubviews(calendarHeaderLeftButton,
                                                    calendarDayTitle,
                                                    calendarHeaderRightButton)
    }
    
    func setLayout() {
        calendarHeaderStackView.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.centerX.equalToSuperview()
            $0.height.equalTo(24)
        }
        
        [calendarHeaderLeftButton, calendarHeaderRightButton].forEach {
            $0.snp.makeConstraints {
                $0.size.equalTo(24)
            }
        }
    }
}

extension CalendarHeaderView {
    
    func configureHeader(year: Int,
                         month: Int) {
        calendarDayTitle.text = "\(year)년 \(month)월"
        calendarDayTitle.asLineHeight(.body2)
    }
}
