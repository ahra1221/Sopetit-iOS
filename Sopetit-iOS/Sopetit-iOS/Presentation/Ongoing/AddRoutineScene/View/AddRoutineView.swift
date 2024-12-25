//
//  AddRoutineView.swift
//  Sopetit-iOS
//
//  Created by 고아라 on 5/27/24.
//

import UIKit

import SnapKit

final class AddRoutineView: UIView {
    
    // MARK: - UI Components
    
    let navigationView: CustomNavigationBarView = {
        let navi = CustomNavigationBarView()
        navi.isBackButtonIncluded = true
        navi.isTitleViewIncluded = true
        navi.isTitleLabelIncluded = "루틴 추가"
        return navi
    }()
    
    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.showsVerticalScrollIndicator = false
        return scrollView
    }()
    private let contentView = UIView()
    
    private let totalRoutineTitle: UILabel = {
        let label = UILabel()
        label.text = "전체 루틴 테마"
        label.textColor = .Gray700
        label.font = .fontGuide(.head3)
        label.asLineHeight(.head3)
        return label
    }()
    
    lazy var totalRoutineCollectionView: UICollectionView = {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .vertical
        flowLayout.minimumInteritemSpacing = 4
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        collectionView.showsVerticalScrollIndicator = false
        collectionView.clipsToBounds = true
        collectionView.contentInsetAdjustmentBehavior = .never
        collectionView.isUserInteractionEnabled = true
        collectionView.allowsSelection = true
        collectionView.backgroundColor = .clear
        collectionView.isScrollEnabled = false
        return collectionView
    }()
    
    // MARK: - Life Cycles
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setUI()
        setHierarchy()
        setLayout()
        setRegisterCell()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Extensions

private extension AddRoutineView {
    
    func setUI() {
        self.backgroundColor = .Gray50
    }
    
    func setHierarchy() {
        addSubviews(navigationView,
                    scrollView)
        scrollView.addSubview(contentView)
        contentView.addSubviews(totalRoutineTitle,
                                totalRoutineCollectionView)
    }
    
    func setLayout() {
        navigationView.snp.makeConstraints {
            $0.top.equalTo(safeAreaLayoutGuide)
            $0.leading.trailing.equalToSuperview()
        }
        
        scrollView.snp.makeConstraints {
            $0.top.equalTo(navigationView.snp.bottom)
            $0.leading.trailing.bottom.equalToSuperview()
        }
        
        contentView.snp.makeConstraints {
            $0.edges.equalTo(scrollView)
            $0.width.equalTo(scrollView.snp.width)
            $0.height.equalTo(scrollView.snp.height).priority(.low)
        }
        
        totalRoutineTitle.snp.makeConstraints {
            $0.top.equalToSuperview().inset(12)
            $0.leading.equalToSuperview().inset(20)
        }
        
        totalRoutineCollectionView.snp.makeConstraints {
            $0.top.equalTo(totalRoutineTitle.snp.bottom).offset(8)
            $0.leading.trailing.bottom.equalToSuperview()
            $0.width.equalToSuperview()
            $0.height.equalTo(630)
        }
    }
    
    func setRegisterCell() {
        TotalRoutineCollectionViewCell.register(target: totalRoutineCollectionView)
    }
}
