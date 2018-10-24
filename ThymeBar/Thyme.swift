//
//  Thyme.swift
//  ThymeBar
//
//  Created by Ian Ruh on 10/24/18.
//  Copyright © 2018 Ian Ruh. All rights reserved.
//

import Foundation

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
        //Convert to minutes
        for (app, time) in totals {
            totals.updateValue(time/60, forKey: app)
        }
        return totals
    }
    
    func getSortedTotals() -> [AppTime] {
        var nums = getTotals()
        nums.removeValue(forKey: "Total")
        
        var pairs: [AppTime] = []
        for (key, value) in nums {
            pairs.append(AppTime(time: value,app: key))
        }
        pairs.sort {
            return $0.time > $1.time
        }
        return pairs
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

struct Window {
    var id: Int64
    var desktop: Int
    var name: String
    
    init(win: [String: Any]) {
        id = win["ID"] as! Int64
        desktop = win["Desktop"] as! Int
        name = win["Name"] as! String
    }
    
    //Use Humanify class to make prettier names
    func getName() -> String {
        return Humanify.parse(str: name)
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
    //Empty constructor
    init() {}
}
