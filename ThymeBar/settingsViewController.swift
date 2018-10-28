//
//  settingsViewController.swift
//  ThymeBar
//
//  Created by Ian Ruh on 10/27/18.
//  Copyright © 2018 Ian Ruh. All rights reserved.
//

import Cocoa
import CoreData

class settingsViewController: NSViewController {
    @IBOutlet weak var limitByNumberOutlet: NSButton!
    @IBOutlet weak var limitByThresholdOutlet: NSButton!
    @IBOutlet weak var limitByNumberText: NSTextField!
    @IBOutlet weak var limitByThresholdText: NSTextField!
    @IBOutlet weak var lowToHighOutlet: NSButton!
    @IBOutlet weak var highToLowOutlet: NSButton!
    @IBOutlet weak var filePathText: NSTextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let appDelegate = NSApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Settings")
        //request.predicate = NSPredicate(format: "age = %@", "12")
        request.returnsObjectsAsFaults = false
        do {
            let result = try context.fetch(request)
            for data in result as! [NSManagedObject] {
                print(data.value(forKey: "limitThreshold") as! String)
            }
            
        } catch {
            
            print("Failed")
        }
    }
    @IBAction func applyButtonClicked(_ sender: NSButton) {
        
    }
    
    @IBAction func cancelButtonClicked(_ sender: NSButton) {
        
    }
}
