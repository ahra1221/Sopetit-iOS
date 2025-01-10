//
//  StatsChartView.swift
//  Sopetit-iOS
//
//  Created by ahra on 1/10/25.
//


import UIKit

final class StatsChartView: UIView {
    
     var achieveTheme: AchieveThemeEntity = AchieveThemeEntity.initalEntity(){
        didSet {
            print("😬😬😬😬")
            print(achieveTheme)
            self.setNeedsDisplay()
        }
    }
    
    init(entity: AchieveThemeEntity) {
        self.achieveTheme = entity
        super.init(frame: .zero)
        self.backgroundColor = .clear
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func draw(_ rect: CGRect) {
        
        let center = CGPoint(x: rect.midX, y: rect.midY)
        
        var colors: [UIColor] = []
        var values: [CGFloat] = []
        
        for theme in achieveTheme.themes {
            values.append(CGFloat(theme.achievedCount))
            colors.append(UIColor(named: "ThemeChart\(theme.id)") ?? UIColor())
        }
        
        let total = CGFloat(achieveTheme.achievedCount)
        
        //x degree = x * π / 180 radian
        var startAngle: CGFloat = (-(.pi) / 2)
        var endAngle: CGFloat = 0.0
        
        values.enumerated().forEach { (index, value) in
            endAngle = (value / total) * (.pi * 2)
            
            let path = UIBezierPath()
            path.move(to: center)
            path.addArc(withCenter: center,
                        radius: 71,
                        startAngle: startAngle,
                        endAngle: startAngle + endAngle,
                        clockwise: true)
            
            colors[index].setFill()
            path.fill()
            startAngle += endAngle
            path.close()
            
            // slice space
            UIColor.white.set()
        }
        
        let semiCircle = UIBezierPath(arcCenter: center,
                                      radius: 36,
                                      startAngle: 0,
                                      endAngle: (360 * .pi) / 180,
                                      clockwise: true)
        UIColor.white.set()
        semiCircle.fill()
    }
}
