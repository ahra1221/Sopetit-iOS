//
//  AddRoutineToastView.swift
//  Sopetit-iOS
//
//  Created by 고아라 on 8/16/24.
//

import UIKit

import SnapKit

enum ToastType {
    case ChallengeCountAlert
    case ExistRoutineAlert
}

final class AddRoutineToastView: UIView {
    
    private var type: ToastType?
    
    private let toastIcon = UIImageView(image: UIImage(resource: .icWarning))
    
    private let toastTitle: UILabel = {
        let label = UILabel()
        label.textColor = .SoftieWhite
        label.font = .fontGuide(.body2)
        label.textAlignment = .center
        return label
    }()
    
    init(type: ToastType) {
        super.init(frame: .zero)
        
        self.type = type
        
        setUI()
        setHierarchy()
        setLayout()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension AddRoutineToastView {
    
    func setUI() {
        self.backgroundColor = .Gray400
        self.layer.cornerRadius = 22
        
        switch type {
        case .ChallengeCountAlert:
            toastTitle.text = "챌린지는 1개만 선택 가능해요"
        case .ExistRoutineAlert:
            toastTitle.text = "이미 진행중인 루틴이에요"
        default: 
            break
        }
    }
    
    func setHierarchy() {
        addSubviews(toastIcon,
                    toastTitle)
    }
    
    func setLayout() {
        toastIcon.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalToSuperview().inset(16)
            $0.size.equalTo(18)
        }
        
        toastTitle.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.trailing.equalToSuperview().inset(16)
        }
    }
}
