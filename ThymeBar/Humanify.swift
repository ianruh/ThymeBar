//
//  Humanify.swift
//  ThymeBar
//
//  Created by Ian Ruh on 10/24/18.
//  Copyright © 2018 Ian Ruh. All rights reserved.
//

import Foundation

class Humanify {
    
    //Replacments for app names
    static let replacements: [String: String] = [
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
        "Slack":"Slack",
        "GitHub Desktop":"GitHub"
    ]
    
    static func parse(str: String) -> String {
        for (key, value) in replacements {
            if(str.contains(key)) {
                return value
            }
        }
        return str
    }
}
