//
//  AchieveStatsView.swift
//  Sopetit-iOS
//
//  Created by ahra on 1/8/25.
//

import UIKit

import SnapKit

final class AchieveStatsView: UIView {
    
    // MARK: - UI Components
    
    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.showsVerticalScrollIndicator = false
        return scrollView
    }()
    
    private let contentView = UIView()
    
    // 상단 캐릭터뷰
    
    private let statsImageView: UIImageView = {
        let imageview = UIImageView()
        imageview.image = UIImage(resource: .imgStats1)
        imageview.contentMode = .scaleAspectFit
        return imageview
    }()
    
    private let statsTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "따뜻한 동반자"
        label.textColor = .Gray700
        label.font = .fontGuide(.head2)
        label.asLineHeight(.head2)
        return label
    }()
    
    private let statsSubLabel: UILabel = {
        let label = UILabel()
        label.text = "애착이는 다정다감하고 활기차요"
        label.textColor = .Gray500
        label.font = .fontGuide(.body2)
        label.asLineHeight(.body2)
        return label
    }()
    
    // 차트뷰
    
    private let chartBackView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 10
        view.clipsToBounds = true
        return view
    }()
    
    private let chartTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "성격"
        label.textColor = .black
        label.font = .fontGuide(.head2)
        label.asLineHeight(.head2)
        return label
    }()
    
    private let chartSubLabel: UILabel = {
        let label = UILabel()
        label.text = "애착이와 관계쌓기하며 가장 많은 시간을 보냈어요"
        label.textColor = .Gray500
        label.font = .fontGuide(.body2)
        label.asLineHeight(.body2)
        return label
    }()
    
    lazy var chartView = StatsChartView(entity: AchieveThemeEntity.initalEntity())
    
    // 달성한루틴뷰
    
    private let routineStatsTitle: UILabel = {
        let label = UILabel()
        label.text = "달성한루틴"
        label.textColor = .Gray700
        label.font = .fontGuide(.head2)
        label.asLineHeight(.head2)
        return label
    }()
    
    let themeStatsCollectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        let layout = UICollectionViewFlowLayout()
        layout.minimumInteritemSpacing = 11
        layout.minimumLineSpacing = 8
        collectionView.isScrollEnabled = false
        collectionView.scrollsToTop = false
        collectionView.showsVerticalScrollIndicator = false
        collectionView.collectionViewLayout = layout
        collectionView.backgroundColor = .clear
        layout.itemSize = CGSize(width: (SizeLiterals.Screen.screenWidth - 45) / 2, height: 79)
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

private extension AchieveStatsView {
    
    func setUI() {
        self.backgroundColor = .Gray50
    }
    
    func setHierarchy() {
        addSubview(scrollView)
        scrollView.addSubview(contentView)
        contentView.addSubviews(statsImageView,
                                chartBackView,
                                routineStatsTitle,
                                themeStatsCollectionView)
        statsImageView.addSubviews(statsTitleLabel,
                                   statsSubLabel)
        chartBackView.addSubviews(chartTitleLabel,
                                  chartSubLabel,
                                  chartView)
    }
    
    func setLayout() {
        scrollView.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.horizontalEdges.equalToSuperview()
            $0.bottom.equalTo(self.safeAreaLayoutGuide)
        }
        
        contentView.snp.makeConstraints {
            $0.edges.equalTo(scrollView)
            $0.width.equalTo(scrollView.snp.width)
            $0.height.equalTo(scrollView.snp.height).priority(.low)
        }
        
        statsImageView.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
            $0.height.equalTo(259)
        }
        
        statsTitleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(26)
            $0.centerX.equalToSuperview()
        }
        
        statsSubLabel.snp.makeConstraints {
            $0.top.equalTo(statsTitleLabel.snp.bottom)
            $0.centerX.equalToSuperview()
        }
        
        chartBackView.snp.makeConstraints {
            $0.top.equalTo(statsImageView.snp.bottom).offset(4)
            $0.width.equalTo(SizeLiterals.Screen.screenWidth - 34)
            $0.height.equalTo(253)
            $0.centerX.equalToSuperview()
        }
        
        chartTitleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(12)
            $0.leading.equalToSuperview().inset(11)
        }
        
        chartSubLabel.snp.makeConstraints {
            $0.top.equalTo(chartTitleLabel.snp.bottom).offset(4)
            $0.leading.equalTo(chartTitleLabel.snp.leading)
        }
        
        chartView.snp.makeConstraints {
            $0.top.equalTo(chartSubLabel.snp.bottom).offset(24)
            $0.leading.equalToSuperview().inset(28)
            $0.size.equalTo(142)
        }
        
        routineStatsTitle.snp.makeConstraints {
            $0.top.equalTo(chartBackView.snp.bottom).offset(20)
            $0.leading.equalTo(chartBackView.snp.leading)
        }
        
        themeStatsCollectionView.snp.makeConstraints {
            $0.top.equalTo(routineStatsTitle.snp.bottom).offset(8)
            $0.centerX.equalToSuperview()
            $0.width.equalTo(SizeLiterals.Screen.screenWidth - 34)
            $0.height.equalTo(340)
            $0.bottom.equalToSuperview().inset(31)
        }
    }
    
    func setRegisterCell() {
        StatsRoutineCell.register(target: themeStatsCollectionView)
    }
}
