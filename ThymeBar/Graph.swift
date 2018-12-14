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
    var bars: Int?
    var data: [String: Double]?
    
    
    init(frame: CGRect, numBars: Int, dataArr: [String: Double]) {
        backColor = NSColor.systemGray.cgColor
        fillColor = NSColor.blue.cgColor
        data = dataArr
        bars = numBars
        super.init(frame: frame)
        
        //300 x 150 frame
        
        
        
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
