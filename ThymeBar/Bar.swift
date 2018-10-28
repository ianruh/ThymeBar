//
//  Draw.swift
//  ThymeBar
//
//  Created by Ian Ruh on 10/25/18.
//  Copyright © 2018 Ian Ruh. All rights reserved.
//

import Foundation
import AppKit

class Bar: NSView {
    
    var backColor: CGColor?
    var fillColor: Color?
    var max = 100
    var value = 30
    var radius = 2
    
    
    init(frame: CGRect, background: CGColor, fill: Color) {
        super.init(frame: frame)
        backColor = background
        fillColor = fill
        self.toolTip = fillColor!.name
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func draw(_ rect: CGRect) {
        drawRoundedRect(rect: rect, inContext: NSGraphicsContext.current?.cgContext, rad: CGFloat(radius), borderColor: backColor!, fillColor: backColor!)
        let fillPercent = Double(value) / Double(max)
        let fillRect = CGRect(x: 0, y: 0, width: Int(fillPercent*Double(rect.size.width)), height: Int(rect.size.height))
        drawRoundedRect(rect: fillRect, inContext: NSGraphicsContext.current?.cgContext, rad: CGFloat(radius), borderColor: fillColor!.color, fillColor: fillColor!.color)
        self.toolTip = fillColor!.name
    }
    
    func drawRoundedRect(rect: CGRect, inContext context: CGContext?,
                         rad: CGFloat, borderColor: CGColor, fillColor: CGColor) {
        // 1
        let path = CGMutablePath()
        
        // 2
        path.move( to: CGPoint(x:  rect.midX, y:rect.minY ))
        path.addArc( tangent1End: CGPoint(x: rect.maxX, y: rect.minY ),
                     tangent2End: CGPoint(x: rect.maxX, y: rect.maxY), radius: rad)
        path.addArc( tangent1End: CGPoint(x: rect.maxX, y: rect.maxY ),
                     tangent2End: CGPoint(x: rect.minX, y: rect.maxY), radius: rad)
        path.addArc( tangent1End: CGPoint(x: rect.minX, y: rect.maxY ),
                     tangent2End: CGPoint(x: rect.minX, y: rect.minY), radius: rad)
        path.addArc( tangent1End: CGPoint(x: rect.minX, y: rect.minY ),
                     tangent2End: CGPoint(x: rect.maxX, y: rect.minY), radius: rad)
        path.closeSubpath()
        
        // 3
        context?.setLineWidth(1.0)
        context?.setFillColor(fillColor)
        context?.setStrokeColor(borderColor)
        
        // 4
        context?.addPath(path)
        context?.drawPath(using: .fillStroke)
    }
    
}

extension CGColor {
    static func random() -> CGColor {
        return CGColor(red:   CGFloat(arc4random_uniform(250)),
                       green: CGFloat(arc4random_uniform(250)),
                       blue:  CGFloat(arc4random_uniform(250)),
                       alpha: 1.0)
    }
}

extension NSColor {
    
    /**
     Creates a NSColor object for the given rgb value which can be specified
     as HTML hex color value. For example:
     
     let color = UIColor(rgb: 0x8046A2)
     let colorWithAlpha = UIColor(rgb: 0x8046A2, alpha: 0.5)
     
     - parameter rgb: color value as Int. To be specified as hex literal like 0xff00ff
     - parameter alpha: alpha optional alpha value (default 1.0)
     */
    convenience init(rgb: Int, alpha: CGFloat = 1.0) {
        let r = CGFloat((rgb & 0xff0000) >> 16) / 255
        let g = CGFloat((rgb & 0x00ff00) >>  8) / 255
        let b = CGFloat((rgb & 0x0000ff)      ) / 255
        
        self.init(red: r, green: g, blue: b, alpha: alpha)
    }
    
}
