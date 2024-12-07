//
//  CalendarHistoryCell.swift
//  Sopetit-iOS
//
//  Created by 고아라 on 12/5/24.
//

import UIKit

import SnapKit

protocol CalendarHistoryCellDelegate: AnyObject {
    func tapHistoryCell(cellInfo: HistoryHistory)
}

final class CalendarHistoryCell: UICollectionViewCell,
                                 UICollectionViewRegisterable {
    
    // MARK: - Properties
    
    static var isFromNib: Bool = false
    weak var delegate: CalendarHistoryCellDelegate?
    var routineId: Int = 0
    var cellInfo: HistoryHistory = HistoryHistory(historyID: 0, content: "", isMission: false)
    
    // MARK: - UI Components
    
    private let historyTitleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .Gray700
        label.textAlignment = .left
        label.font = .fontGuide(.body2)
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        return label
    }()
    
    private let historyDetailButton: CustomButton = {
        let button = CustomButton()
        button.setImage(UIImage(resource: .icMore), for: .normal)
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setUI()
        setHierarchy()
        setLayout()
        setAddTarget()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

private extension CalendarHistoryCell {
    
    func setUI() {
        backgroundColor = .clear
        layer.cornerRadius = 10
    }
    
    func setHierarchy() {
        addSubviews(historyTitleLabel,
                    historyDetailButton)
    }
    
    func setLayout() {
        historyTitleLabel.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(16)
            $0.trailing.equalTo(historyDetailButton.snp.leading).offset(-23)
            $0.centerY.equalToSuperview()
        }
        
        historyDetailButton.snp.makeConstraints {
            $0.trailing.equalToSuperview().inset(16)
            $0.centerY.equalToSuperview()
            $0.size.equalTo(24)
        }
    }
    
    func setAddTarget() {
        historyDetailButton.addTarget(self, action: #selector(tapHistoryCell), for: .touchUpInside)
    }
    
    @objc
    func tapHistoryCell() {
        delegate?.tapHistoryCell(cellInfo: cellInfo)
    }
}

extension CalendarHistoryCell {
    
    func bindHistoryCell(content: String,
                         isMission: Bool,
                         themeId: Int) {
        historyTitleLabel.text = content.replacingOccurrences(of: "\n", with: " ")
        historyTitleLabel.asLineHeight(.body2)
        if themeId > 8 {
            backgroundColor = UIColor(named: "ThemeBack8")
        } else {
            backgroundColor = isMission ? UIColor(named: "ThemeBack\(themeId)") : .SoftieWhite
        }
    }
}
