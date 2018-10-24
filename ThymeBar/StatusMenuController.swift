//
//  StatusMenuController.swift
//  ThymeBar
//
//  Created by Ian Ruh on 10/21/18.
//  Copyright © 2018 Ian Ruh. All rights reserved.
//

import Cocoa

class StatusMenuController: NSObject, NSMenuDelegate {
    @IBOutlet weak var statusMenu: NSMenu!
    @IBOutlet weak var app1: NSTextField!
    @IBOutlet weak var app2: NSTextField!
    @IBOutlet weak var app3: NSTextField!
    @IBOutlet weak var app4: NSTextField!
    
    @IBOutlet weak var time1: NSTextField!
    @IBOutlet weak var time2: NSTextField!
    @IBOutlet weak var time3: NSTextField!
    @IBOutlet weak var time4: NSTextField!
    
    @IBOutlet weak var bar1: NSProgressIndicator!
    @IBOutlet weak var bar2: NSProgressIndicator!
    @IBOutlet weak var bar3: NSProgressIndicator!
    @IBOutlet weak var bar4: NSProgressIndicator!
    
    var item1: AppItem = AppItem()
    var item2: AppItem = AppItem()
    var item3: AppItem = AppItem()
    var item4: AppItem = AppItem()
    
    
    let statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
    
    override func awakeFromNib() {
        statusMenu.delegate = self
        item1 = AppItem(nam: app1, tim: time1, ba: bar1)
        item2 = AppItem(nam: app2, tim: time2, ba: bar2)
        item3 = AppItem(nam: app3, tim: time3, ba: bar3)
        item4 = AppItem(nam: app4, tim: time4, ba: bar4)        
        
        let icon = NSImage(named: "statusIcon")
        icon?.isTemplate = true // best for dark mode
        statusItem.image = icon
        statusItem.menu = statusMenu
    }
    
    @IBAction func updateClicked(_ sender: NSMenuItem) {
        print("Update Clicked")
    }
    
    @IBAction func quitClicked(sender: NSMenuItem) {
        NSApplication.shared.terminate(self)
    }
    
    func menuWillOpen(_ menu: NSMenu) {
        update()
    }
    
    func update() {
        let date = Date()
        let calendar = Calendar.current
        let year = calendar.component(.year, from: date)
        let month = calendar.component(.month, from: date)
        let day = calendar.component(.day, from: date)
        
        let file = String(String(year) + "-" + String(month) + "-" + String(day) + ".json")
        let path: String = String("file:///Users/ianruh/Dev/Scripts/Thyme/" + file)
        let thyme = Thyme(path: path)

        let pairs = thyme.getSortedTotals()
        
        item1.bar.maxValue = Double(pairs[0].time)
        item2.bar.maxValue = Double(pairs[0].time)
        item3.bar.maxValue = Double(pairs[0].time)
        item4.bar.maxValue = Double(pairs[0].time)
        
        item1.time.stringValue = String(pairs[0].time) + " Min"
        item1.name.stringValue = pairs[0].app
        item1.bar.doubleValue = Double(pairs[0].time)
        
        item2.time.stringValue = String(pairs[1].time) + " Min"
        item2.name.stringValue = pairs[1].app
        item2.bar.doubleValue = Double(pairs[1].time)
        
        item3.time.stringValue = String(pairs[2].time) + " Min"
        item3.name.stringValue = pairs[2].app
        item3.bar.doubleValue = Double(pairs[2].time)
        
        item4.time.stringValue = String(pairs[3].time) + " Min"
        item4.name.stringValue = pairs[3].app
        item4.bar.doubleValue = Double(pairs[3].time)
    }
}

struct AppItem {
    var name: NSTextField
    var time: NSTextField
    var bar: NSProgressIndicator
    init(nam: NSTextField, tim: NSTextField, ba: NSProgressIndicator) {
        name = nam
        time = tim
        bar = ba
    }
    init () {
        name = NSTextField()
        time = NSTextField()
        bar = NSProgressIndicator()
    }
}
