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
    var bar: NSProgressIndicator!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        let textFrame = CGRect(x: 20, y: 80, width: 33, height: 17)
        let barFrame = CGRect(x: 90, y: 78, width: 135, height: 20)
        let timeFrame = CGRect(x: 230, y: 80, width: 60, height: 17)
        
        text = NSTextField(frame: textFrame)
        text.isBezeled = false
        text.drawsBackground = false
        text.isEditable = false
        text.isSelectable = false
        text.font = NSFont.systemFont(ofSize: NSFont.systemFontSize)
        
        bar = NSProgressIndicator(frame: barFrame)
        let hueAdjust = CIFilter(name: "CIHueAdjust", parameters: ["inputAngle": NSNumber(value: 1.7)])!
        bar.contentFilters = [hueAdjust]
        
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
        time.stringValue = str
    }
    
    func setTime(doub: Double) {
        time.stringValue = String(doub)
    }
    
    func setBar(num: Double) {
        bar.doubleValue = num
    }
    
    func setBarMax(doub: Double) {
        bar.maxValue = doub
    }
    
    func setValue(name: String, time: Double) {
        self.text.stringValue = name
        self.time.stringValue = String(Int(time)) + " Min"
        self.bar.doubleValue = time
    }
}
