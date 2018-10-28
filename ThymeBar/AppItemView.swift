//
//  AppItemView.swift
//  ThymeBar
//
//  Created by Ian Ruh on 10/24/18.
//  Copyright © 2018 Ian Ruh. All rights reserved.
//

import Foundation
import AppKit
import Cocoa
import CoreImage

class AppItemView: NSView {
    var shouldSetupConstraints = true
    
    var text: NSTextField!
    var time: NSTextField!
    var bar: Bar!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        let textFrame = CGRect(x: 20, y: 0, width: 65, height: 17)
        let timeFrame = CGRect(x: 230, y: 0, width: 60, height: 17)
        
        text = NSTextField(frame: textFrame)
        text.isBezeled = false
        text.drawsBackground = false
        text.isEditable = false
        text.isSelectable = false
        text.font = NSFont.systemFont(ofSize: NSFont.systemFontSize)
        
        let barFrame = CGRect(x: 90, y: 4, width: 135, height: 5)
        bar = Bar(frame: barFrame, background: NSColor.lightGray.cgColor, fill: Crayola.random())
        bar.radius = 2
        
        time = NSTextField(frame: timeFrame)
        time.isBezeled = false
        time.drawsBackground = false
        time.isEditable = false
        time.isSelectable = false
        time.font = NSFont.systemFont(ofSize: NSFont.systemFontSize)

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
        if(shouldSetupConstraints) {
            // AutoLayout constraints
            shouldSetupConstraints = false
        }
        super.updateConstraints()
    }
    
    func setText(str: String) {
        text.stringValue = str
    }
    
    func setTime(str: String) {
        time.stringValue = str + " Min"
    }
    
    func setTime(doub: Double) {
        time.stringValue = String(Int(doub)) + " Min"
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
