//
//  AddRoutineDetailView.swift
//  Sopetit-iOS
//
//  Created by 고아라 on 8/12/24.
//

import UIKit

import SnapKit

final class AddRoutineDetailView: UIView {
    
    // MARK: - UI Components
    
    let navigationView: CustomNavigationBarView = {
        let navi = CustomNavigationBarView()
        navi.isBackButtonIncluded = true
        navi.backgroundColor = .clear
        return navi
    }()
    
    let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.showsVerticalScrollIndicator = false
        scrollView.contentInsetAdjustmentBehavior = .never
        scrollView.bounces = false
        return scrollView
    }()
    private let contentView = UIView()
    
    private let cardTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "관계 쌓기"
        label.textColor = .white
        label.font = .fontGuide(.head3)
        label.asLineHeight(.head3)
        return label
    }()
    
    private let cardImageView = UIImageView()
    
    private let cardDescriptionLabel: UILabel = {
        let label = UILabel()
        label.text = "예시\n아아"
        label.textAlignment = .left
        label.numberOfLines = 0
        label.textColor = .Gray500
        label.font = .fontGuide(.body2)
        label.asLineHeight(.body2)
        return label
    }()
    
    let stickyBackView: UIView = {
        let view = UIView()
        view.backgroundColor = .Gray50
        return view
    }()
    
    lazy var menuInScroll = AddRoutineMenuStickyView()
    lazy var menuStickyView = AddRoutineMenuStickyView()
    
    lazy var routineDailyCollectionView: UICollectionView = {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .vertical
        flowLayout.minimumLineSpacing = 4
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        collectionView.showsVerticalScrollIndicator = false
        collectionView.allowsSelection = true
        collectionView.isScrollEnabled = false
        collectionView.allowsMultipleSelection = true
        collectionView.backgroundColor = .clear
        collectionView.contentInset = UIEdgeInsets(top: 7, left: 0, bottom: 0, right: 0)
        return collectionView
    }()
    
    lazy var challengeCollectionView: UICollectionView = {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .vertical
        flowLayout.minimumLineSpacing = 4
        flowLayout.headerReferenceSize = CGSize(width: SizeLiterals.Screen.screenWidth - 55,
                                                height: 44)
        flowLayout.sectionInset = UIEdgeInsets(top: 8, left: 0, bottom: 0, right: 0)
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        collectionView.showsVerticalScrollIndicator = false
        collectionView.allowsSelection = true
        collectionView.isScrollEnabled = false
        collectionView.allowsMultipleSelection = true
        collectionView.backgroundColor = .clear
        collectionView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 20, right: 0)
        return collectionView
    }()
    
    private let gradientView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        return view
    }()
    
    private let gradientLayer: CAGradientLayer = {
        let gradient = CAGradientLayer()
        gradient.colors = [UIColor.SoftieWhite.withAlphaComponent(0).cgColor,
                           UIColor.SoftieWhite.withAlphaComponent(1).cgColor]
        gradient.locations = [0.0, 0.46]
        return gradient
    }()
    
    let routineAddButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .Gray650
        button.setTitle("루틴 0개 추가하기", for: .normal)
        button.titleLabel?.font = .fontGuide(.body1)
        button.setBackgroundColor(.Gray650, for: .selected)
        button.setBackgroundColor(.Gray300, for: .disabled)
        button.layer.cornerRadius = 10
        return button
    }()
    
    let challengeCountToast = AddRoutineToastView(type: .ChallengeCountAlert)
    let existRoutineToast = AddRoutineToastView(type: .ExistRoutineAlert)
    
    // MARK: - Life Cycles
    
    init(info: AddRoutineInfoEntity) {
        super.init(frame: .zero)
        
        bindUI(info: info)
        setUI()
        setHierarchy()
        setLayout()
        setRegisterCell()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        setGradient()
        
        stickyBackView.isHidden = true
        menuStickyView.isHidden = true
    }
}

// MARK: - Extensions

private extension AddRoutineDetailView {
    
    func bindUI(info: AddRoutineInfoEntity) {
        cardTitleLabel.text = info.title
        cardDescriptionLabel.text = info.description
        cardDescriptionLabel.asLineHeight(.body2)
        cardImageView.image = UIImage(named: "card_theme\(info.id)") ?? UIImage()
    }
    
    func setUI() {
        self.backgroundColor = .Gray50
        challengeCountToast.isHidden = true
        existRoutineToast.isHidden = true
        routineAddButton.isEnabled = false
    }
    
