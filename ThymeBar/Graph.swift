//
//  Graph.swift
//  ThymeBar
//
//  Created by Ian Ruh on 11/17/18.
//  Copyright © 2018 Ian Ruh. All rights reserved.
//

import Foundation
import AppKit

class Graph: NSView {
    
    var backColor: CGColor?
    var fillColor: CGColor?
    var barCount: Int?
    var data: [[Date: Double]]?
    var days: [DayItemView] = []
    
    var dayNames: [Int: String] = [0:"Sun", 1:"Mon", 2:"Tue", 3:"Wed", 4:"Thur", 5:"Fri", 6:"Sat"]
    
    init(frame: CGRect, dataArr: [[Date: Double]]) {
        backColor = NSColor.systemGray.cgColor
        fillColor = NSColor.blue.cgColor
        data = dataArr
        data?.reverse()
        barCount = dataArr.count
        super.init(frame: frame)
        
        //300 x 170 frame
        //10 boundary, so 280 left
        // 40 each, 5 pad -- 30 bar -- 5 pad
        drawDays()
        drawUnits()
    }
    
    func drawDays() {
        var position = 15
        let incriment = 40
        let color = Crayola.random()
        for i in 0..<barCount! {
            let dayFrame = CGRect(x: position, y: 20, width: incriment, height: 150)
            let day = DayItemView(frame: dayFrame, color: color)
            day.setBar(num: data![i][data![i].keys.first!]!)
            day.setText(str: dayNames[data![i].keys.first!.dayNumberOfWeek()]!)
            day.setTime(str: String(Int(data![i][data![i].keys.first!]!)))
            position += incriment
            days.append(day)
            self.addSubview(day)
        }
        setMax()
    }
    
    func drawUnits() {
        let textFrame = CGRect(x: 0, y: 0, width: 300, height: 20)
        let text = NSTextField(frame: textFrame)
        text.isBezeled = false
        text.drawsBackground = false
        text.isEditable = false
        text.isSelectable = false
        text.font = NSFont.systemFont(ofSize: NSFont.systemFontSize)
        text.textColor = NSColor.lightGray
        text.alignment = NSTextAlignment.center
        text.stringValue = "Minutes"
        self.addSubview(text)
    }
    
    func setMax() {
        var max: Double = 0
        data!.forEach {num in
            if(num[num.keys.first!]! > max) {
                max = num[num.keys.first!]!;
            }
        }
        days.forEach { day in
            day.setBarMax(doub: max)
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}

//let file = DateCust.today
//let path: String = String("file:///Users/ianruh/Dev/Scripts/Thyme/" + file)
//let thyme = Thyme(path: path)
