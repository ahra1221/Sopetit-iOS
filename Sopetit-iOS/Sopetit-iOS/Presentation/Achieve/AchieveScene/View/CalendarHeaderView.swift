//
//  CalendarHeaderView.swift
//  Sopetit-iOS
//
//  Created by 고아라 on 11/26/24.
//

import UIKit

import SnapKit

protocol CalendarHeaderDelegate: AnyObject {
    func tapLeftButton()
    func tapRightButton()
    func tapTodayButton()
}

final class CalendarHeaderView: UIView {
    
    // MARK: - Properties
    
    weak var delegate: CalendarHeaderDelegate?
    
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
    
    let goTodayButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(resource: .btnGoToday), for: .normal)
        button.isHidden = true
        return button
    }()
    
    // MARK: - Life Cycles
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setHierarchy()
        setLayout()
        setAddTarget()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

private extension CalendarHeaderView {
    
    func setHierarchy() {
        addSubviews(calendarHeaderStackView,
                    goTodayButton)
        calendarHeaderStackView.addArrangedSubviews(calendarHeaderLeftButton,
                                                    calendarDayTitle,
                                                    calendarHeaderRightButton)
    }
    
    func setLayout() {
        calendarHeaderStackView.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.height.equalTo(24)
        }
        
        [calendarHeaderLeftButton, calendarHeaderRightButton].forEach {
            $0.snp.makeConstraints {
                $0.size.equalTo(24)
            }
        }
        
        goTodayButton.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.trailing.equalToSuperview()
            $0.height.equalTo(26)
            $0.width.equalTo(48)
        }
    }
    
    func setAddTarget() {
        calendarHeaderLeftButton.addTarget(self,
                                           action: #selector(tapLeftButton),
                                           for: .touchUpInside)
        calendarHeaderRightButton.addTarget(self,
                                           action: #selector(tapRightButton),
                                            for: .touchUpInside)
        goTodayButton.addTarget(self,
                                action: #selector(tapTodayButton),
                                for: .touchUpInside)
    }
    
    @objc
    func tapLeftButton() {
        delegate?.tapLeftButton()
    }
    
    @objc
    func tapRightButton() {
        delegate?.tapRightButton()
    }
    
    @objc
    func tapTodayButton() {
        delegate?.tapTodayButton()
    }
}

extension CalendarHeaderView {
    
    func configureHeader(year: Int,
                         month: Int) {
        calendarDayTitle.text = "\(year)년 \(month)월"
        calendarDayTitle.asLineHeight(.body2)
    }
    
    func setHeaderLeftButton(state: Bool) {
        calendarHeaderLeftButton.isEnabled = state
    }
    
    func setHeaderRightButton(state: Bool) {
        calendarHeaderRightButton.isEnabled = state
    }
}