    func setHierarchy() {
        addSubviews(scrollView,
                    stickyBackView,
                    navigationView,
                    menuStickyView,
                    gradientView,
                    routineAddButton,
                    challengeCountToast,
                    existRoutineToast)
        scrollView.addSubview(contentView)
        contentView.addSubviews(cardImageView,
                                cardDescriptionLabel,
                                menuInScroll,
                                routineDailyCollectionView
        )
        cardImageView.addSubview(cardTitleLabel)
    }
    
    func setLayout() {
        stickyBackView.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(150)
        }
        
        navigationView.snp.makeConstraints {
            $0.top.equalTo(safeAreaLayoutGuide)
            $0.leading.trailing.equalToSuperview()
        }
        
        menuStickyView.snp.makeConstraints {
            $0.top.equalTo(navigationView.snp.bottom)
            $0.leading.trailing.equalToSuperview()
        }
        
        gradientView.snp.makeConstraints {
            $0.bottom.equalToSuperview()
            $0.leading.trailing.equalToSuperview()
            $0.width.equalToSuperview()
            $0.height.equalTo(SizeLiterals.Screen.deviceRatio > 0.5 ? 105 : 130)
        }
        
        routineAddButton.snp.makeConstraints {
            $0.bottom.equalToSuperview().inset(32)
            $0.centerX.equalToSuperview()
            $0.width.equalTo(SizeLiterals.Screen.screenWidth - 40)
            $0.height.equalTo(56)
        }
        
        challengeCountToast.snp.makeConstraints {
            $0.width.equalTo(234)
            $0.height.equalTo(44)
            $0.centerX.equalToSuperview()
            $0.bottom.equalTo(routineAddButton.snp.top).offset(-26)
        }
        
        existRoutineToast.snp.makeConstraints {
            $0.width.equalTo(196)
            $0.height.equalTo(44)
            $0.centerX.equalToSuperview()
            $0.bottom.equalTo(routineAddButton.snp.top).offset(-26)
        }
        
        scrollView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        contentView.snp.makeConstraints {
            $0.edges.equalTo(scrollView)
            $0.width.equalTo(scrollView.snp.width)
            $0.height.equalTo(scrollView.snp.height).priority(.low)
        }
        
        cardImageView.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.leading.trailing.equalToSuperview()
            $0.width.equalTo(SizeLiterals.Screen.screenWidth)
            $0.height.equalTo(SizeLiterals.Screen.deviceRatio > 0.5 ? 229 : SizeLiterals.Screen.screenHeight * 256 / 812)
        }
        
        cardTitleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(SizeLiterals.Screen.screenHeight * 100 / 812)
            $0.centerX.equalToSuperview()
        }
        
        cardDescriptionLabel.snp.makeConstraints {
            $0.top.equalTo(cardImageView.snp.bottom).offset(16)
            $0.leading.trailing.equalToSuperview().inset(20)
        }
        
        menuInScroll.snp.makeConstraints {
            $0.top.equalTo(cardDescriptionLabel.snp.bottom).offset(16)
            $0.leading.trailing.equalToSuperview()
        }
        
        routineDailyCollectionView.snp.makeConstraints {
            $0.top.equalTo(menuInScroll.snp.bottom).offset(20)
            $0.centerX.equalToSuperview()
            $0.bottom.equalToSuperview()
            $0.width.equalTo(SizeLiterals.Screen.screenWidth - 40)
        }
    }
    
    func setRegisterCell() {
        RoutineChoiceCollectionViewCell.register(target: routineDailyCollectionView)
        AddChallengeRoutineCollectionViewCell.register(target: challengeCollectionView)
        AddChallengeRoutineHeaderView.register(target: challengeCollectionView)
    }
    
    func setGradient() {
        gradientLayer.frame = gradientView.bounds
        gradientView.layer.addSublayer(gradientLayer)
    }
}

extension AddRoutineDetailView {
    
    func setMenuSelected(dailyTapped: Bool) {
        if dailyTapped {
            challengeCollectionView.removeFromSuperview()
            contentView.addSubview(routineDailyCollectionView)
            routineDailyCollectionView.snp.makeConstraints {
                $0.top.equalTo(menuInScroll.snp.bottom).offset(20)
                $0.centerX.equalToSuperview()
                $0.bottom.equalToSuperview()
                $0.width.equalTo(SizeLiterals.Screen.screenWidth - 40)
            }
        } else {
            routineDailyCollectionView.removeFromSuperview()
            contentView.addSubview(challengeCollectionView)
            challengeCollectionView.snp.makeConstraints {
                $0.top.equalTo(menuInScroll.snp.bottom)
                $0.centerX.equalToSuperview()
                $0.bottom.equalToSuperview()
                $0.width.equalTo(SizeLiterals.Screen.screenWidth - 40)
            }
        }
    }
}
