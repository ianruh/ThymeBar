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
        var nums = thyme.getTotals()
        nums.removeValue(forKey: "Total")

        var pairs: [AppTime] = []
        for (key, value) in nums {
            pairs.append(AppTime(time: value,app: key))
        }
        pairs.sort {
            return $0.time > $1.time
        }
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

struct AppTime {
    var time = 0;
    var app = ""
    init(time: Int, app: String) {
        self.time = time
        self.app = app
    }
}

class Thyme {
    var snapshots: Snapshots = Snapshots()
    
    init(path: String) {
        let data = getData(path: path)!
        let json = try? JSONSerialization.jsonObject(with: data, options: [])
        
        if let dictionary = json as? [String: Any] {
            if let snapshotsAny = dictionary["Snapshots"] as? [Any] {
                snapshots = Snapshots(snapshots: snapshotsAny)
            }
        }
    }
    
    func getData(path: String) -> Data? {
        let fileURL = URL(string: path)
        do {
            let text = try String(contentsOf: fileURL!, encoding: .utf8)
            let data:Data = text.data(using: String.Encoding.utf8)!
            return data;
        }
        catch {
            print(error)
        }
        return nil;
    }
    
    func getTotals() -> [String: Int] {
        //Currently in seconds
        var totals = ["Total": 0]
        for time in snapshots.times {
            let totalAdd = totals["Total"]!
            totals.updateValue(totalAdd, forKey: "Total")
            var newValue = 30
            if let index = totals.index(forKey: time.getActiveName()) {
                newValue = totals[index].value + 30
            }
            totals.updateValue(newValue, forKey: time.getActiveName())
            
        }
        for (app, time) in totals {
            totals.updateValue(time/60, forKey: app)
        }
        return totals
    }
}

struct Window {
    var id: Int64
    var desktop: Int
    var name: String
    
    let replacments: [String: String] = [
        "Terminal":"Terminal",
        "Xcode":"Xcode",
        "Notes":"Notes",
        "Chrome":"Chrome",
        "Preview":"Preview",
        "Dash":"Dash",
        "Numbers":"Numbers",
        "Finder":"Finder",
        "Automator":"Automator",
        "Mail":"Mail",
        "Pages":"Pages",
        "Plex Media Player":"Plex",
        "Slack":"Slack"
    ]
    
    init(win: [String: Any]) {
        id = win["ID"] as! Int64
        desktop = win["Desktop"] as! Int
        name = win["Name"] as! String
    }
    
    //To filter out anoying suwhsuws - Chrome stuff
    func getName() -> String {
        for (key, value) in replacments {
            if(name.contains(key)) {
                return value
            }
        }
        return name
    }
}

struct Time {
    //Visible is an array of Ints
    var time: String
    var active: Int64
    var windows: [Window] = []
    
    init(tim: [String: Any]) {
        //let dateFormatter = ISO8601DateFormatter()
        //time = dateFormatter.date(from: tim["Time"] as! String)!
        time = tim["Time"] as! String
        active = tim["Active"] as! Int64
        if let windowArr = tim["Windows"] as? [Any] {
            for window in windowArr {
                windows.append(Window(win: window as! [String: Any]))
            }
        }
    }
    
    //Gets active window name or returns "" if not found.
    func getActiveName() -> String {
        for window in windows {
            if(window.id == active) {
                return window.getName()
            }
        }
        return "Unknown"
    }
    
}

struct Snapshots {
    var times: [Time] = []
    
    init(snapshots: [Any]) {
        for snap in snapshots {
            if let time = snap as? [String: Any] {
                times.append(Time(tim: time))
            }
        }
    }
    
    init() {
        
    }
}
