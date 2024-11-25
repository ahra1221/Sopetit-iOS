//
//  CalendarDateCell.swift
//  Sopetit-iOS
//
//  Created by 고아라 on 11/15/24.
//

import UIKit

import FSCalendar
import SnapKit

enum CalendarIconType {
    case normal
    case achieveRoutine
    case hasRecord
    
    var calendarIconImage: UIImage {
        switch self {
        case .normal:
            return UIImage(resource: .icDateNormal)
        case .achieveRoutine:
            return UIImage(resource: .icDateAchieveRoutine)
        case .hasRecord:
            return UIImage(resource: .icDateHasRecord)
        }
    }
}

enum CalendarDateType {
    case today
    case selected
    case nonSelected
    
    var calendarDateBackColor: UIColor {
        switch self {
        case .today:
            return UIColor.Gray400
        case .selected:
            return UIColor.Gray650
        case .nonSelected:
            return UIColor.clear
        }
    }
    
    var calendarDateTextColor: UIColor {
        switch self {
        case .nonSelected:
            return UIColor.Gray500
        default:
            return UIColor.SoftieWhite
        }
    }
}

final class CalendarDateCell: FSCalendarCell {
    
    // MARK: - UI Components
    
    private var cottonImageView: UIImageView = {
        let imageview = UIImageView()
        imageview.image = UIImage(resource: .icDateNormal)
        imageview.contentMode = .scaleAspectFit
        return imageview
    }()
    
    var calendarDateLabel: UILabel = {
        var label = UILabel()
        label.textColor = .Gray700
        label.textAlignment = .center
        label.font = .fontGuide(.caption1)
        label.asLineHeight(.caption1)
        return label
    }()
    
    let backgroundSelectView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
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

private extension CalendarDateCell {
    
    func setUI() {
        backgroundColor = .clear
    }
    
    func setHierarchy() {
        addSubviews(cottonImageView,
                    backgroundSelectView)
        backgroundSelectView.addSubview(calendarDateLabel)
    }
    
    func setLayout() {
        cottonImageView.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.centerX.equalToSuperview()
            $0.size.equalTo(40)
        }
        
        backgroundSelectView.snp.makeConstraints {
            $0.bottom.equalToSuperview()
            $0.leading.trailing.equalToSuperview().inset(5)
            $0.height.equalTo(18)
        }
        
        calendarDateLabel.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
    }
}

extension CalendarDateCell {
    
    func configureCalendar(iconType: CalendarIconType, 
                           dateType: CalendarDateType,
                           date: String) {
        calendarDateLabel.text = date
        calendarDateLabel.asLineHeight(.caption1)
    }
}
