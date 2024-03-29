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
    @IBOutlet weak var weekGraph: NSView!
    
    
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
        updateGraph()
        setMenuSize()
    }
    
    func updateGraph() {
        var data: [[Date: Double]] = []
        var currentDay = Date.today
        
        
//        let dateFormatter = DateFormatter()
//        dateFormatter.dateFormat = "yyyy'-'MM'-'dd'T'HH':'mm':'ssZZZ"
//        var currentDay = dateFormatter.date(from: "2018-11-20T10:44:00+0000")!
        
        
        for _ in 0..<7 {
            var day = [currentDay: Double(0)]
            data.append(day)
            currentDay = currentDay.dayBefore
        }
        for i in 0..<7 {
            let path: String = String("file:///Users/ianruh/Dev/Scripts/Thyme/" + DateCust.parseDate(date: data[i].keys.first!))
            do {
                let thyme = Thyme(path: path)
                let pairs = thyme.getSortedTotals()
                var sum = 0
                pairs.forEach { pair in
                    sum += pair.time
                }
                data[i][data[i].keys.first!] = Double(sum)
            } catch {
                data[i][data[i].keys.first!] = Double(0)
            }
            
        }
        weekGraph.subviews.removeAll()
        let view = Graph(frame: weekGraph.frame, dataArr: data)
        weekGraph.addSubview(view)
    }
    
    func addAppItemView(view: AppItemView) {
        appItems.append(view)
        testView.addSubview(view)
    }
    
    func update() {
        let file = DateCust.today
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
        setMenuSize()
    }
    
    func setMenuSize() {
        let frameWidth = 300
        let frameHeight = 25 * appItems.count - 5
        let frameSize = CGSize(width: frameWidth, height: frameHeight)
        testView.frame.size = frameSize
    }
}
