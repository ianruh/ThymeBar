//
//  DayItemView.swift
//  ThymeBar
//
//  Created by Ian Ruh on 1/7/19.
//  Copyright © 2019 Ian Ruh. All rights reserved.
//

import Foundation
import AppKit
import Cocoa
import CoreImage

class DayItemView: NSView {
    
    var text: NSTextField!
    var time: NSTextField!
    var bar: Bar!
    
    init(frame: CGRect, color: Color) {
        super.init(frame: frame)
        
        let textFrame = CGRect(x: 0, y: 125, width: 40, height: 20)
        let timeFrame = CGRect(x: 0, y: 0, width: 40, height: 20)
        
        text = NSTextField(frame: textFrame)
        text.isBezeled = false
        text.drawsBackground = false
        text.isEditable = false
        text.isSelectable = false
        text.font = NSFont.systemFont(ofSize: NSFont.systemFontSize)
        text.alignment = NSTextAlignment.center
        
        let barFrame = CGRect(x: 12, y: 25, width: 15, height: 95)
        bar = Bar(frame: barFrame, background: NSColor.lightGray.cgColor, fill: color)
        bar.radius = 3
        bar.orient = Bar.Orientation.bottomUp
        
        time = NSTextField(frame: timeFrame)
        time.isBezeled = false
        time.drawsBackground = false
        time.isEditable = false
        time.isSelectable = false
        time.font = NSFont.systemFont(ofSize: NSFont.systemFontSize)
        time.alignment = NSTextAlignment.center
        
        self.addSubview(text)
        self.addSubview(time)
        self.addSubview(bar)
    }
    
    func setBarColor(color: Color) {
        self.bar.fillColor = color
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func updateConstraints() {
        super.updateConstraints()
    }
    
    func setText(str: String) {
        text.stringValue = str
    }
    
    func setTime(str: String) {
        time.stringValue = str
    }
    
    func setTime(doub: Double) {
        time.stringValue = String(Int(doub))
    }
    
    func setBar(num: Double) {
        if(num.isInfinite || num.isNaN) {
            bar.value = 0
        } else {
            bar.value = Int(num)
        }
    }
    
    func setBarMax(doub: Double) {
        self.bar.max = Int(doub)
    }
    
    func setValue(name: String, time: Double) {
        setText(str: name)
        setTime(doub: time)
        setBar(num: time)
    }
}
