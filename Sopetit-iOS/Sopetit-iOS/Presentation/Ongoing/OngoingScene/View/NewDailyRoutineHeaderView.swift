//
//  NewDailyRoutineHeaderView.swift
//  Sopetit-iOS
//
//  Created by Minjoo Kim on 6/13/24.
//

import UIKit

import SnapKit

final class NewDailyRoutineHeaderView: UICollectionReusableView, UICollectionHeaderViewRegisterable {
    
    // MARK: - Properties
    
    static var isFromNib = false
    
    // MARK: - UI Components
    
    private let themeImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = ImageLiterals.ActiveRoutine.theme
        return imageView
    }()
    
    private let themeLabel: UILabel = {
        let label = UILabel()
        label.font = .fontGuide(.body2)
        label.asLineHeight(.body2)
        label.textColor = .Gray500
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

private extension NewDailyRoutineHeaderView {
    
    func setUI() {
    }
    
    func setHierarchy() {
        
        self.addSubviews(themeImageView, themeLabel)
    }
    
    func setLayout() {
        
        themeImageView.snp.makeConstraints {
            $0.top.equalToSuperview().inset(1)
            $0.leading.equalToSuperview().inset(20)
            $0.size.equalTo(16)
        }
        
        themeLabel.snp.makeConstraints {
            $0.leading.equalTo(themeImageView.snp.trailing).offset(2)
            $0.centerY.equalTo(themeImageView.snp.centerY)
        }
    }
}

extension NewDailyRoutineHeaderView {
    
    func setDataBind(text: String, image: Int) {
        themeLabel.text = text
        themeLabel.asLineHeight(.body2)
        themeImageView.image = UIImage(named: "theme\(image)")
    }
}
