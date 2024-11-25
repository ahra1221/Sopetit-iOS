//
//  MakersChipCollectionViewCell.swift
//  Sopetit-iOS
//
//  Created by 고아라 on 8/11/24.
//

import UIKit

import SnapKit

final class MakersChipCollectionViewCell: UICollectionViewCell,
                                        UICollectionViewRegisterable {
    
    // MARK: - Properties

    static let isFromNib: Bool = false
    
    // MARK: - UI Components
    
    private let makersChipLabel: UILabel = {
        let label = UILabel()
        label.textColor = .Gray500
        label.textAlignment = .center
        label.font = .fontGuide(.caption2)
        label.asLineHeight(.caption2)
        return label
    }()
    
    // MARK: - Life Cycles
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    
        setUI()
        setHierarchy()
        setLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Extensions

private extension MakersChipCollectionViewCell {

    func setUI() {
        backgroundColor = .Gray200
        layer.cornerRadius = 4
    }
    
    func setHierarchy() {
        addSubview(makersChipLabel)
    }
    
    func setLayout() {
        makersChipLabel.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
    }
}

extension MakersChipCollectionViewCell {
    
    func setDataBind(model: String) {
        makersChipLabel.text = model
    }
}
