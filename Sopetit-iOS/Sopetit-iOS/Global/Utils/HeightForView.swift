//
//  HeightForView.swift
//  Sopetit-iOS
//
//  Created by 고아라 on 12/3/24.
//

import UIKit

func heightForView(text: String, font: UIFont, width: CGFloat) -> CGFloat {
    let label: UILabel = UILabel(frame: CGRect(x: 0, y: 0, width: width, height: CGFloat.greatestFiniteMagnitude))
    label.numberOfLines = 0
    label.lineBreakMode = NSLineBreakMode.byWordWrapping
    label.font = font
    label.text = text
    label.setTextWithLineHeight(text: label.text, lineHeight: 20)
    label.sizeToFit()
    return label.frame.height
}
