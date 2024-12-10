//
//  UILabel+.swift
//  Sopetit-iOS
//
//  Created by 고아라 on 2023/12/29.
//

import UIKit

extension UILabel {
    
    // 특정 부분만 폰트, 색상 적용
    func partFontChange(targetString: String, font: UIFont, textColor: UIColor) {
        guard let existingText = self.text else {
            return
        }
        let existingAttributes = self.attributedText?.attributes(at: 0, effectiveRange: nil) ?? [:]
        let attributedStr = NSMutableAttributedString(string: existingText, attributes: existingAttributes)
        let range = (existingText as NSString).range(of: targetString)
        attributedStr.addAttribute(NSAttributedString.Key.font, value: font, range: range)
        attributedStr.addAttribute(NSAttributedString.Key.foregroundColor, value: textColor, range: range)
        self.attributedText = attributedStr
    }
    
    func partColorChange(targetString: String, textColor: UIColor) {
        guard let existingText = self.text else {
            return
        }
        let existingAttributes = self.attributedText?.attributes(at: 0, effectiveRange: nil) ?? [:]
        let attributedStr = NSMutableAttributedString(string: existingText, attributes: existingAttributes)
        let range = (existingText as NSString).range(of: targetString)
        attributedStr.addAttribute(NSAttributedString.Key.foregroundColor, value: textColor, range: range)
        self.attributedText = attributedStr
    }
    
    func secondColorChange(targetString: String, textColor: UIColor) {
        guard let existingText = self.text else {
            return
        }
        let firstRange = (existingText as NSString).range(of: targetString)
        let searchRange = NSRange(location: firstRange.location + 1, length: existingText.utf16.count - firstRange.location - 1)
        let secondRange = (existingText as NSString).range(of: targetString, options: .caseInsensitive, range: searchRange)
        let attributedStr = NSMutableAttributedString(string: existingText)
        attributedStr.addAttribute(NSAttributedString.Key.foregroundColor, value: textColor, range: secondRange)
        self.attributedText = attributedStr
    }
    
    func setLineSpacing(lineSpacing: CGFloat) {
        if let text = self.text {
            let attributedStr = NSMutableAttributedString(string: text)
            let style = NSMutableParagraphStyle()
            style.lineSpacing = lineSpacing
            attributedStr.addAttribute(NSAttributedString.Key.paragraphStyle,
                                       value: style,
                                       range: NSMakeRange(0, attributedStr.length))
            self.attributedText = attributedStr
        }
    }
    
    func setTextWithLineHeight(text: String?, lineHeight: CGFloat) {
        if let text = text {
            let style = NSMutableParagraphStyle()
            style.maximumLineHeight = lineHeight
            style.minimumLineHeight = lineHeight
            
            let attributes: [NSAttributedString.Key: Any] = [
                .paragraphStyle: style,
                .baselineOffset: (lineHeight - font.lineHeight)
            ]
            
            let attrString = NSAttributedString(string: text,
                                                attributes: attributes)
            self.attributedText = attrString
        }
    }
    
    func setUnderlinePartFontChange(targetString: String, font: UIFont) {
        let fullText = self.text ?? ""
        let range = (fullText as NSString).range(of: targetString)
        let attributedString = NSMutableAttributedString(string: fullText)
        attributedString.addAttribute(.font, value: font, range: range)
        attributedString.addAttribute(NSAttributedString.Key.underlineStyle, value: NSUnderlineStyle.single.rawValue, range: range)
        self.attributedText = attributedString
    }
    
    func asLineHeight(_ fontStyle: FontLevel) {
        
        let lineHeight = fontStyle.lineHeight
        
        if let text = text {
            let style = NSMutableParagraphStyle()
            style.maximumLineHeight = lineHeight
            style.minimumLineHeight = lineHeight
            
            let attributes: [NSAttributedString.Key: Any] = [
                .paragraphStyle: style,
                .baselineOffset: (lineHeight - font.lineHeight) / 4
            ]
            
            let attrString = NSAttributedString(string: text,
                                                attributes: attributes)
            self.attributedText = attrString
        }
    }
    
    func setLineHeightWithRangeText(text: String, 
                                    fontStyle: FontLevel,
                                    targetStrings: [String], 
                                    textColor: UIColor) {
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = fontStyle.lineHeight / 4
        paragraphStyle.alignment = self.textAlignment
        
        let attributedString = NSMutableAttributedString(string: text)
        attributedString.addAttribute(.paragraphStyle, value: paragraphStyle, range: NSRange(location: 0, length: attributedString.length))
        attributedString.addAttribute(.foregroundColor, value: self.textColor ?? .black, range: NSRange(location: 0, length: attributedString.length))
        
        for targetString in targetStrings {
            let range = (text as NSString).range(of: targetString)
            attributedString.addAttribute(.foregroundColor, value: textColor, range: range)
        }
        
        self.attributedText = attributedString
    }
    
    func calculateLabelWidth(for text: String, with font: UIFont) -> CGFloat {
        let maxSize = CGSize(width: CGFloat.greatestFiniteMagnitude, height: CGFloat.greatestFiniteMagnitude)
        
        let boundingRect = text.boundingRect(
            with: maxSize,
            options: .usesLineFragmentOrigin,
            attributes: [NSAttributedString.Key.font: font],
            context: nil
        )
        
        return boundingRect.width
    }
}
