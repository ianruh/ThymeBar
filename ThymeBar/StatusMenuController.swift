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
    
    @IBOutlet weak var testView: NSView!
    
    
    let statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
    
    var appItems: [AppItemView] = []
    var maxItems = 10
    var limitItems = true
    var itemThreshold = 0.05
    var applyThreshold = true
    
    override func awakeFromNib() {
        statusMenu.delegate = self
        
        let icon = NSImage(named: "statusIcon")
        icon?.isTemplate = true // best for dark mode
        statusItem.image = icon
        statusItem.menu = statusMenu
        update()
    }
    
    @IBAction func openSettingsClicked(_ sender: NSMenuItem) {
//        let window = NSWindow(contentRect: NSMakeRect(0, 0, NSScreen.main!.frame.midX, NSScreen.main!.frame.midY), styleMask: [.closable], backing: .buffered, defer: false)
//        window.title = "Thyme Settings"
//        window.isOpaque = true
//        window.center()
//        window.showsToolbarButton = true
//        window.isMovableByWindowBackground = true
//        window.backgroundColor = NSColor.lightGray
//        window.contentViewController = settingsViewController()
//        window.makeKeyAndOrderFront(nil)
//        window.makeKey()
        let settingsController:SettingsViewController = SettingsViewController()
        
    }
    
    @IBAction func quitClicked(sender: NSMenuItem) {
        NSApplication.shared.terminate(self)
    }
    
    func menuWillOpen(_ menu: NSMenu) {
        update()
    }
    
    func addAppItemView(view: AppItemView) {
        appItems.append(view)
        testView.addSubview(view)
    }
    
    func update() {
        let date = Date()
        let calendar = Calendar.current
        let year = calendar.component(.year, from: date)
        let month = calendar.component(.month, from: date)
        let day = calendar.component(.day, from: date)
        var monthString = String(month)
        var dayString = String(day)
        if(month < 10) {
            monthString = "0" + String(month)
        }
        if(day < 10) {
            dayString = "0" + String(day)
        }
        
        let file = String(String(year) + "-" + monthString + "-" + dayString + ".json")
        let path: String = String("file:///Users/ianruh/Dev/Scripts/Thyme/" + file)
        let thyme = Thyme(path: path)

        var pairs = thyme.getSortedTotals()
        
        if(applyThreshold) {
            for (index, app) in pairs.enumerated().reversed() {
                if(itemThreshold * Double(pairs[0].time) > Double(app.time)) {
                    pairs.remove(at: index)
                }
            }
        }
        
        if(limitItems && pairs.count > maxItems) {
            let removeNum = pairs.count - maxItems
            for _ in 0..<removeNum {
                _ = pairs.popLast()
            }
        }
        
        if(appItems.count > pairs.count) {
            let removeNum = appItems.count - pairs.count
            for _ in 0..<removeNum {
                appItems.remove(at: 0)
                testView.subviews.remove(at: 0)
            }
        } else if(appItems.count < pairs.count) {
            let addNum = pairs.count - appItems.count
            for _ in 0..<addNum {
                if let last = appItems.last {
                    addAppItemView(view: AppItemView(frame: CGRect(x: 0, y: last.frame.maxY + 5, width: 300, height: 20)))
                } else {
                    addAppItemView(view: AppItemView(frame: CGRect(x: 0, y: 0, width: 300, height: 20)))
                }
            }
        }
        
        for (index, view) in appItems.reversed().enumerated() {
            let max = Double(pairs[0].time)
            let value = Double(pairs[index].time)
            view.setBarMax(doub: max)
            view.setBar(num: value)
//            view.setValue(name: pairs[index].app, time: Double(pairs[index].time))
            view.setText(str: pairs[index].app)
            view.setTime(str: String(pairs[index].time))
            view.setBarColor(color: Crayola.random())
        }
        let frameWidth = 300
        let frameHeight = 25 * appItems.count - 5
        let frameSize = CGSize(width: frameWidth, height: frameHeight)
        testView.frame.size = frameSize
    }
}
