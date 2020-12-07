//
//  DivisionView.swift
//  XProject
//
//  Created by Максим Локтев on 15.09.2020.
//  Copyright © 2020 Максим Локтев. All rights reserved.
//

import UIKit

enum DivisionForm {
    case top
    case center
    case bottom
}

internal class DivisionView: UIView {
    
    var divisionForm: DivisionForm
    
    private let lineWidth: CGFloat = 1.0
    private var halfLineWidth: CGFloat {
        lineWidth / 2.0
    }
    
    private let space: CGFloat = 8.0
    private let radius: CGFloat = 6.0
    
    private var centerY: CGFloat {
        frame.height / 2.0
    }
    
    private var centerX: CGFloat {
        frame.width / 2.0
    }
    
    private var circleSize: CGFloat {
        frame.width - lineWidth
    }
    
    private var halfCircleSize: CGFloat {
        frame.width / 2.0
    }
    
    init(form: DivisionForm = .top) {
        self.divisionForm = form
        super.init(frame: .zero)
        
        backgroundColor = .clear
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        guard let context = UIGraphicsGetCurrentContext() else {
            return
        }
        
        context.setLineWidth(lineWidth)
        context.setStrokeColor(UIColor.darkSkyBlue.cgColor)
        
        switch divisionForm {
        case .top:
            setupTopDivisionView(with: context)
        case .center:
            setupCenterDivisionView(with: context)
        case .bottom:
            setupBottomDivisionView(with: context)
        }
    }
    
    private func setupTopDivisionView(with context: CGContext) {
        
        let clipPath = UIBezierPath(
            roundedRect: CGRect(x: halfLineWidth,
                                y: centerY - halfCircleSize - halfLineWidth,
                                width: circleSize,
                                height: circleSize),
            cornerRadius: radius
        ).cgPath
        context.addPath(clipPath)
        
        context.move(to: CGPoint(x: centerX, y: centerY + halfCircleSize + space))
        context.addLine(to: CGPoint(x: centerX, y: frame.maxY))
        
        context.strokePath()
    }
    
    private func setupCenterDivisionView(with context: CGContext) {
        
        let bottomFirsLine: CGFloat = centerY - space - halfCircleSize
        
        context.move(to: CGPoint(x: centerX, y: 0.0))
        context.addLine(to: CGPoint(x: centerX, y: bottomFirsLine))
        
        let clipPath = UIBezierPath(
            roundedRect: CGRect(x: halfLineWidth,
                                y: bottomFirsLine + space,
                                width: circleSize,
                                height: circleSize),
            cornerRadius: radius
        ).cgPath
        context.addPath(clipPath)

        context.move(to: CGPoint(x: centerX, y: centerY + space + halfCircleSize))
        context.addLine(to: CGPoint(x: centerX, y: frame.maxY))
        
        context.strokePath()
    }
    
    private func setupBottomDivisionView(with context: CGContext) {
        
        let bottomLine: CGFloat = centerY - space - halfCircleSize
        
        context.move(to: CGPoint(x: centerX, y: 0.0))
        context.addLine(to: CGPoint(x: centerX, y: bottomLine))
        
        let clipPath = UIBezierPath(
            roundedRect: CGRect(x: halfLineWidth,
                                y: bottomLine + space,
                                width: circleSize,
                                height: circleSize),
            cornerRadius: radius
        ).cgPath
        context.addPath(clipPath)
        
        context.strokePath()
    }
}
