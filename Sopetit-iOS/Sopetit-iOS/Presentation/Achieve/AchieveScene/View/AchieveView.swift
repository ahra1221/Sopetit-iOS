//
//  AchieveView.swift
//  Sopetit-iOS
//
//  Created by 고아라 on 5/27/24.
//

import UIKit

import SnapKit

final class AchieveView: UIView {
    
    // MARK: - UI Components
    
    let achieveMenuView = AchieveMenuView()
    
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
        addSubviews(achieveMenuView)
    }
    
    func setLayout() {
        achieveMenuView.snp.makeConstraints {
            $0.top.equalTo(safeAreaLayoutGuide)
            $0.leading.trailing.equalToSuperview()
        }
    }
}
