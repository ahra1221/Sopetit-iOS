//
//  MakersCollectionViewCell.swift
//  Sopetit-iOS
//
//  Created by 고아라 on 8/11/24.
//

import UIKit

import SnapKit

final class MakersCollectionViewCell: UICollectionViewCell, 
                                        UICollectionViewRegisterable {
    
    // MARK: - Properties

    static let isFromNib: Bool = false
    var chipData: [String] = []
    
    // MARK: - UI Components
    
    private let makerProfileImageBackground = UIImageView(image: UIImage(resource: .profileBackground))
    private let makerProfileImage = UIImageView()
    
    private let makerGoButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(resource: .icNext), for: .normal)
        return button
    }()
    
    private let makerDescriptionLabel: UILabel = {
        let label = UILabel()
        label.text = "200만 유튜버와 함께하는"
        label.textColor = .Gray500
        label.font = .fontGuide(.caption1)
        label.asLineHeight(.caption1)
        return label
    }()
    
    private let makerContentLabel: UILabel = {
        let label = UILabel()
        label.text = "유튜버가 되기위한 1일1루틴"
        label.textColor = .Gray700
        label.font = .fontGuide(.head3)
        label.asLineHeight(.head3)
        return label
    }()
    
    lazy var makerChipCollectionView: UICollectionView = {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .horizontal
        flowLayout.minimumInteritemSpacing = 4
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.isUserInteractionEnabled = false
        collectionView.allowsSelection = false
        collectionView.backgroundColor = .clear
        return collectionView
    }()
    
    // MARK: - Life Cycles
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    
        setUI()
        setHierarchy()
        setLayout()
        setDelegate()
        setRegisterCell()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Extensions

private extension MakersCollectionViewCell {

    func setUI() {
        backgroundColor = .white
        layer.cornerRadius = 10
        layer.borderWidth = 1
        layer.borderColor = UIColor.Gray200.cgColor
        makerProfileImage.clipsToBounds = true
        makerProfileImage.layer.cornerRadius = 25
    }
    
    func setHierarchy() {
        addSubviews(makerProfileImageBackground,
                    makerGoButton,
                    makerDescriptionLabel,
                    makerContentLabel,
                    makerChipCollectionView)
        makerProfileImageBackground.addSubview(makerProfileImage)
    }
    
    func setLayout() {
        makerProfileImageBackground.snp.makeConstraints {
            $0.top.equalToSuperview().inset(16)
            $0.leading.equalToSuperview().inset(20)
            $0.size.equalTo(54)
        }
        makerProfileImage.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.size.equalTo(50)
        }
        
        makerGoButton.snp.makeConstraints {
            $0.top.equalTo(makerProfileImage.snp.top)
            $0.trailing.equalToSuperview().inset(12)
            $0.size.equalTo(24)
        }
        
        makerDescriptionLabel.snp.makeConstraints {
            $0.top.equalTo(makerProfileImage.snp.bottom).offset(12)
            $0.leading.equalTo(makerProfileImage.snp.leading)
        }
        
        makerContentLabel.snp.makeConstraints {
            $0.top.equalTo(makerDescriptionLabel.snp.bottom).offset(2)
            $0.leading.equalTo(makerProfileImage.snp.leading)
        }
        
        makerChipCollectionView.snp.makeConstraints {
            $0.bottom.equalToSuperview().inset(16)
            $0.leading.equalToSuperview().inset(20)
            $0.width.equalTo(180)
            $0.height.equalTo(20)
        }
    }
    
    func setDelegate() {
        makerChipCollectionView.delegate = self
        makerChipCollectionView.dataSource = self
    }
    
    func setRegisterCell() {
        MakersChipCollectionViewCell.register(target: makerChipCollectionView)
    }
}

extension MakersCollectionViewCell {
    
    func setDataBind(model: Maker) {
        makerProfileImage.kfSetImage(url: model.profileImageURL)
        makerDescriptionLabel.text = model.comment
        makerContentLabel.text = model.themeName
        chipData = model.tags
    }
}

extension MakersCollectionViewCell: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        let string = chipData[indexPath.item]
        let cellSize = CGSize(width: string.size(withAttributes: [NSAttributedString.Key.font: UIFont.fontGuide(.caption2)]).width + 16, height: 20)
        return cellSize
    }
    
}

extension MakersCollectionViewCell: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        return chipData.count
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = MakersChipCollectionViewCell.dequeueReusableCell(collectionView: collectionView,
                                                                indexPath: indexPath)
        cell.setDataBind(model: chipData[indexPath.item])
        return cell
    }
}
